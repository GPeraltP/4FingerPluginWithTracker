//
//  BiometricsEnrollmentProtocol.swift
//  VeridiumAuthenticator
//
//  Created by Catalin Stoica on 18/01/2018.
//  Copyright © 2018 VeridiumIP. All rights reserved.
//

import VeridiumBOPS

protocol BiometricEnrollmentPresenterProtocol{
    func onEnroll(for method:String)
    func onCancelEnrollment()
}

class BiometricEnrollmentPresenter: BiometricEnrollmentPresenterProtocol {

    var enrolmentResult: BiometricsEnrollmentProtocol?

    private let pairingData: VeridiumBOPSPairingData
    private weak var revocationService: VIDRevocationService?
    private weak var veridiumSDK: VeridiumSDK?
    private weak var accountService: VeridiumAccountService?
    
    init(revocationService: VIDRevocationService?, veridiumSDK: VeridiumSDK?, accountService: VeridiumAccountService?, pairingData: VeridiumBOPSPairingData) {
        self.revocationService = revocationService
        self.veridiumSDK = veridiumSDK
        self.accountService = accountService
        self.pairingData = pairingData
    }
    
    func onEnroll(for method:String) {
        do {
            if let bopsAccount = accountService?.activeAccount as? VeridiumBOPSAccount {
                try bopsAccount.validateBiolibLicense(for: method)
            }
        } catch {
            onFailEnrollment(error)
            return
        }
        
        veridiumSDK?.enroller(forMethod: method)?.enroll!({ (vector) in
            guard let veridiumSDK = self.veridiumSDK,
                let account = self.accountService?.activeAccount,
                let profile = account.profiles.first else {
                    self.onFailEnrollment(VIDMobileSDKError(.enrolmentFailed(.enrolmentFailedWithReason(method, "Profile not found."))))
                    return
            }
            
            if (method == kBiometricEngineName4F) {
                let enrolledHand = vector.getEnrolledHand()
                account.enrolledHand = enrolledHand.description
                profile.authenticationConfigDict[kBioLibConfig4FHand] = enrolledHand == .both ?
                    EnrollHand.left.description : enrolledHand.description
            }
            
            let theIntegration = integrationForOngoingBopsRegistration ?? self.pairingData.integration
            let authenticatorType = theIntegration.authenticatorType
            
            // check productversion
            if isOlderThanAPI(version: self.pairingData.productVersion) {
                account.changeBiometrics([vector], authenticatorType: authenticatorType, withCompletion: { (error) in
                    if let error = error {
                        print(error)
                        self.onFailEnrollment(VIDMobileSDKError(.enrolmentFailed(.enrolmentFailed(method, error))))
                        return
                    }
                    
                    self.enrolmentResult?.onBiometricEnrollmentSucceeded()
                })
            } else {
                guard let auth = veridiumSDK.authenticator(forMethod: method as String) else {
                    self.onFailEnrollment(VIDMobileSDKError(.enrolmentFailed(.enrolmentFailedWithReason(method, "Error finding authenticator."))))
                    return
                }
                
                guard let BOPSAccountService = veridiumSDK.bopsAccountService(forURL: self.pairingData.url) else {
                    self.onFailEnrollment(VIDMobileSDKError(.enrolmentFailed(.enrolmentFailedWithReason(method, "Missing account service."))))
                    return
                }
                
                guard let kcStore = BOPSAccountService.activeAccount?.kcStore,
                    let mapString = kcStore["pkeymap"] as NSString?,
                    let registrationId: String = mapString.jsonDictionary?[profile.profileId] as? String else {
                        self.onFailEnrollment(VIDMobileSDKError(.enrolmentFailed(.enrolmentFailedWithReason(method, "Profile id not found."))))
                        return
                }
                
                // generate signingKeys
                let protectionLevel = VeridiumTXSigningProtectionNone
                var error: NSError? = nil
                let keyPairGenerateResult: VeridiumSigningKey = veridiumSDK.txSigningRegistry.generateKeyPair(for: auth, protectionLevel: protectionLevel, registrationID: registrationId, error: &error)
                
                if let error = error {
                    self.onFailEnrollment(VIDMobileSDKError(.enrolmentFailed(.enrolmentFailed(method, error))))
                    return
                }
                
                // check local vs server vectors
                let vectors: [Any] = BOPSAccountService.processVector([vector], basedOnAuthType: theIntegration.authenticatorType)
                let remoteVectors: [VeridiumBiometricVector] = vectors[0] as! [VeridiumBiometricVector]
                let localVectors: [VeridiumBiometricVector] = vectors[1] as! [VeridiumBiometricVector]
                
                for vector in localVectors {
                    // store local
                    vector.store(into: kcStore)
                }
                           
                var dataObject: [String: Any] = [
                    "authenticationKey": ["algorithm": "SHA256withECDSA",
                                          "publicKey":keyPairGenerateResult.publicKey.base64EncodedString()]
                ]
                
                for vector in remoteVectors {
                    var vectorDict = vector.asDictionary
                    vectorDict.removeValue(forKey: "type")
                    dataObject["biometricTemplate"] = vectorDict
                }
                
                let transportObject: [String: Any] = [
                    "name": method,
                    "profileId": profile.profileId,
                    "data": dataObject
                ]
                
                account.setAuthenticationMethods(transportObject) { (error) in
                    if let error = error {
                        self.onFailEnrollment(VIDMobileSDKError(.enrolmentFailed(.enrolmentFailed(method, error))))
                    } else {
                        self.enrolmentResult?.onBiometricEnrollmentSucceeded()
                    }
                }
            }
        }, onFail: {
            self.onFailEnrollment(VIDMobileSDKError(.enrolmentFailed(.enrolmentFailedWithReason(method, "Biometric Enrolment Failed."))))
        }, onCancel: {
            self.onCancelEnrollment()
        }, onError: { (error) in
            self.onFailEnrollment(VIDMobileSDKError(.enrolmentFailed(.enrolmentFailed(method, error))))
        })
    }
    
    fileprivate func onFailEnrollment(_ error: Error) {
        revocationService?.wipeAccount {
            self.enrolmentResult?.onBiometricEnrollmentFailed(error: error)
        }
    }
    
    func onCancelEnrollment() {
        revocationService?.wipeAccount {
            self.enrolmentResult?.onEnrollmentCancelled()
        }
    }
}

fileprivate extension VeridiumBiometricFullVector {
    func getEnrolledHand() -> EnrollHand {
        guard let enrolledHandStr = self.asDictionary["capturedHand"] as? String else {
            return .either
        }
        
        return EnrollHand(hand: enrolledHandStr)
    }
}
