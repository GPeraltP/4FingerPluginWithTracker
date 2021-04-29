//
//  VeridiumQRViewProtocol.swift
//  VeridiumAuthenticator
//
//  Created by Catalin Stoica on 04/01/2018.
//  Copyright © 2018 VeridiumIP. All rights reserved.
//

import UIKit

public protocol VeridiumQRViewProtocol: BaseViewProtocol {
    
    func onScanCancelled()
    func onPairingQR(token: String)
    func onAuthenticationQR(sessionId: String, integrationId:String)
    func onOfflineAuthenticationQR(profileExternalId: String, ownerDeviceId: String, salt: String)
    func onOtpQR(uri: String, issuer: String?, accountName: String?)
    func onInvalidQr()
    func onQrViewWillAppear(viewController: VeridiumQrReaderViewController)
  
}

