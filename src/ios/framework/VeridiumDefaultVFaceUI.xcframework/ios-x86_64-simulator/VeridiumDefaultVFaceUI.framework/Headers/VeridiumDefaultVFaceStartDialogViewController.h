//
//  VeridiumDefaultVFaceStartViewController.h
//  VeridiumDefaultVFaceUI
//
//  Created by Veridium on 24/09/2019.
//  Copyright © 2019 Veridium IP Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@import VeridiumCore;

@interface VeridiumDefaultVFaceStartDialogViewController : UIViewController

+(instancetype) initiate;

@property (strong, nonatomic) voidBlock onCancel;
@property (strong, nonatomic) voidBlock onNext;

@end

