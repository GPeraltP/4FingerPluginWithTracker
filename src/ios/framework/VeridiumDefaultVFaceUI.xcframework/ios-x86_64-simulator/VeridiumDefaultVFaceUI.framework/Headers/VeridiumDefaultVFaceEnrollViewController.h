//
//  VeridiumDefaultVFaceEnrollViewController.h
//  VeridiumDefaultVFaceUI
//
//  Created by Lewis Carney on 18/07/2018.
//  Copyright © 2018 veridium. All rights reserved.
//

#ifndef VeridiumDefaultVFaceEnrollViewController_h
#define VeridiumDefaultVFaceEnrollViewController_h

#import <UIKit/UIKit.h>
@import VeridiumCore;
@import VeridiumVFaceBiometrics;

/*!
 The default 4F enrollment View Controller.
 */
@interface VeridiumDefaultVFaceEnrollViewController : VeridiumVFaceViewController<VeridiumVFaceUIDelegate, UIAdaptivePresentationControllerDelegate>


+(instancetype _Nullable) createFromStoryboard:(UIStoryboard* _Nullable)storyboard withIdentifier:(NSString* _Nullable)identifier;


+(instancetype _Nullable) createDefault;

@end

#endif /* VeridiumDefaultVFaceEnrollViewController_h */
