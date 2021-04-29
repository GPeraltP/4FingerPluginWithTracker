import UIKit
import VeridiumCore

public class BasicAlertViewController: UIViewController {
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var alertImage: UIImageView!
    
    @IBOutlet weak var additionalInfoSection: UIView!
    
    @IBOutlet weak var ubaResult: UIView!
    @IBOutlet weak var ubaResultIcon: UIImageView!
    @IBOutlet weak var ubaResultText: UILabel!
    
    @IBOutlet weak var additionalInfoLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    static let successImage = UIImage(named: "enroll_complete_icon", in: Bundle(for: GetBundle.self), compatibleWith: nil)
    static let failedImage = UIImage(named: "enroll_error_icon", in: Bundle(for: GetBundle.self), compatibleWith: nil)
    
    var image: UIImage?
    var alertTitle = ""
    var additionalInfo: String = ""
    public var ubaInfo: VIDAuthResponse.VIDinMotionOutput?
    var dismissBlock: voidBlock?
    var attributedAdditionalInfo: NSAttributedString = NSAttributedString(string: "")
    var shouldEnableDismissOnTap = false
    
    public enum AlertType {
        case EnrollmentComplete, EnrollmentError, AuthencationSuccessful, AuthenticationFailed
    }
    
    static func getAlert(type: AlertType, additionalInfo: String? = "", canUserDismiss: Bool = false) -> BasicAlertViewController {
        switch type {
        case .EnrollmentComplete:
            return getCustomAlert(image: successImage, alertTitle: L10n.veridiumSdkEnrolmentComplete,
                                  additionalInfo: additionalInfo,
                                  isDismissableByUser: canUserDismiss)
        case .EnrollmentError:
            return getCustomAlert(image: failedImage, alertTitle: L10n.veridiumSdkEnrolmentError,
                                  additionalInfo: additionalInfo,
                                  isDismissableByUser: canUserDismiss)
        case .AuthencationSuccessful:
            return getCustomAlert(image: successImage, alertTitle: L10n.veridiumSdkAuthSuccessful,
                                  additionalInfo: additionalInfo,
                                  isDismissableByUser: canUserDismiss)
        case .AuthenticationFailed:
            return getCustomAlert(image: failedImage, alertTitle: L10n.veridiumSdkAuthFailed,
                                  additionalInfo: additionalInfo,
                                  isDismissableByUser: canUserDismiss)
        }
    }
    
    /// Creates a `BasicAlertViewController` instance according to given `VeridiumAggregatedAuthResult` parameter
    ///
    /// - Parameters:
    ///    - result: result of the authentication
    public static func authenticationAlert(_forStatus result: VeridiumAggregatedAuthResult) -> BasicAlertViewController? {
        switch result.overallResult {
        case .AUTHENTICATED:
            let vc = getAlert(type: .AuthencationSuccessful, additionalInfo: nil, canUserDismiss: false)
            if let ubaResponse = (result as? AggregatedAuthenticationResult)?.ubaResponse {
                if (VIDMobileSDK.shared().getConfiguration().displayUbaScore) {
                    vc.ubaInfo = VIDAuthResponse.VIDinMotionOutput(ubaResponse)
                    vc.shouldEnableDismissOnTap = ubaResponse.isProcessed
                }
            }
            return vc
        case .CANCELED:
            return nil
        //      return getAlert(type: .AuthenticationFailed, additionalInfo: "Cancelled")
        case .FAILED:
            return getAlert(type: .AuthenticationFailed)
        case .AUTHENTICATED_BY_ADMIN:
            print("OOPS 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫")
            return nil
        case .TIMEOUT,
             .NONE:
            return getAlert(type: .AuthenticationFailed)
        }
    }
    
    /// Creates a `BasicAlertViewController` instance according to given `VIDAuthResponse` parameter
    ///
    /// - Parameters:
    ///    - result: result of the authentication
    public static func authenticationAlert(_forStatus result: VIDAuthResponse) -> BasicAlertViewController? {
        switch result.status {
        case .AUTHENTICATED:
            let vc = getAlert(type: .AuthencationSuccessful, additionalInfo: nil, canUserDismiss: false)
            if let ubaResponse = result.ubaOutput {
                if (VIDMobileSDK.shared().getConfiguration().displayUbaScore) {
                    vc.ubaInfo = ubaResponse
                    vc.shouldEnableDismissOnTap = result.ubaOutput?.processed ?? false
                }
            }

            return vc
        case .CANCELED:
            return nil
        //      return getAlert(type: .AuthenticationFailed, additionalInfo: "Cancelled")
        case .FAILED:
            return getAlert(type: .AuthenticationFailed)
        case .AUTHENTICATED_BY_ADMIN:
            print("OOPS 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫")
            return nil
        case .TIMEOUT,
             .NONE:
            return getAlert(type: .AuthenticationFailed)
        }
    }
    
