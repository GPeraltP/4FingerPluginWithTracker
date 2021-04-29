//
//  VeridiumRegistrationPresenter.swift
//  VeridiumAuthenticator
//
//  Created by Catalin Stoica on 11/01/2018.
//  Copyright © 2018 VeridiumIP. All rights reserved.
//

import UIKit
import VeridiumBOPS

protocol VeridiumRegistrationPresenterProtocol {
    func submit()
    func advanceEnrollment()
    func renderPageForProfile(_ profile:VeridiumProfileData?)
    func generateFormForView(view:UIView)
    func onResend()
    func lastRenderedFrame() -> CGRect
}

class VeridiumRegistrationPresenter: AbstractPresenter<VeridiumRegisterViewController>, VeridiumRegistrationPresenterProtocol, VeridiumDynamicFormsGeneratorDelegate {
    
    var theRegistrationMode:VeridiumBOPSRegistrationModeDefinitionData = VeridiumBOPSRegistrationModeDefinitionData()
    var theForm:VeridiumDynamicFormsGenerator? = nil

    lazy var theIntegration: VeridiumBOPSIntegrationDefinitionData = {
        if let profileIntegration = self.genericView.profile?.integration {
            return profileIntegration
        } else {
            return (integrationForOngoingBopsRegistration != nil ? integrationForOngoingBopsRegistration : bopsPairingData.integration)!
        }
    }()
    
    let bopsPairingData: VeridiumBOPSPairingData
    weak var totpPresenter: TOTPEnrolmentPresenter? // only used to add TOTP only profiles\
    weak var revocationService: VIDRevocationService?
    weak var accountService: VeridiumAccountService?
    
    init(revocationService: VIDRevocationService?, bopsAccountService: VeridiumAccountService?, bopsPairingData: VeridiumBOPSPairingData, totpPresenter: TOTPEnrolmentPresenter) {
        self.revocationService = revocationService
        self.accountService = bopsAccountService
        self.bopsPairingData = bopsPairingData
        self.totpPresenter = totpPresenter
    }
    
    override func setView(view: VeridiumRegisterViewController) {
        self.genericView = view
    }
    
    func renderPageForProfile(_ profile:VeridiumProfileData?) {
        
        let (_, registrationMode) = hasExtraEnrollmentStep(integration: theIntegration, status: profile?.status)
            if let registrationMode = registrationMode {
                self.genericView.updatePageForDescription(description: registrationMode.title.uppercased(),
                                                          nextButton: registrationMode.enrollmentStepActionName ?? L10n.veridiumSdkNextAllcaps,
                                                      resendButton: registrationMode.restartEnrollmentStepActionName,
                                                      hint: registrationMode.hint)
                theRegistrationMode = registrationMode
            }
        
    }
    
    func generateFormForView(view: UIView) {
        theForm = VeridiumDynamicFormsGenerator(view: view, registrationMode: theRegistrationMode, delegate:self)
    }
    
    func lastRenderedFrame() -> CGRect {
        return theForm!.lastRenderedFrame
    }
    
    func handleFormDataSubmited() {
        if nil != self.genericView.profile {
            self.advanceEnrollment()
            return;
        }
        self.submit()
    }
    
