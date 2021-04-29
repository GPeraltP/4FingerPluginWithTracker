//
//  VIDPairingService.swift
//  VeridiumAuthenticator
//
//  Created by Catalin Stoica on 04/01/2018.
//  Copyright © 2018 VeridiumIP. All rights reserved.
//

import UIKit
import VeridiumQRReader
import VeridiumCore
import VeridiumBOPS
import VeridiumBiometricsOnly


public class VIDPairingService: VeridiumQRViewProtocol {
    
    typealias KeyValueStoreProvider = () -> VeridiumKeyValueStore
    typealias PairingCompletion = (_ pairedEnvironment: VIDEnvironment?, _ error: VIDMobileSDKError?) -> ()
    
    private static let kADIntegrationExternalId: String = "AD"
    private static let kADMSEIntegrationExternalId: String = "ADv2MultiStepEnrollment"
    private static let kIdentifierQRCodeViewController: String = "veridiumQrReader"
    private static let kOtpIntegrationExternalId: String = "OTP"
    private static let kOtpPairingUrl: String = "otpauth://"
    private static let kStorePairingsKey: String = "BOPSPairings"

    static var keyValueStoreProvider: KeyValueStoreProvider = {
        VeridiumUserDefaultsKeyValueStore.global
    }
    
    private let veridiumSDK: VeridiumSDK
    private let vidMobileSDK: VIDMobileSDK
    private let pairedEnvironmentsSerialQueue = DispatchQueue(label: "com.veridiumid.vidsetupservice.pairedenvironments")
    private var pairedEnvironmentDependencies: [String: PairedEnvironmentDependencies] = [:]
    
    public static let shared = VIDPairingService()
    internal var pushRegistrationToken: Data?
    internal lazy var completionHandler: PairingCompletion = { (_, _) in
        print ("ERROR: completion handler not supplied in pairing")
    }
    
    init(veridiumSDK: VeridiumSDK = VeridiumSDK.shared, vidMobileSDK: VIDMobileSDK = VIDMobileSDK.shared()) {
        self.veridiumSDK = veridiumSDK
        self.vidMobileSDK = vidMobileSDK
    }
    
    func setupPairedEnvironmentDependencies() {
        pairedEnvironmentsSerialQueue.sync {
            for (domainRoot, pairingInfo) in VIDPairingService.bopsPairings {
                pairedEnvironmentDependencies[domainRoot] = PairedEnvironmentDependencies(bopsPairingData: pairingInfo)
            }
        }
    }
    
    func getPairedEnvironmentDependencies(environmentId: String) -> PairedEnvironmentDependencies? {
        // TODO: implement multiplexing for appropriate environment
        pairedEnvironmentsSerialQueue.sync {
            return pairedEnvironmentDependencies[environmentId]
        }
    }
    
    func getAllPairedEnvironmentDependencies() -> [PairedEnvironmentDependencies] {
        pairedEnvironmentsSerialQueue.sync {
            return Array(pairedEnvironmentDependencies.values)
        }
    }
    
    func getPairedEnvironmentDependencies(profileInternalId: String) -> PairedEnvironmentDependencies? {
        pairedEnvironmentsSerialQueue.sync {
            for dependencies in pairedEnvironmentDependencies.values {
                if (dependencies.profileManager.retrieveProfilesCached().contains {
                    $0.id == profileInternalId
                }) {
                    return dependencies
                }
            }
            return nil
        }
    }
    
    private func addPairedEnvironmentDependencies(_ dependencies: PairedEnvironmentDependencies) {
        pairedEnvironmentsSerialQueue.sync {
            pairedEnvironmentDependencies[dependencies.bopsPairingData.url] = dependencies
        }
    }
    
    // TODO: Temporarily use this one before finishing multiplexing implementation
    func getFirstEnvironmentDependency() -> PairedEnvironmentDependencies? {
        pairedEnvironmentsSerialQueue.sync {
            return pairedEnvironmentDependencies.first?.value
        }
    }
    
    func removePairedEnvironmentDependencies(environmentId: String) {
        pairedEnvironmentsSerialQueue.sync {
            pairedEnvironmentDependencies.removeValue(forKey: environmentId)
            var currentPairings = VIDPairingService.bopsPairings
            currentPairings.removeValue(forKey: environmentId)
            VIDPairingService.bopsPairings = currentPairings
        }
    }
    
