// Usage: self.present(ProcessingViewController.getProcessingView(), animated: true, completion: nil)

import UIKit
import AVFoundation
import VeridiumCore

public class ProcessingViewController: UIViewController {
    
    @IBOutlet weak var spinnerView: SpinnerView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var processingLabel: UILabel?
    
    public var titleText: String?
    /// This parameter is used when the ProcessingViewController's title needs to be updated either when it's already visible or about to become visible
    private var stickyTitleText: String?
    
    lazy var config: VIDConfiguration = {
        VIDMobileSDK.shared().getConfiguration();
    }()
    
    private var workerBlock:voidBlock? = nil
    
    private static var _shared:ProcessingViewController? = nil
    
    static public func getCustomProcessingView(label: String) -> ProcessingViewController {
        _shared = getProcessingView()
        _shared?.titleText = label
        return _shared!
    }
    
    static public func getProcessingView() -> ProcessingViewController {
        if nil == _shared {
            let stb = UIStoryboard(name: "ModalViewControllers", bundle: Bundle(identifier: "com.veridiumid.VeridiumOrchestrator"))
            _shared = stb.instantiateViewController(withIdentifier: "processing") as? ProcessingViewController
        }
        _shared?.titleText = L10n.veridiumSdkProcessing
        return _shared!
    }
    
    static public func reset() {
        _shared?.stickyTitleText = nil
        _shared?.titleText = L10n.veridiumSdkProcessing
    }
    
    public func updateTitle(shouldUseDefaultLabel: Bool, label: String? = nil) {
        if shouldUseDefaultLabel {
            self.stickyTitleText = nil
        } else {
            self.stickyTitleText = label ?? L10n.veridiumSdkProcessing
        }
        self.processingLabel?.text = label ?? L10n.veridiumSdkProcessing
    }

    public func reset() {
        self.stickyTitleText = nil
        self.titleText = L10n.veridiumSdkProcessing
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        print("ProcessingViewController viewDidLoad")
        self.setupUI()
    }
    
    func setupUI() {
        if let customSpinnerColor = config.progressSpinnerColor {
            spinnerView.strokeColor = customSpinnerColor
        }
        containerView.layer.cornerRadius = 20.0
        containerView.clipsToBounds = true
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 0.1
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let stickyLabelText = stickyTitleText {
            processingLabel?.text = stickyLabelText
        } else if let labelText = titleText {
            processingLabel?.text = labelText
        }
        spinnerView?.startAnimation()
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        spinnerView?.stopAnimation()
        stickyTitleText = nil
    }
    
    public func show(didShow: voidBlock?) {
        self.show(title: nil, didShow: didShow)
    }
    
    public func show(title: String?, didShow: voidBlock?) {
        self.titleText = title ?? L10n.veridiumSdkProcessing
        DispatchQueue.main.async {
            self.presentInTopmost(completion: didShow)
        }
    }
    
    override public func dismiss(animated:Bool, completion: voidBlock?) {
        DispatchQueue.main.async {
            if self.viewIfLoaded?.window != nil && !self.isBeingDismissed {
                super.dismiss(animated: true, completion: completion)
            }
            else {
                if (self.isBeingDismissed) {
                    usleep(500)
                }
                completion?()
            }
        }
    }

}