    func advanceEnrollment() {
        self.theForm?.dismissKeyboard(sender: nil)
        guard let profile = genericView.profile,
            let loginData = theForm?.collectSubmitedData().toNSDictoinary.jsonString else {
            return
        }
        let requestBody = ["profileId" : profile.profileId,
                           "loginData" : loginData] as [String : Any]
        self.genericView.showProcessing() {
            if let bopsAccountService = self.accountService as? VeridiumBOPSAccountService,
                let bopsAccount = bopsAccountService.activeBopsAccount {
                bopsAccount.bopsAdvanceEnrollment(forProfileId: profile.profileId, params: requestBody, withCompletion: { (profileAdvancedEnrolment, error) in
                    if let error = error {
                        print("BOPS AdvancedEnrollment \n \(error.localizedDescription)")
                        let nsError = error.toNSError
                        // Number of SMS trials are exceeded
                        if nsError.code == 2001 || nsError.code == 2002 {
                            self.abortRegistration(for: profile, in: bopsAccount, with: error)
                            return
                        }
                        
                        self.genericView.onAdvancedEnrollmentFailed(error: error)
                        return
                    }
                    
                    if let profileAdvancedEnrolment = profileAdvancedEnrolment {
                        bopsAccountService.activeAccount?.refreshProfiles(withForce: true, completion: { (error) in
                            if let error = error {
                                print("BOPS Refresh Profiles error: \n\(error.localizedDescription)")
                            }
                            self.genericView.onAdvancedEnrollmentSuccessfull(profile: profileAdvancedEnrolment)
                        })
                    }
                })
            } else {
                self.genericView.dismissProcessing(onDismiss: nil)
            }
        }
    }
    
    private func abortRegistration(for profile:VeridiumProfileData, in account: VeridiumBOPSAccount, with error: Error) {
        if account.profiles.count > 1 {
            account.bopsDeleteProfile(profile.profileId) { _ in
                self.genericView.onProfileRegistrationFailed(error: error)
            }
        } else {
            self.revocationService?.wipeAccount {
                self.genericView.onRegisterFail(error: error)
            }
        }
    }
    
    func submit() {
        DispatchQueue.main.async {
            if let theForm = self.theForm {
                theForm.dismissKeyboard(sender: nil)
                if theForm.validateData() == true {
                    self.registerProfileOrAccount(profileData: theForm.collectSubmitedData())
                }
            }
        }
    }
    