    func pairWithQRCode(completion: @escaping PairingCompletion) {
        // start workflow by scanning the QR. The delegate will continue the workflow
        completionHandler = completion
        
        let QRCodeReader = UIStoryboard(name: "ModalViewControllers", bundle: Bundle(identifier: "com.veridiumid.VeridiumOrchestrator")).instantiateViewController(withIdentifier: VIDPairingService.kIdentifierQRCodeViewController) as! VeridiumQrReaderViewController
        QRCodeReader.delegate = self
        QRCodeReader.descriptionText = L10n.veridiumSdkPairingQrDescription
        QRCodeReader.helpText = L10n.veridiumSdkPairingQrHelp
        VeridiumUtils.topmostViewController().present(QRCodeReader, animated: true, completion: nil)
    }
    
    func pairOtp(uri: String, issuer: String?, accountName: String?, completion: PairingCompletion) {
        guard !uri.isEmpty else {
            completion(nil, VIDMobileSDKError(.pairingFailed(.invalidPairingQR)))
            return
        }

        let pairingData = VeridiumBOPSPairingData().parse([
            "websecUrl": VIDPairingService.kOtpPairingUrl,
            "definition": NSDictionary(dictionary: [
                "externalId": VIDPairingService.kOtpIntegrationExternalId,
                "availableBiometricMethods":["4F","TOUCHID"]
                ])
            ]);

        
        if VIDPairingService.bopsPairings.count != 0,
            VIDPairingService.bopsPairings.first?.value.url != pairingData.url {
            print("Mixed mode with OTP and VeridiumID integrations is not allowed.")
            completion(nil, VIDMobileSDKError(.pairingFailed(.invalidMixModeOTP)))
            return
        }

        let pairedEnvironmentDependencies = PairedEnvironmentDependencies(bopsPairingData: pairingData)
        // refresh local authenticators
        _ = pairedEnvironmentDependencies.veridiumSDK.laStatus

        let alreadyHaveAccount = pairedEnvironmentDependencies.localAccountService?.activeAccount != nil
        pairedEnvironmentDependencies.setupLocalAccountService()
        if (!alreadyHaveAccount) {
            // cleanup the accout data that may be from previous enrollments in the keychain
            print("Clean-up: delete old data related to current pairing.  \(Thread.callStackSymbols)")
            pairedEnvironmentDependencies.localAccountService?.unregisterAllAccounts()
        }
        
        var pairings = VIDPairingService.bopsPairings
        pairings[VIDPairingService.kOtpPairingUrl] = pairingData
        VIDPairingService.bopsPairings = pairings
        integrationForOngoingBopsRegistration = pairingData.integration

        //TODO: should we enable this?
//        let health = VIDInitializerService.shared().checkEnvHealth()
//        if health != nil {
//            completion?(VIDError(error: NSError(domain: "com.authenticator", code: 1052, userInfo: [NSLocalizedDescriptionKey: health!])))
//            return
//        }
        
        addPairedEnvironmentDependencies(pairedEnvironmentDependencies)
        completion(VIDEnvironment(uid:VIDPairingService.kOtpPairingUrl, name:pairingData.serverName, enrolmentToken:uri), nil)
    }
    
