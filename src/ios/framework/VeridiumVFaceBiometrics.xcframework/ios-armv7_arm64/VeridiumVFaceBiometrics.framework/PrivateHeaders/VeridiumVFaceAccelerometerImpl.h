//
//  VeridiumVFaceAccelerometerImpl.h
//  VeridiumVFaceBiometrics
//
//  Created by Lewis Carney on 19/09/2018.
//  Copyright © 2018 veridium. All rights reserved.
//

#ifndef VeridiumVFaceAccelerometerImpl_h
#define VeridiumVFaceAccelerometerImpl_h

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#include "libvface/IOSPlatformVFaceAccelerometer.h"

@interface VeridiumVFaceAccelerometerImpl : NSObject<IOSPlatformVFaceAccelerometer>

@property (nonatomic) float zDirectionGravityForCapture;
@property (nonatomic) float yDirectionGravityForCapture;
@property (nonatomic) float xDirectionGravityForCapture;
@property CMMotionManager* motionManager;

@end

#endif /* VeridiumVFaceAccelerometerImpl_h */
