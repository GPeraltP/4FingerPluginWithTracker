//
//  VeridiumPushManager.swift
//  VeridiumAuthenticator
//
//  Created by Catalin Stoica on 02/02/2018.
//  Copyright © 2018 VeridiumIP. All rights reserved.
//

import UIKit
import VeridiumCore
import VeridiumBOPS
import UserNotifications

public class VeridiumPushManager: NSObject, VeridiumPushHandlerProtocol, UIApplicationDelegate {

    internal let environment: VIDEnvironment
    internal weak var accountService: VeridiumAccountService?
    internal weak var bopsAccountService: VeridiumBOPSAccountService?
    internal weak var revocationService: VIDRevocationService?
    internal weak var veridiumSDK: VeridiumSDK?
    
    internal var authDoneBlock:voidBlock? = nil
    
    private var _isAuthInProgress = false
    internal var isAuthInProgress: Bool {
        get {
            return pushManagerQueue.sync { _isAuthInProgress }
        }
        set {
            pushManagerQueue.sync { _isAuthInProgress = newValue }
        }
    }
    
    private var _pushTSforOngoingAuthentication: String = ""
    internal var pushTSforOngoingAuthentication: String {
        get {
            return pushManagerQueue.sync { _pushTSforOngoingAuthentication }
        }
        set {
            pushManagerQueue.sync { _pushTSforOngoingAuthentication = newValue }
        }
    }
    
    private var pendingPushes: [String:voidBlock] = [:]
    private let pushManagerQueue: DispatchQueue
    
    init(environment: VIDEnvironment,
         veridiumSDK: VeridiumSDK?,
         accountService: VeridiumAccountService?,
         revocationService: VIDRevocationService?,
         pushManagerQueue: DispatchQueue = .init(label: "com.veridiumid.VeridiumPushManager")) {
        self.environment = environment
        self.veridiumSDK = veridiumSDK
        self.accountService = accountService
        self.bopsAccountService = accountService as? VeridiumBOPSAccountService
        self.revocationService = revocationService
        self.pushManagerQueue = pushManagerQueue
    }
    
    func updatePushMechanisms() {
        if let activeAccount = accountService?.activeAccount, !activeAccount.isLocked {
            activeAccount.refreshNotifications { (error) in
                if self.hasPendingPushes() {
                    VIDMobileSDK.shared().pushDelegate?.pushesPending()
                }
            }
        }
        
        veridiumSDK?.canRegister(forPushes: { (canRegisterForPushes, canRequestAuthorization) in
            if canRegisterForPushes == true {
                self.bopsAccountService?.stopPolling()
                self.veridiumSDK?.enablePushNotifications(true)
            }
            else {
                self.veridiumSDK?.enablePushNotifications(false)
                DispatchQueue.main.async {
                    self.bopsAccountService?.startPolling(withInterval: 10.0, fireEvenWhenAPNSAvailable: false)
                }
            }
        })
    }
    
    public func setRemoteNotificationsToken(pushTokenData: Data?) {
        if pushTokenData != nil {
            bopsAccountService?.stopPolling()
            veridiumSDK?.registerPushToken(pushTokenData)
        } else {
            veridiumSDK?.registerPushToken(nil)
            bopsAccountService?.stopPolling()
            bopsAccountService?.startPolling(withInterval: 10.0, fireEvenWhenAPNSAvailable: false)
        }
    }
  
    public func handlePush(_ pushData: [String : Any]!, isAPNS: Bool) {
        if let push = self.parsePush(pushData: pushData, isAPNS: isAPNS) {
            push.treat(pushManager: self)
        }
        //    consumeDeliveredPushes(isAPNS: isAPNS)
    }
  
    func parsePush(pushData: [String: Any], isAPNS: Bool) -> VAPushNotification? {
        if let pushAction: String = pushData["actionName"] as? String {
            switch pushAction {
            case "auth":
                return VAPNAuthentication(pushData, isAPNS: isAPNS)
            case "revoke_access":
                return VAPNRevokeAccess(pushData)
            case "revalidate_device":
                return VAPNRevalidateDevice(pushData)
            case "refresh_secrets":
                return VAPNRefreshSecrets(pushData)
            case "refresh_profiles":
                return VAPNRefreshProfiles(pushData)
            default:
                return nil
            }
        } else {
            return nil
        }
    }

//  func consumeDeliveredPushes(isAPNS: Bool) {
//    if #available(iOS 10.0, *) {
//      UNUserNotificationCenter.current().getDeliveredNotifications { (pushNotifications) in
//        var treatedDeliveredPushes:[String] = [String]()
//        var didTreatLastAuthPush = false
//        for push in pushNotifications {
//          if let pushData = push.request.content.userInfo as? [String: Any] {
//            if let vaPush = self.parsePush(pushData: pushData, isAPNS: true) { //check
//              treatedDeliveredPushes.append(push.request.identifier)
//              if vaPush.type == .Auth {
//                if !didTreatLastAuthPush {
//                  vaPush.treat()
//                }
//                didTreatLastAuthPush = true
//                continue
//              }
//              vaPush.treat()
//            }
//          }
//        }
//        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: treatedDeliveredPushes)
//      }
//    } else {
//      UIApplication.shared.applicationIconBadgeNumber = 1
//      UIApplication.shared.applicationIconBadgeNumber = 0
//      UIApplication.shared.cancelAllLocalNotifications()
//    }
//  }

    public func consumePendigPushes() {
        DispatchQueue.main.async {
            if VeridiumUtils.topmostViewController().isKind(of: ProcessingViewController.classForCoder()) {
                print("Push handling obstructed by Processing controller")
                return
            }
            if (self.isAuthInProgress) {
                print("Already treating another push. Postponing current push treat.")
                return
            }
            if self.hasPendingPushes() {
                self.getLastPendingPushHandler()?()
                self.authDoneBlock = {
                    DispatchQueue.main.async {
                        if self.hasPendingPushes() {
                            self.isAuthInProgress = false
                            self.removePendingPushHandlerFor(key: self.pushTSforOngoingAuthentication)
                            self.consumePendigPushes()
                        }
                    }
                }
            }
        }
    }
  
}

extension VeridiumPushManager {
    
    internal func addPendingPushHandlerFor(key: String, handler: @escaping voidBlock) {
        pushManagerQueue.async {
            self.pendingPushes[key] = handler
        }
    }
    
    internal func removePendingPushHandlerFor(key: String) {
        pushManagerQueue.async {
            self.pendingPushes.removeValue(forKey: key)
        }
    }
    
    private func hasPendingPushes() -> Bool {
        pushManagerQueue.sync {
            return self.pendingPushes.count > 0
        }
    }
    
    private func getLastPendingPushHandler() -> voidBlock? {
        pushManagerQueue.sync {
            if let lastPushHandlerKey = self.pendingPushes.keys.sorted().last {
                return self.pendingPushes[lastPushHandlerKey]
            } else {
                return nil
            }
        }
    }
}