    func pair(b64Token: String, completion: @escaping PairingCompletion) {
        do {
            try validatePairingToken(b64Token)
        } catch let error as VIDMobileSDKError {
            completion(nil, error)
            return
        } catch {
            // cannot reach here
        }
        
        vidMobileSDK.didStartLongProcess(status: SDKStatus.PAIRING, processDescription: SDKStatusDescription[SDKStatus.PAIRING]!) {
            
            self.veridiumSDK.getBOPSPairingInfo(withToken: b64Token, withCompletion: { (pairingData, error) in
                
                self.vidMobileSDK.didFinishLongProcess(status: SDKStatus.PAIRING) {
                    
                    if let error = error {
                        let errorText = error.toNSError.userInfo.count > 0 ? error.toNSError.userInfo.description : "Get BOPS Pairning Info error \(error.toNSError.code) \(error.localizedDescription)";
                        print("🚫🚫🚫🚫 Get BOPS Pairing Info 🚫🚫🚫🚫 \n \(errorText)")
                        completion(nil, VIDMobileSDKError(.pairingFailed(.pairingRequestFailed(error))))
                        return
                    }
                    
                    guard let pairingData = pairingData else {
                        print("Missing pairing data")
                        completion(nil, VIDMobileSDKError(.pairingFailed(.missingPairingInfo)))
                        return
                    }
                    
                    guard (pairingData.defaultCertificate as NSString).base64ToData != nil else {
                        print("Invalid client cert data")
                        completion(nil, VIDMobileSDKError(.pairingFailed(.missingPairingInfo)))
                        return
                    }
                    
//                    guard !pairingData.pinnedServerPublicKeyHashes.isEmpty else {
//                        print("Invalid public key data")
//                        completion(nil, VIDError(errorCode: 1015))
//                        return
//                    }
                    
                    if let bopsPairingOnSameEnvironment = VIDPairingService.bopsPairings[pairingData.url],
                        bopsPairingOnSameEnvironment.integration.authenticatorType != pairingData.integration.authenticatorType {
                        print("Profile has different auth type")
                        completion(nil, VIDMobileSDKError(.pairingFailed(.conflictingAuthenticatorType)))
                        return
                    }
                    
                    // check for product version
                    var thresholdValueString: String = "1.9"
                    let currentValueString: String = pairingData.productVersion
                    if currentValueString.length > thresholdValueString.length {
                        // sanity check: don't compare v2.0 vs v2.0.0
                        thresholdValueString.append(".0")
                    }
                    let isServerVersionOlderThan2_0 = currentValueString.compare(thresholdValueString, options: .numeric, range: nil, locale: nil) == .orderedAscending
                    
                    if  isServerVersionOlderThan2_0 {
                        // check if locally all required biometries are supported
                        if let pairingDataBiometricMethods = pairingData.integration.biometricMethods {
                            for method in pairingDataBiometricMethods {
                                if !self.veridiumSDK.registeredAuthenticationBiometricMethods.contains(method) {
                                    completion(nil, VIDMobileSDKError(.pairingFailed(.missingMandatoryBiometry(method))))
                                    return
                                }
                            }
                        }
                    }
                    
                    let pairedEnvironmentDependencies = PairedEnvironmentDependencies(bopsPairingData: pairingData)
                    // refresh local authenticators
                    _ = pairedEnvironmentDependencies.veridiumSDK.laStatus

                    if  isServerVersionOlderThan2_0 {
                        // check if any of the available biometries are supported locally
                        // (there should be at least one biometry set on the server)
                        if pairedEnvironmentDependencies.availableBiometricMethods.isEmpty {
                            completion(nil, VIDMobileSDKError(.pairingFailed(.emptyMandatoryBiometry)))
                            return
                        }
                        
                        let integrationAvailableBiometricMethodsSet: Set<String> = Set(pairedEnvironmentDependencies.availableBiometricMethods)
                        let registeredBiometricMethodsSet: Set<String> = Set(pairedEnvironmentDependencies.veridiumSDK.registeredAuthenticationBiometricMethods)
                        
                        if integrationAvailableBiometricMethodsSet.intersection(registeredBiometricMethodsSet).isEmpty {
                            completion(nil, VIDMobileSDKError(.pairingFailed(.noAvailableMethodRegistered)))
                        }
                    }
                    
                    if !self.isValid(loginDefinition: pairingData.integration.loginDefinition) {
                        completion(nil, VIDMobileSDKError(.pairingFailed(.invalidLoginDefinition)))
                        return
                    }
                    
                    do {
                        try self.checkSecureEnclaveSupport(systemSettings: pairingData.systemSettings)
                    } catch {
                        completion(nil, VIDMobileSDKError(.pairingFailed(.missingSecureEnclaveSupport)))
                        return
                    }
                    
                    let settlePairing = {
                        
                        if let requiredMinVersion = pairingData.integration.loginDefinition?.minimumRequirements?.iOS {
                            let hasDeviceLowerOSVersionThanRequied = VeridiumUtils.getDeviceOsVersion().compare(requiredMinVersion, options: .numeric, range: nil, locale: nil) == .orderedAscending
                            if requiredMinVersion == "0" || hasDeviceLowerOSVersionThanRequied {
                                print("Device operting system version does not meet the requirements set by your administrator.")
                                let customErrorMessage = self.getCustomIntegrationErrorMessage(pairingData: pairingData)
                                completion(nil, VIDMobileSDKError(.pairingFailed(.lowerOSVersion(requiredMinVersion, customErrorMessage))))
                                return
                            }
                        }
                        
                        let alreadyHaveAccount = pairedEnvironmentDependencies.bopsAccountService?.activeAccount != nil
                        pairedEnvironmentDependencies.setupBopsAccountService()
                        pairedEnvironmentDependencies.veridiumSDK.registerPushHandler(pairedEnvironmentDependencies.pushManager,
                                                                                      forDomainRoot: pairedEnvironmentDependencies.bopsPairingData.url)
                        pairedEnvironmentDependencies.pushManager.setRemoteNotificationsToken(pushTokenData: self.pushRegistrationToken)
                        if !alreadyHaveAccount {
                            // cleanup the accout data that may be from previous enrollments in the keychain
                            print("Clean-up: delete old data related to current pairing.  \(Thread.callStackSymbols)")
                            pairedEnvironmentDependencies.bopsAccountService?.activeAccount?.clearAllData()
                            pairedEnvironmentDependencies.bopsAccountService?.unregisterAllAccounts()
                            
                            if self.getAllPairedEnvironmentDependencies().count == 0 {
                                VeridiumKeychainKeyValueStore.global.clearAllData()
                                VeridiumUserDefaultsKeyValueStore.global.clearAllData()
                            }
                        }
                        
                        var pairings = VIDPairingService.bopsPairings
                        pairings[pairingData.url] = pairingData
                        VIDPairingService.bopsPairings = pairings
                        
                        integrationForOngoingBopsRegistration = pairingData.integration
                        
                        HelpService.putDisclaimer(pairing: pairingData)
                        
                        if (pairedEnvironmentDependencies.locationServiceForServerReporting.isLocationEnabled()) {
                            _ = LocationService.shared()    // request permission
                        }
                        
                        self.addPairedEnvironmentDependencies(pairedEnvironmentDependencies)
                        
                        // Check the enviornment health after adding paired environment dependencies
                        do {
                            try VIDInitializerService.shared().checkEnvHealth()
                            completion(VIDEnvironment(uid:pairingData.url, name:pairingData.serverName), nil)
                        } catch let error as VIDMobileSDKError {
                            completion(nil, error)
                        } catch {}
                    }
                    
                    if let disclaimerText = pairingData.integration.loginDefinition?.disclaimer, !disclaimerText.isEmpty {
                        VeridiumUIAlertController.initiate(withTitle: L10n.veridiumSdkDisclaimer, message: disclaimerText, okButton: (L10n.veridiumSdkAgree, {
                            settlePairing()
                        }), cancelButton: (L10n.veridiumSdkDecline, {
                            // nothing to do
                        })).presentInTopmost()
                    }
                    else {
                        settlePairing()
                    }
                }
            })
        }
    }
    
