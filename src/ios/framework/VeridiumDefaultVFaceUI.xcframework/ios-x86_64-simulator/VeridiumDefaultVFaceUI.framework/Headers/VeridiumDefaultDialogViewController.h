//
//  VeridiumDefaultDialogViewController.h
//
//  Created by Lewis Carney on 25/01/2018.
//  Copyright © Veridium IP Ltd., 2018. All rights reserved
//

#import <UIKit/UIKit.h>
@import VeridiumCore;

@interface VeridiumDefaultDialogViewController : UIViewController

@property (nonatomic) UITapGestureRecognizer* subTextStringGesture;
@property (nonatomic) NSString* mainTextString;
@property (nonatomic) NSString* subTextString;
@property (nonatomic) NSString* cancelButtonTextString;
@property (nonatomic) NSString* nextButtonTextString;
@property (strong, nonatomic) voidBlock onCancel;
@property (strong, nonatomic) voidBlock onNext;
@property (nonatomic) UIImage* backgroundImageToUse;
@property (nonatomic) UIImage* foregroundImageToUse;

@end
