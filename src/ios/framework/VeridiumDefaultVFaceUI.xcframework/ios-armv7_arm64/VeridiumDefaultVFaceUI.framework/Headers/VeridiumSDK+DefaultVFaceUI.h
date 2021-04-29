//
//  VeridiumSDK+DefaultVFaceUI.h
//  VeridiumDefaultVFaceUI
//
//  Created by Lewis Carney on 18/07/2018.
//  Copyright © 2018 veridium. All rights reserved.
//

#ifndef VeridiumSDK_DefaultVFaceUI_h
#define VeridiumSDK_DefaultVFaceUI_h

@import VeridiumCore;
@import VeridiumVFaceBiometrics;

/*!
 SDK default 4F UI additions
 */
@interface VeridiumSDK (DefaultVFaceAdditions)

/*!
 Method which registers the Default 4F UI and VeridiumBiometrics4FAuthenticator
 */
-(void) registerDefaultVFaceAuthenticator;

/*!
 Method which registers the Default 4F UI and VeridiumBiometrics4FEnroller
 */
-(void) registerDefaultVFaceEnroller;


@end


#endif /* VeridiumSDK_DefaultVFaceUI_h */