    func pairUpdateServerSettings(b64Token: String, completion: ((_ error: VIDMobileSDKError?) -> ())?) {
        do {
            try validatePairingToken(b64Token)
        } catch let error as VIDMobileSDKError {
            completion?(error)
            return
        } catch {
            // cannot reach here
        }
        
        veridiumSDK.getBOPSPairingInfo(withToken: b64Token, withCompletion: { (pairingData, error) in
            
            if let error = error {
                let errorText = error.toNSError.userInfo.count > 0 ? error.toNSError.userInfo.description : "Get BOPS Pairning Info error \(error.toNSError.code) \(error.localizedDescription)";
                print("🚫🚫🚫🚫 Get BOPS Pairing Info 🚫🚫🚫🚫 \n \(errorText)")
                completion?(VIDMobileSDKError(.pairingFailed(.pairingRequestFailed(error))))
                return
            }
            
            guard let pairingData = pairingData else {
                print("Missing pairing data")
                completion?(VIDMobileSDKError(.pairingFailed(.missingPairingInfo)))
                return
            }
            
            guard (pairingData.defaultCertificate as NSString).base64ToData != nil else {
                print("Invalid client cert data")
                completion?(VIDMobileSDKError(.pairingFailed(.missingPairingInfo)))
                return
            }
            
            guard !pairingData.pinnedServerPublicKeyHashes.isEmpty else {
                print("Invalid public key data")
                completion?(VIDMobileSDKError(.pairingFailed(.missingPairingInfo)))
                return
            }
            
            var pairings = VIDPairingService.bopsPairings
            pairings[pairingData.url] = pairingData
            VIDPairingService.bopsPairings = pairings
            
            completion?(nil)
            
        })
    }
    
    private func validatePairingToken(_ b64Token: String) throws {
           guard !b64Token.isEmpty else {
               throw VIDMobileSDKError(.pairingFailed(.invalidPairingToken))
           }
           
           guard let decodedTokenData = Data(base64Encoded: b64Token, options: .ignoreUnknownCharacters) else {
               throw VIDMobileSDKError(.pairingFailed(.invalidPairingToken))
           }
           
           let pairingTokenJsonString = String(decoding: decodedTokenData, as: UTF8.self)
           guard let pairingTokenJsonDictionary = (pairingTokenJsonString as NSString).jsonDictionary else {
               throw VIDMobileSDKError(.pairingFailed(.invalidPairingToken))
           }
           
           if let memberDefinitionExtId = pairingTokenJsonDictionary["memberDefinitionExtId"] as? String,
               memberDefinitionExtId == "veridiumadmin" {
               throw VIDMobileSDKError(.pairingFailed(.invalidPairingToken))
           }
           
           guard (pairingTokenJsonDictionary["dmzURL"] as? String) != nil else {
               throw VIDMobileSDKError(.pairingFailed(.invalidPairingToken))
           }
       }
    
