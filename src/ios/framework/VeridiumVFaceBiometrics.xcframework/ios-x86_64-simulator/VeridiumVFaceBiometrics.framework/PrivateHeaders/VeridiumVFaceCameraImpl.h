//
//  VeridiumVFaceCameraImpl.h
//  VeridiumVFaceCamera
//
//  Created by Lewis Carney on 19/07/2018.
//  Copyright © 2018 veridium. All rights reserved.
//

#ifndef VeridiumVFaceCameraImpl_h
#define VeridiumVFaceCameraImpl_h

#import <UIKit/UIKit.h>

#include "libvface/IOSPlatformVFaceCamera.h"

@interface VeridiumVFaceCameraImpl : NSObject<IOSPlatformVFaceCamera>

-(void) setPreviewHolder:(UIView *) previewHolder;

@end


#endif /* VeridiumVFaceCameraImpl_h */