    func submit(userEnrollToken: String) {
        DispatchQueue.main.async {
            var jsonDictionary: [String: String]?
            if let data = userEnrollToken.data(using: .utf8) {
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
                } catch {
                    print(error.localizedDescription)
                    // fall back to raw token
                    jsonDictionary = ["raw":userEnrollToken]
                }
                self.registerProfileOrAccount(profileData: jsonDictionary!)
            }
        }
    }
    
    private func registerProfileOrAccount(profileData: [String: String]) {
        if (accountService?.activeAccount) != nil {
            registerProfile(profileData: profileData)
        } else {
            registerAccount(accountData: profileData)
        }
    }
    
    func cancelEnrollment() {
        self.genericView.showProcessing(whenShown: {
            
            // The if below translates to:
            // if this is the first account errolled ||\
            // the account was enrolled && it is in 'advance enrollment' state && this is the first profile enrolled
            // then wipe the account and start over.
            if (self.accountService?.activeAccount == nil) ||
                (self.accountService?.activeAccount != nil && self.genericView.profile != nil && self.accountService?.activeAccount?.privateProfilesCount == 1) {

                self.revocationService?.wipeAccount {
                    self.genericView.onRegisterCancelled()
                }
            }
            else {
                self.genericView.onRegisterCancelled()
            }
        })
    }
    
    func registerAccount(accountData:[String: String]) {
        self.genericView.showProcessing() { [unowned self] in
            self.accountService?.register(with: nil,
                             integration: self.theIntegration,
                             registrationMode: "form",
                             loginData: accountData,
                             txSignProtectionLevel: VeridiumTXSigningProtectionNone,
                             withCompletion: { (account, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                    self.genericView.onRegisterFail(error: VIDMobileSDKError(.enrolmentFailed(.accountRegistrationFailed(error))))
                                    return
                                }
                                
                                if let account = account {
                                    let profile = account.profiles[0]
                                    let image = UIImage(named: "profile-icon", in: Bundle(for: GetBundle.self), compatibleWith: nil)
                                    let alias: String = profile.getDefaultAlias()
                                    profile.updateProfile(alias: alias,
                                                          image: image!,
                                                          integration: self.theIntegration,
                                                          authenticationHand: nil)
                                    
                                    forceReenrollData = VeridiumRemoteConfigForceEnrollData.newFomJson(json: ["lastUpdatedAppVersion" : Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String,
                                                                                                              "isForceEnrolled"       : isForceReenrollNeeded.stringValue()].toNSDictoinary.jsonString!)
                                    
                                    do {
                                        try self.checkAccountHasAllRequiredMethods(profile)
                                    } catch {
                                        self.revocationService?.wipeAccount {
                                            self.genericView.onRegisterFail(error: error)
                                        }
                                        return
                                    }

                                    account.fetchLicenseAndValidate(withForce: true, completion: { (error) in
                                        if let error = error {
                                            let vidError = VIDMobileSDKError(.enrolmentFailed(.accountRegistrationFailed(error)))
                                            self.genericView.onRegisterAccountInvalidLicense(error: vidError)
                                            return;
                                        }
                                        self.genericView.onAccountRegistrationSuccess()
                                    })
                                }
            })
        }
    }
    
    func registerProfile(profileData:[String: String]) {
        self.genericView.showProcessing() { [unowned self] in
            if let account = self.accountService?.activeAccount {
                account.registerProfile(self.theIntegration,
                                            registrationMode: "form",
                                            credentials: profileData,
                                            txSignProtectionLevel: VeridiumTXSigningProtectionNone,
                                            withCompletion: { (profile, error) in
                                                if let error = error {
                                                    let vidError = VIDMobileSDKError(.enrolmentFailed(.profileRegistrationFailed(error)))
                                                    self.genericView.onProfileRegistrationFailed(error: vidError)
                                                    return
                                                }
                                                
                                                if let profile = profile {
                                                    let alias: String = profile.getDefaultAlias()
                                                    let image = UIImage(named: "profile-icon", in: Bundle(for: GetBundle.self), compatibleWith: nil)
                                                    profile.updateProfile(alias: alias,
                                                                          image: image!,
                                                                          integration: self.theIntegration,
                                                                          authenticationHand: AuthHand(enrolledHand: EnrollHand(hand: account.enrolledHand)))
                                                    if profile.containsTOTP {
                                                        self.totpPresenter?.enrolmentResult = self
                                                        self.totpPresenter?.onEnrolTOTP(withProfile: profile)
                                                    } else {
                                                        self.genericView.onProfileRegistrationSuccess(profile: profile)
                                                    }
                                                }
                })
            }
        }
    }
    
    private func checkAccountHasAllRequiredMethods(_ profile: VeridiumProfileData) throws {
        let requiredMethods = Set(profile.requiredBiometricMethods ?? [])
        let availableMethods = Set(profile.availableBiometricMethods ?? [])
        if (!requiredMethods.isSubset(of: availableMethods)) {
            let missingRequiredMethods = requiredMethods.subtracting(availableMethods)
            let missingRequiredMethodsJoined = missingRequiredMethods.joined(separator: ",")
            throw VIDMobileSDKError(.enrolmentFailed(.requiredMethodsNotAvailableForAccount(missingRequiredMethodsJoined)))
        }
    }
    
    func onResend() {
        self.genericView.showProcessing() { [unowned self] in
            if let bopsAccountService = self.accountService as? VeridiumBOPSAccountService {
                bopsAccountService.activeBopsAccount?.bopsRestartEnrollmentStep(forProfileId: self.genericView.profile!.profileId, withCompletion: { (profile, error) in
                    self.genericView.dismissProcessing(onDismiss: {
                        if let error = error {
                            print(error)
                            self.genericView.onRegisterFail(error: error)
                            return
                        }
                    })
                })
            } else {
                self.genericView.dismissProcessing(onDismiss: nil)
            }
        }
    }
}

extension VeridiumRegistrationPresenter: BiometricsEnrollmentProtocol {
    func onBiometricEnrollmentSucceeded() {
        if let profileData = totpPresenter?.registeredProfileData {
            genericView.onProfileRegistrationSuccess(profile: profileData)
        } else {
            genericView.onRegisterCancelled()
        }
    }
    
    func onBiometricEnrollmentFailed(error: Error) {
        genericView.onRegisterFail(error: error)
    }

    func onEnrollmentCancelled() {
        genericView.onRegisterCancelled()
    }
}