    func isValid(loginDefinition:VeridiumBOPSLoginDefinitionData?) -> Bool {
        if nil == loginDefinition || nil == loginDefinition?.registrationModes {
            return false
        }
        for item in loginDefinition!.registrationModes {
            if item.outputStatuses.count == 0 {
                return false
            }
        }
        return true
    }
    
    
    private func getCustomIntegrationErrorMessage(pairingData: VeridiumBOPSPairingData) -> String? {
        // custom error is on Registration Modes inside the Login Definition.
        // Ugly, but this is what they wanted.
        if ((pairingData.integration.loginDefinition?.registrationModes.count ?? -1) > 0) {
            if let customErrString = pairingData.integration.loginDefinition?.registrationModes[0].enforcedErrorMessage, !customErrString.isEmpty {
                return customErrString
            }
        }
        
        return nil
    }
    
    #if targetEnvironment(simulator)
    func checkSecureEnclaveSupport(systemSettings: [AnyHashable : Any]?) throws {
        return
    }
    #else
    func checkSecureEnclaveSupport(systemSettings: [AnyHashable : Any]?) throws {
        guard let systemSettings = systemSettings else {
            return
        }
        
        if let isHardwareEncryptionRequired = systemSettings["is-hardware-encryption-required"] as? String,
            isHardwareEncryptionRequired == "true" {
            try VeridiumSecureEnclaveWrapper.checkSecureEnclaveSupport()
        }
    }
    #endif
    
    //MARK: -
    
    //MARK: - pairings
    public static var bopsPairings:[String:VeridiumBOPSPairingData] {
        get{
            if let pairingStr = keyValueStoreProvider()[kStorePairingsKey] as NSString? {
                if let jsonDict = pairingStr.jsonDictionary as? [String:NSDictionary] {
                    var pairings = [String:VeridiumBOPSPairingData]()
                    for (key, dict) in jsonDict {
                        pairings[key] = VeridiumBOPSPairingData().parse(dict as! [AnyHashable:Any])
                    }
                    return pairings
                }
            }
            return [:]
        }
        set {
            let pairingsDict = NSMutableDictionary()
            for (key, pairing) in newValue {
                pairingsDict[key] = pairing.serialize
            }
            keyValueStoreProvider()[kStorePairingsKey] = pairingsDict.jsonString
        }
    }
 
    //MARK: -
    
    //MARK: VeridiumQrView delegate methods
    public func onQrViewWillAppear(viewController: VeridiumQrReaderViewController) {}
    
    public func onPairingQR(token: String) {
        self.pair(b64Token: token, completion: self.completionHandler)
    }

    public func onOtpQR(uri: String, issuer: String?, accountName: String?) {
        self.pairOtp(uri: uri, issuer: issuer, accountName: accountName, completion: self.completionHandler)
    }

    public func onAuthenticationQR(sessionId: String, integrationId: String) {
        completionHandler(nil, VIDMobileSDKError(.pairingFailed(.scanWithAuthenticationQR)))
    }
    
    public func onOfflineAuthenticationQR(profileExternalId: String, ownerDeviceId: String, salt: String) {
        completionHandler(nil, VIDMobileSDKError(.pairingFailed(.scanWithAuthenticationQR)))
    }
    
    public func onInvalidQr() {
        completionHandler(nil, VIDMobileSDKError(.pairingFailed(.invalidPairingQR)))
    }
    
    
    public func onScanCancelled() {
        
    }
    //MARK: -
    
    //MARK: helper functions
    public func isADIntegration(integrationExtID: String) -> Bool {
        return integrationExtID.compare(VIDPairingService.kADMSEIntegrationExternalId, options: .caseInsensitive) == ComparisonResult.orderedSame ||
            integrationExtID.starts(with: VIDPairingService.kADIntegrationExternalId)
    }
    
    public func isOTPIntegration(integrationExtID: String) -> Bool {
        return integrationExtID.compare(VIDPairingService.kOtpIntegrationExternalId, options: .caseInsensitive) == ComparisonResult.orderedSame
    }

}
