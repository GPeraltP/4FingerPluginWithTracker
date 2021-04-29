//
//  VeridiumQrReaderViewController.swift
//  VeridiumAuthenticator
//
//  Created by Catalin Stoica on 29/01/2018.
//  Copyright © 2018 VeridiumIP. All rights reserved.
//

import UIKit
import VeridiumQRReader
import AVFoundation

public class VeridiumQrReaderViewController: UIViewController, VeridiumQRUIDelegateProtocol {
    
    #if targetEnvironment(simulator)
    private let isSimulator = true
    #else
    private let isSimulator = false
    #endif
    
    //QR Basic info
    private let kNumberOfElementsInQrCode = 3
    private let kNumberOfElementsInOfflineQrCode = 6
    private let kEnterpriseQrIndex = 0
    private let kSessionIdIndex = 2;
    private let kProfileIdQrIndex = 4
    
    //QR type (online/offline) checks
    private let kQrOnlineStringCheck = "ENTERPRISE"
    private let kQrOfflineStringCheck = "ENTERPRISE_OFFLINE"
    private let kQrOtp = "otpauth://"
    
    //Online auth QR indexes
    private let kQrOnlineIndexIntegrationId = 1
    private let kQrOnlineIndexSessionId = 2
    
    //Otp parameters
    private let kQrOtpParameterIssuer = "issuer"
    
    private enum QrType {
        case pairingQrType
        case onlineAuthenticationQrType
        case offlineAuthenricationQrType
        case otpQrType
        case unknownQrType
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var preview: UIView!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    
    var canUseQRReaderModule:Bool = true
    private var qrReader: VeridiumQR!
    public var delegate: VeridiumQRViewProtocol!
    public var descriptionText: String!
    public var helpText: String?
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    self.qrReader = VeridiumQRReaderFactory.getQrReader(isSimulator)
    self.qrReader.uiDelegate = self
    self.descriptionLabel.text = descriptionText
    self.descriptionLabel.adjustsFontSizeToFitWidth = true
    self.helpLabel.text = helpText ?? ""
    self.warningLabel.layer.masksToBounds = true
    self.warningLabel.layer.cornerRadius = 8
    self.warningLabel.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
    self.warningLabel.isHidden = true
    if(!isSimulator) {
        self.determinCameraAccess()
    }
    NotificationCenter.default.addObserver(self, selector: #selector(didAppBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
  }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate.onQrViewWillAppear(viewController: self)
    }

    @objc func didAppBecomeActive() {
        delegate.onQrViewWillAppear(viewController: self)
        startQrScanning()
    }
    
    func determinCameraAccess() {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch cameraStatus {
        case .denied:
            self.canUseQRReaderModule = false
            BasicDialogViewController.qrErrorAlert(titleText: L10n.veridiumSdkErrorWithQr,
                                                   descriptionText: L10n.veridiumSdkAllowCamera,
                                                   onOk: {
                self.dismiss(animated: true, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            }).presentInTopmost()
        case .restricted:
            self.canUseQRReaderModule = false
            BasicDialogViewController.qrErrorAlert(titleText: L10n.veridiumSdkErrorWithQr,
                                                   descriptionText: L10n.veridiumSdkRemoveCameraRestriction,
                                                   onOk: {
                self.dismiss(animated: true, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            }).presentInTopmost()
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (flag) in
                if (!flag) {
                    self.determinCameraAccess()
                }
            }
        default:
            print("Can use camera for QR codes.")
        }
    }
    
    func startQrScanning() {
        if !canUseQRReaderModule {
            return
        }
        self.qrReader.startScanning { (qrResult) in
            self.qrReader.stopCamera()
            if let result = qrResult {
                self.processQR(result: result)
            }
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startQrScanning()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !canUseQRReaderModule {
            return
        }
        if !self.qrReader.isCameraSetup {
            self.qrReader.setupAndStartCamera()
        }
        self.qrReader.addSquareOverlay()
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.qrReader.stopCamera()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate.onScanCancelled()
        }
    }
    
    public func previewView() -> UIView {
        return self.preview
    }
    
    private func processQR(result: String) {
        print("QR Result: \(result)")
        
        if result.uppercased().starts(with: kQrOtp.uppercased()) {
            let parsedTokens = parseQtpUrl(string: result)
            self.dismiss(animated: true, completion: {
                self.delegate.onOtpQR(uri: result, issuer: parsedTokens.issuer, accountName: parsedTokens.accountName)
            })
            return
        }
        
        let chunks:[String] = result.components(separatedBy: "/")
        if result.contains(kQrOnlineStringCheck.uppercased()) {
            if chunks.count == kNumberOfElementsInQrCode, chunks[kEnterpriseQrIndex] == kQrOnlineStringCheck {
                self.dismiss(animated: true, completion: {
                    self.delegate.onAuthenticationQR(sessionId: chunks[self.kQrOnlineIndexSessionId], integrationId: chunks[self.kQrOnlineIndexIntegrationId])
                })
                return
            }
            
            if chunks.count == kNumberOfElementsInOfflineQrCode && chunks[kEnterpriseQrIndex] == kQrOfflineStringCheck {
                let ownerDeviceId = chunks[3] as String
                let profileExternaId = chunks[4]
                let salt = chunks[5] as String
                self.dismiss(animated: true, completion: {
                    self.delegate.onOfflineAuthenticationQR(profileExternalId: profileExternaId, ownerDeviceId: ownerDeviceId, salt: salt)
                })
                return
            }
        }
        
        if chunks.count == 1 { // YOLO in plm :)))))
            if let decoded = (result as NSString).base64ToData {
                let s = ((decoded as NSData).toString as NSString).jsonDictionary
                if (s?.keys.contains("dmzURL"))! {
                    self.dismiss(animated: true, completion: {
                        self.delegate.onPairingQR(token: result)
                    })
                    return
                }
            }
        }
        self.handleInvalidQR()
    }
    
    func handleInvalidQR() {
        self.dismiss(animated: true) {
            self.delegate.onInvalidQr()
        }
    }
    
    func parseQtpUrl(string: String) -> (issuer: String?, accountName: String?) {
        
        guard let url = URLComponents(string: string) else { return (nil, nil) }
        
        let issuer = url.queryItems?.first(where: { $0.name == kQrOtpParameterIssuer })?.value
        
        return (issuer: issuer, accountName: nil)
    }
    
}
