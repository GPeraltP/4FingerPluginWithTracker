//
//  VeridiumQRReaderViewController.h
//  VeridiumQRReader
//
//  Created by Paul Paul on 7/25/17.
//  Copyright © 2017 VeridiumID. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VeridiumQR.h"

@interface VeridiumQRReaderViewController : UIViewController

@property (strong, nonatomic) void(^ _Nullable onSuccess)(NSString* _Nullable result);
@property (strong, nonatomic) void(^ _Nullable onCancel)(void);
@property (strong, nonatomic) void(^ _Nullable onVCDismissed)(void);
@property NSString* _Nullable textDescription;

@property VeridiumQRType type;

@end
