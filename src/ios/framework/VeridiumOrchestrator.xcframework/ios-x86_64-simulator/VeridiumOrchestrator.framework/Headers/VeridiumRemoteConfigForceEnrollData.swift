//
//  VeridiumRemoteConfigForceEnrollData.swift
//  VeridiumAuthenticator
//
//  Created by Paul Paul on 3/6/18.
//  Copyright © 2018 VeridiumIP. All rights reserved.
//

import UIKit

public class VeridiumRemoteConfigForceEnrollData: NSObject {
  
  public var lastUpdatedAppVersion:String = ""
  public var isForceEnrolled:Bool = false
  
  static func newFomJson(json:String) -> VeridiumRemoteConfigForceEnrollData {
    let config:VeridiumRemoteConfigForceEnrollData = VeridiumRemoteConfigForceEnrollData()
    if let lastUpdate = json.toNSString.jsonDictionary!["lastUpdatedAppVersion"] {
      config.lastUpdatedAppVersion = lastUpdate as! String
    }
    if let forceEnroll = json.toNSString.jsonDictionary!["isForceEnrolled"] {
      config.isForceEnrolled = (forceEnroll as! String).boolValue()
    }
    return config
  }
  
  var asJson:String {
    get {
      return ["lastUpdatedAppVersion" : self.lastUpdatedAppVersion, "isForceEnrolled": self.isForceEnrolled.stringValue()].toNSDictoinary.jsonString!
    }
  }
  
  
}
