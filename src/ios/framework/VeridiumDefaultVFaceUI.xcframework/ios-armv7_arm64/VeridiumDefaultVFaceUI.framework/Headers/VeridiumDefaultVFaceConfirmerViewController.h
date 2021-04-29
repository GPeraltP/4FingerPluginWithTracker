//
//  VeridiumCancelConfirmerViewController.h
//  VeridiumDefaultVFaceUI
//
//  Created by Veridium on 25/09/2019.
//  Copyright © 2019 Veridium IP Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@import VeridiumCore;

@interface VeridiumDefaultVFaceConfirmerViewController : UIViewController

+(instancetype)initiate;

@property NSString* message;
@property voidBlock onOK;
@property voidBlock onCancel;

@end
