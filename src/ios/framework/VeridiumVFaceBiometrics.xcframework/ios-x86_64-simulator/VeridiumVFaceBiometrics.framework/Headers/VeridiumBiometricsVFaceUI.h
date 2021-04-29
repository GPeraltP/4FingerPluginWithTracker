//
//  VeridiumBiometricsVFaceCommon.h
//  VeridiumVFaceBiometrics
//
//  Created by Lewis Carney on 18/07/2018.
//  Copyright © 2018 veridium. All rights reserved.
//

#ifndef VeridiumBiometricsVFaceCommon_h
#define VeridiumBiometricsVFaceCommon_h

@import VeridiumCore;
#import <UIKit/UIKit.h>
#include "IOSPlatformVFaceGui.h"

typedef enum VFaceUIDismissReason
{
    ERROR_UNKNOWN = -1,
    CANCEL = -8,
    TIMEOUT = -10,
    FAIL_ENROL = -11,
    FAIL_MATCH = -12,
    SUCCESS_ENROLL = 0,
    SUCCESS_AUTHENTICATE = 1,
    FAIL_LIVENESS = 200
} DismissReason;

/*!
 The VeridiumVFaceEnrollerUIDelegate subprotocol with UI delegate methods & props specific to VFace enrollment
 */
@protocol VeridiumVFaceUIDelegate<IOSPlatformVFaceGui>
/*!
 Ask the UI to present itself and waits for completion
 
 @param doneBlock    the completion callback voidBlock
 @param cancelBlock  the completion callback voidBlock
 */
-(void) show:(voidBlock _Nonnull) doneBlock cancel:(voidBlock _Nonnull) cancelBlock withIntroScreen:(BOOL) showIntroScreen;

-(UIView *) getPreviewHolder;

-(void) dismiss:(voidBlock _Nonnull) doneBlock withReason:(DismissReason) reason;

-(UIViewController*) getController;

@end

@interface VeridiumVFaceViewController : UIViewController

//Do not override this method
-(void) requestCancel;

@end

#endif /* VeridiumBiometricsVFaceCommon_h */
