//
//  VeridiumBiometricsVFaceAuthenticator.h
//  VeridiumVFaceBiometrics
//
//  Created by Josiah Kane on 09/08/2018.
//  Copyright © 2018 veridium. All rights reserved.
//

#ifndef VeridiumBiometricsVFaceAuthenticator_h
#define VeridiumBiometricsVFaceAuthenticator_h

@import VeridiumCore;
#import "VeridiumBiometricsVFaceUI.h"

/*!
 Data class for holding the Face authetication config params
 */
@interface VeridiumVFaceAuthConfig : NSObject

@property BOOL useLiveness;

@end

/*!
 The VFace biometric authenticator.
 */
@interface VeridiumBiometricsVFaceAuthenticator : NSObject<VeridiumBioAuthenticator>
-(instancetype)configure:(VeridiumVFaceAuthConfig *)config;
@property id<VeridiumVFaceUIDelegate> uiDelegate;
@property (readonly) VeridiumVFaceAuthConfig* config;
@end


#endif /* VeridiumBiometricsVFaceAuthenticator_h */
