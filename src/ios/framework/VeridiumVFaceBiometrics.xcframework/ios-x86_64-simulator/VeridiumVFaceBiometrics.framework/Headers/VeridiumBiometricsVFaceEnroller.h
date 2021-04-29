//
//  VeridiumBiometricsVFaceEnroller.h
//  VeridiumVFaceBiometrics
//
//  Created by Lewis Carney on 18/07/2018.
//  Copyright © 2018 veridium. All rights reserved.
//

#ifndef VeridiumBiometricsVFaceEnroller_h
#define VeridiumBiometricsVFaceEnroller_h

@import VeridiumCore;
#import "VeridiumBiometricsVFaceUI.h"

/*!
 Data class for holding the Face authetication config params
 */
@interface VeridiumVFaceEnrollConfig : NSObject

@property BOOL useLiveness;

@end

/*!
 The VFace biometric enroller.
 */
@interface VeridiumBiometricsVFaceEnroller : NSObject<VeridiumBioEnroller>
-(instancetype)configure:(VeridiumVFaceEnrollConfig *)config;
@property id<VeridiumVFaceUIDelegate> uiDelegate;
@property (readonly) VeridiumVFaceEnrollConfig* config;

@end


#endif /* VeridiumBiometricsVFaceEnroller_h */
