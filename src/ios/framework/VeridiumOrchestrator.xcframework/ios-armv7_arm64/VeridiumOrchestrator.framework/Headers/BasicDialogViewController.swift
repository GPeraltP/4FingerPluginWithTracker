import UIKit
import VeridiumBOPS

/*
 **USAGE**
 
 let action = { print("haha") ; self.dismiss(animated: true, completion: nil) }
 let button = NSAttributedString(string: "Cancel")
 let button2 = NSAttributedString(string: "OK")
 let button3 = NSAttributedString(string: "click me")
 self.present(BasicDialogViewController.getDialog(headerImage: UIImage(named: "fail_big_X")!, titleText: "Some Title", descriptionText: "Some Description", buttons: [button:action, button2:action, button3:action]), animated: true, completion: nil)
 */

public class BasicDialogViewController: UIViewController {
  
  @IBOutlet weak var dialogView: UIView!
  @IBOutlet weak var dialogHeaderImageView: UIImageView!
  @IBOutlet weak var dialogTitleLabel: UILabel!
  @IBOutlet weak var buttonsStackView: UIStackView!
  @IBOutlet weak var dialogDescriptionTextView: UITextView!
    
  var headerImage: UIImage = UIImage()
  public var titleText: String = ""
  var descriptionText: String = ""
  var buttons: [NSAttributedString: voidBlock] = [:]
  
  static var errorImage:UIImage! = UIImage(named: "fail_big_X", in: Bundle(for: GetBundle.self), compatibleWith: nil)
  
  static func getDialog(headerImage: UIImage, titleText: String,
                        descriptionText: String, buttons: [NSAttributedString: voidBlock]) -> BasicDialogViewController {
    let modals = UIStoryboard(name: "ModalViewControllers", bundle: Bundle(identifier: "com.veridiumid.VeridiumOrchestrator"))
    let vc = modals.instantiateViewController(withIdentifier: "dialog") as! BasicDialogViewController
    vc.headerImage = headerImage
    vc.titleText = titleText
    vc.descriptionText = descriptionText
    vc.buttons = buttons
    return vc
  }
 	
    static func getDialog(headerImage: UIImage, titleText: String,
                          descriptionText: String) -> BasicDialogViewController {
        let modals = UIStoryboard(name: "ModalViewControllers", bundle: Bundle(identifier: "com.veridiumid.VeridiumOrchestrator"))
        let vc = modals.instantiateViewController(withIdentifier: "dialog") as! BasicDialogViewController
        vc.headerImage = headerImage
        vc.titleText = titleText
        vc.descriptionText = descriptionText
        //vc.buttons = buttons
        return vc
    }

  override public func viewDidLoad() {
    super.viewDidLoad()
    initUI()
  }
  
  static func getOKbutton() -> NSMutableAttributedString {
    let okString = "OK"
    let okRange = (okString as NSString).range(of: okString)
    let okButton = NSMutableAttributedString(string: okString)
    okButton.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: okRange)
    return okButton
  }
    
    static func getbutton(_ text: String) -> NSMutableAttributedString {
        let okString = text
        let okRange = (okString as NSString).range(of: okString)
        let okButton = NSMutableAttributedString(string: okString)
        okButton.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: okRange)
        return okButton
    }
  
  public static func qrErrorAlert(titleText: String, descriptionText: String, onOk: @escaping voidBlock) -> BasicDialogViewController {
    return BasicDialogViewController.getDialog(headerImage: errorImage, titleText: titleText, descriptionText: descriptionText, buttons: [BasicDialogViewController.getOKbutton() : onOk])
  }
  
  public static func getInvalidQRAlert(onOk: voidBlock?) -> BasicDialogViewController {
    return BasicDialogViewController.getByErrorCode(errorCode: 1030, onOk: (nil != onOk ? onOk : nil)!)
  }
  
  static func getPrematureAuthenticationQRAlert(onOk: voidBlock?) -> BasicDialogViewController {
    return BasicDialogViewController.getByErrorCode(errorCode: 1005, onOk: (nil != onOk ? onOk : nil)!)
  }
  
  public static func getCustomErrorAlert(titleText: String, descriptionText: String, onOk: @escaping voidBlock) -> BasicDialogViewController {
    return BasicDialogViewController.getDialog(headerImage: errorImage, titleText: titleText, descriptionText: descriptionText, buttons: [BasicDialogViewController.getOKbutton() : onOk])
  }
 
    static func selfClosingAlert(titleText: String, descriptionText: String) -> BasicDialogViewController {
        let dialog = BasicDialogViewController.getDialog(headerImage: errorImage, titleText: titleText, descriptionText: descriptionText)
        dialog.buttons = [BasicDialogViewController.getOKbutton() : { dialog.dismiss(animated: true )} ]
        return dialog
    }

  public static func getByErrorCode(errorCode: Int, onOk: @escaping voidBlock) -> BasicDialogViewController {
      return BasicDialogViewController.getDialog(headerImage: errorImage,
                                                 titleText: errorTitle(error: VIDError(errorCode: errorCode)),
                                                 descriptionText: errorMessage(error: VIDError(errorCode: errorCode)),
                                                 buttons: [BasicDialogViewController.getOKbutton() : onOk])
  }
  
  static public func getBOPSErrorCode(errorCode: Int, onOk: @escaping voidBlock) -> BasicDialogViewController {
    return BasicDialogViewController.getDialog(headerImage: errorImage,
                                               titleText: errorTitle(error: VIDError(errorCode: errorCode)),
                                               descriptionText: errorMessage(error: VIDError(errorCode: errorCode)),
                                               buttons: [BasicDialogViewController.getOKbutton() : onOk])
  }
    
    static public func getByError(error: Error, continueButtonText: String = "Ok", onOk: @escaping voidBlock) -> BasicDialogViewController {
        return BasicDialogViewController.getDialog(headerImage: errorImage,
                                                   titleText: errorTitle(error: error),
                                                   descriptionText: errorMessage(error: error),
                                                   buttons: [BasicDialogViewController.getbutton(continueButtonText) : onOk])
    }
  
  static func showTXWithMessage(message:String, onOk:@escaping voidBlock, onDontAllow:@escaping voidBlock) -> BasicDialogViewController {
    let txImage = UIImage(named: "tx_icon", in: Bundle(for: GetBundle.self), compatibleWith: nil)
    var attributes = [NSAttributedString.Key: AnyObject]()
    attributes[NSAttributedString.Key.foregroundColor] = UIColor(red: 10.0/255.0, green: 91.0/255.0, blue: 254.0/255.0, alpha: 1.0)
    attributes[NSAttributedString.Key.font] = UIFont(name: "Open Sans", size: 12)!
    let alert =  BasicDialogViewController.getDialog(headerImage: txImage!,
                                               titleText: "",
                                               descriptionText: message,
                                               buttons: [NSAttributedString.init(string: "Don't Allow", attributes: attributes): onDontAllow, BasicDialogViewController.getOKbutton() : onOk])
    return alert;
  }
  
  func initUI() {
    dialogView.layer.cornerRadius = 20.0
    dialogView.clipsToBounds = true
    dialogView.layer.borderColor = UIColor.black.cgColor
    dialogView.layer.borderWidth = 0.1
    
    dialogHeaderImageView.image = headerImage
    dialogTitleLabel.text = titleText
    dialogDescriptionTextView.text = descriptionText
    
    for button in buttons {
      let newButton = UIButton()
      newButton.setAttributedTitle(button.key, for: .normal)
      newButton.add(for: .touchUpInside, button.value)
      buttonsStackView.addArrangedSubview(newButton)
    }
  }
}
