//
//  VeridiumSDK+VFace.h
//  VeridiumVFaceBiometrics
//
//  Created by Lewis Carney on 18/07/2018.
//  Copyright © 2018 veridium. All rights reserved.
//

#ifndef VeridiumSDK_VFace_h
#define VeridiumSDK_VFace_h
@import VeridiumCore;
#import "VeridiumBiometricsVFaceEnroller.h"
#import "VeridiumBiometricsVFaceAuthenticator.h"
#import "VeridiumBiometricsVFaceUI.h"
#import "Constants.h"

/*!
 SDK 4F additions
 */
@interface VeridiumSDK (VFaceAdditions)

/*!
 Property returning VFace Library version as NSString
 */
@property (readonly, nonnull) NSString* libVFaceVersion;

/*!
 Helper method which prints in the DebugConsole the version of the VFace Library
 */
-(void)logVFaceBiometricsVersion;

/*!
 Register a VFace authenticator with a custom UI
 
 @param ui the custom UI
 */
-(void)registerVFaceAuthenticator:(id<VeridiumVFaceUIDelegate> _Nonnull)ui;

/*!
 Register a VFace enroller with a custom UI
 
 @param ui the custom UI
 */
-(void) registerVFaceEnroller:(id<VeridiumVFaceUIDelegate> _Nonnull)ui;

/*!
 Helper method to configure the registered VFace enroller
 
 @param config the config
 */
-(void)configureFaceEnroler:(VeridiumVFaceEnrollConfig * _Nonnull)config;


/*!
 Helper method to configure the registered VFace authenticator
 
 @param config the config
 */
-(void)configureFaceAuthenticator:(VeridiumVFaceAuthConfig * _Nonnull)config;



/*!
 Helper method for grabbing the registered VFace enroller
 
 @return the registered VFace enroller (or nil if not registered)
 */
@property (readonly, nullable) VeridiumBiometricsVFaceEnroller* enrollerVFace;


/*!
 Helper method for grabbing the registered VFace authenticator
 
 @return the registered VFace authenticator (or nil if not registered)
 */
@property (readonly, nullable) VeridiumBiometricsVFaceAuthenticator* authenticatorVFace;



/*!
 VFace Library setup helper.
 
 @param license the license
 @return the setup status.
 */
-(VeridiumVFaceLicenseStatus* _Nonnull)setupLibVFaceWithLicense:(NSString* _Nonnull)license;


@end

#endif /* VeridiumSDK_VFace_h */