    private func updateUbaUI() {
        guard let ubaResult = self.ubaInfo else {
            return
        }
        
        if ubaResult.processed {
            self.ubaResult.isHidden = false
            if ubaResult.verified {
                self.ubaResultIcon.image = UIImage(named: "green_check", in: Bundle(for: GetBundle.self), compatibleWith: nil)
                self.ubaResultText.text = L10n.veridiumSdkUbaVerified
            }
            else {
                self.ubaResultIcon.image = UIImage(named: "orange_warning", in: Bundle(for: GetBundle.self), compatibleWith: nil)
                self.ubaResultText.text = L10n.veridiumSdkUbaRejected
            }
        }
    }
    
    /// Creates a `BasicAlertViewController` instace with given `AlertType`, additional info (optional) and dismiss option (optional)
    ///
    /// - Parameters:
    ///    - type:                `AlertType` enum to specify alert type
    ///    - additionalInfo:      Extra information to be shown at the bottom of the alert dialog
    ///    - isDismissableByUser: If set to true, alert dialog is presented with a close button, so that user can dismiss the dialog by pressing on the button.
    ///                           If set to false, alert dialog dismisses itself after a couple of seconds. It is false by default.
    public static func getAlert(type: AlertType, additionalInfo: String = "", isDismissableByUser: Bool = false) -> BasicAlertViewController? {
        return getAlert(type: type, additionalInfo: additionalInfo, canUserDismiss: isDismissableByUser)
    }
    
    /// Creates a `BasicAlertViewController` instace with given image, title, additional info (optional) and dismiss option (optional)
    ///
    /// - Parameters:
    ///    - image:               Image to be shown at the center of the alert dialog
    ///    - alertTitle:          Title to be shown on top of the alert dialog
    ///    - additionalInfo:      Extra information to be shown at the bottom of the alert dialog
    ///    - isDismissableByUser: If set to true, alert dialog is presented with a close button, so that user can dismiss the dialog by pressing on the button.
    ///                           If set to false, alert dialog dismisses itself after a couple of seconds. Set to false by default.
    public static func getCustomAlert(image: UIImage?, alertTitle: String, additionalInfo: String?, isDismissableByUser: Bool = false) -> BasicAlertViewController {
        let modals = UIStoryboard(name: "ModalViewControllers", bundle: Bundle(identifier: "com.veridiumid.VeridiumOrchestrator"))
        let vc = modals.instantiateViewController(withIdentifier: "test") as! BasicAlertViewController
        
        vc.shouldEnableDismissOnTap = isDismissableByUser
        vc.image = image
        vc.additionalInfo = additionalInfo ?? ""
        vc.alertTitle = alertTitle
        return vc
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initUI()
    }
    
    func initUI() {
        alertView.layer.cornerRadius = 20.0
        alertView.clipsToBounds = true
        alertView.layer.borderWidth = 0.1
        alertView.layer.borderColor = UIColor.black.cgColor
        
        alertImage.image = image
        alertTitleLabel.text = alertTitle
        if (!attributedAdditionalInfo.string.isEmpty) {
            additionalInfoLabel.attributedText = attributedAdditionalInfo
        } else if (!additionalInfo.isEmpty) {
            additionalInfoLabel.text = additionalInfo
        } else {
            additionalInfoLabel.isHidden = true
        }
        alertTitleLabel.adjustsFontSizeToFitWidth = true
        
        self.updateUbaUI()
        
        if additionalInfoLabel.isHidden && ubaResult.isHidden {
            additionalInfoSection.isHidden = true
        }
        else {
            self.shouldEnableDismissOnTap = true
        }
        
        closeButton.isHidden = !shouldEnableDismissOnTap
        
    }
    
    @IBAction func onCloseButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: self.dismissBlock ?? nil)
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.addShaddow(view: self.alertView)
    }
    
    override public func presentInTopmost() {
        VeridiumUtils.topmostViewController().presentVeridiumDismissingAlert(self, animated: true, dismissDeadline: .now() + alertDismissTime, afterDismiss: nil)
    }
    
    public func presentInTopmostNonDismissable() {
        VeridiumUtils.topmostViewController().presentVeridiumDismissingAlert(self, animated: true, dismissDeadline: DispatchTime.distantFuture, afterDismiss: nil)
    }
    
    public func presentInTopmostWithDismissBlock(dismissBlock: voidBlock?) {
        if(shouldEnableDismissOnTap) {
            self.dismissBlock = dismissBlock
            VeridiumUtils.topmostViewController().presentVeridiumAlert(self, animated: true)
        } else {
            VeridiumUtils.topmostViewController().presentVeridiumDismissingAlert(self, animated: true, dismissDeadline: .now() + alertDismissTime, afterDismiss: dismissBlock ?? nil)
        }
    }
}
