//
//  VeridiumDynamicFormsGenerator.swift
//  VeridiumAuthenticator
//
//  Created by Paul Paul on 2/21/18.
//  Copyright © 2018 VeridiumIP. All rights reserved.
//

import UIKit
import VeridiumBOPS

protocol VeridiumDynamicFormsGeneratorDelegate {
  func handleFormDataSubmited()
}

struct GeneratorMeta {
  init(textFiled:UITextField, subLine:UIView) {
    self.textField = textFiled
    self.line      = subLine
  }
  var textField:UITextField
  var line:UIView
}

class VeridiumDynamicFormsGenerator: NSObject, UITextFieldDelegate {
  
  private let maxRowHeight:CGFloat = 50.0
  private let kVeridiumLineHeight:CGFloat = 1.5
  private var holderView:UIView = UIView()
  private var viewsToRenderMetas:[VeridiumBOPSParamDefinitionData] = [VeridiumBOPSParamDefinitionData]()
  private var renderedMetas:[GeneratorMeta] = [GeneratorMeta]()
  private let kVeridiumEnabledLineColor  = UIColor(red: 56.0/255.0, green: 192.0/255.0, blue: 204.0/255.0, alpha: 1.0)
  private let kVeridiumDisabledLineColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0)
  private let kVeridiumInvalidLineColor = UIColor(red: 224.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)

  var lastRenderedFrame:CGRect = CGRect.zero
  
  var delegate:VeridiumDynamicFormsGeneratorDelegate? = nil
  
  init(view:UIView, registrationMode:VeridiumBOPSRegistrationModeDefinitionData, delegate:VeridiumDynamicFormsGeneratorDelegate) {
    super.init()
    self.resetForm()
    self.delegate = delegate
    self.holderView = view
    self.viewsToRenderMetas = registrationMode.parameters
    self.addViews()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.superview?.addGestureRecognizer(tapGesture)
  }
  
  @objc func dismissKeyboard(sender:UITapGestureRecognizer?) {
    self.holderView.superview?.endEditing(true)
  }
  
  func addViews() {
    guard self.viewsToRenderMetas.count > 0 else {
        return
    }
    
    let totalHeight:CGFloat = self.holderView.frame.size.height
    var frames:[CGRect] = [CGRect]()
    let firstFrame:CGRect = CGRect(x: self.holderView.frame.origin.x, y: self.holderView.frame.origin.y, width: self.holderView.frame.size.width,
                                   height: Int(totalHeight)/self.viewsToRenderMetas.count > Int(maxRowHeight) ? maxRowHeight : totalHeight/CGFloat(self.viewsToRenderMetas.count))
    frames.append(firstFrame)
    
    for i in 0 ... self.viewsToRenderMetas.count - 1 {
      UIView.animate(withDuration: 0.3, animations: {
        self.renderViewForFrame(frame: frames[i],
                                controlType: self.mapBopsFieldValueKeyboardType(type: self.viewsToRenderMetas[i].name == "email" ? self.viewsToRenderMetas[i].name : self.viewsToRenderMetas[i].controlType),
                                tag: i,
                                placeHolder: self.viewsToRenderMetas[i].title,
                                isPassword: self.viewsToRenderMetas[i].controlType == "password",
                                defaultValue: self.viewsToRenderMetas[i].value)

      })
        let nextFrame = CGRect(x: frames[i].minX, y: frames[i].maxY + 5, width: frames[i].width, height: frames[i].height)
        frames.append(nextFrame)
        if i == self.viewsToRenderMetas.count - 1 {
          self.lastRenderedFrame = frames[i]
          self.renderedMetas[0].textField.becomeFirstResponder()
        }
    }
  }
  
  func mapBopsFieldValueKeyboardType(type:String) -> UIKeyboardType {
    if type == "string" || type == "password" {
      return UIKeyboardType.asciiCapable
    }
    if type == "email" {
      return UIKeyboardType.emailAddress
    }
    
    if type == "number" {
      return UIKeyboardType.numberPad
    }
    
    return UIKeyboardType.asciiCapable
  }
  
  func renderViewForFrame(frame:CGRect, controlType:UIKeyboardType, tag:Int, placeHolder:String, isPassword:Bool, defaultValue:String?) {
    let holderView:UIView = UIView(frame: frame)
    holderView.backgroundColor = UIColor.clear
    holderView.tag = tag
    let textField:UITextField = UITextField(frame: CGRect(x: holderView.frame.origin.x, y: holderView.frame.origin.y, width: holderView.frame.size.width, height: holderView.frame.size.height - kVeridiumLineHeight))
    textField.keyboardType = controlType
    textField.autocapitalizationType = .none
    textField.autocorrectionType = .no
    textField.spellCheckingType = .no
    textField.keyboardAppearance = .default
    textField.placeholder = placeHolder
    textField.returnKeyType = tag == self.viewsToRenderMetas.count - 1 ? .go : .next
    textField.tag = tag
    textField.isUserInteractionEnabled = true
    textField.delegate = self
    textField.isSecureTextEntry = isPassword
    textField.enablesReturnKeyAutomatically = true
    textField.text = defaultValue
    textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    holderView.addSubview(textField)
    self.holderView.superview?.addSubview(textField)
    let bottomView:UIView = UIView(frame: CGRect(x: textField.frame.minX, y: textField.frame.maxY - kVeridiumLineHeight, width: holderView.frame.size.width, height: holderView.frame.size.height - textField.frame.size.height))
    bottomView.backgroundColor = defaultValue == nil ? kVeridiumDisabledLineColor : kVeridiumEnabledLineColor
    self.holderView.superview?.addSubview(bottomView)
    self.renderedMetas.append(GeneratorMeta.init(textFiled: textField, subLine: bottomView))
  }
  
    @objc func textFieldDidChange(textField:UITextField) {
    if let textFieldText = textField.text {
      if textFieldText.count > 0 {
        UIView.animate(withDuration: 0.3, animations: {
          self.renderedMetas[textField.tag].line.backgroundColor = self.kVeridiumEnabledLineColor
        })
      } else if textFieldText.count == 0 {
        UIView.animate(withDuration: 0.3, animations: {
          self.renderedMetas[textField.tag].line.backgroundColor = self.kVeridiumDisabledLineColor
        })
      }
    }
  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField.tag == self.viewsToRenderMetas.count  - 1 {
      if nil != delegate {
        textField.resignFirstResponder()
        self.delegate?.handleFormDataSubmited()
      }
    } else {
      if textField.tag + 1 == self.viewsToRenderMetas.count  - 1 {
        self.renderedMetas[textField.tag + 1].textField.returnKeyType = .go
      }
      self.renderedMetas[textField.tag + 1].textField.becomeFirstResponder()
    }
    return true
  }
  
    func validateData() -> Bool {
        var isValid = true
        for i in 0 ... self.viewsToRenderMetas.count - 1 {
            if (self.viewsToRenderMetas[i].required && (self.renderedMetas[i].textField.text ?? "").isEmpty) {
                markInvalidField(field: self.renderedMetas[i])
                isValid = false
            }
            else {
                markValidField(field: self.renderedMetas[i])
            }
        }
        return isValid
    }
    
  func collectSubmitedData() -> [String:String] {
    var collected:[String:String] = [String:String]()
    for i in 0 ... self.viewsToRenderMetas.count - 1 {
        collected[self.viewsToRenderMetas[i].name] = self.renderedMetas[i].textField.text ?? ""
        if (self.viewsToRenderMetas[i].required && collected[self.viewsToRenderMetas[i].name]!.isEmpty) {
            markInvalidField(field: self.renderedMetas[i])
        }
        else {
            markValidField(field: self.renderedMetas[i])
        }
    }
    return collected
  }
  
    func markInvalidField(field: GeneratorMeta) -> Void {
        field.line.backgroundColor = kVeridiumInvalidLineColor
    }
    
    func markValidField(field: GeneratorMeta) {
        field.line.backgroundColor = field.textField.text == nil ? kVeridiumDisabledLineColor : kVeridiumEnabledLineColor
    }
    
  func resetForm() {
    for item in self.renderedMetas {
      item.line.removeFromSuperview()
      item.textField.removeFromSuperview()
    }
  }

}
