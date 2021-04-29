// Copyright © Veridium IP Ltd., 2018. All rights reserved
// This source is the sole property of Veridium IP Ltd and should not be copied
// in full or in part.

#ifndef IOSPlatformGui_h
#define IOSPlatformGui_h

#include <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>


typedef enum {
    FourFInstructionWait = 0,
    FourFInstructionOutOfFocus,
    FourFInstructionYes,
    FourFInstructionRoiTooBig,
    FourFInstructionRoiTooSmall,
    FourFInstructionFingersTooFarApart,
    FourFInstructionFingersHigh,
    FourFInstructionFingersLow,
    FourFInstructionFingersFarLeft,
    FourFInstructionFingersFarRight,
    FourFInstructionImageRequestedWaiting,
    FourFInstructionInvalidROIS,
    FourFInstructionImageTooDim
    // Do not renumber or reorder
} VeridiumFourFIOSUserInstruction;

typedef enum {
    FourFBlockingInstructionNONE = 0,
    FourFBlockingInstructionSWITCH_CAPTURE_TARGET,
    FourFBlockingInstructionENROLLMENT_STEP2_OF_2,
    FourFBlockingInstructionENROLLMENT_STEP2_OF_3,
    FourFBlockingInstructionENROLLMENT_STEP3_OF_3,
    FourFBlockingInstructionINTERNAL_MISMATCH,
    FourFBlockingInstructionDISPLAY_HELP
    // Do not renumber or reorder, or keep in sync with main FourF::Interface::BlockingUserInstruction
} VeridiumFourFIOSBlockingUserInstruction;

typedef enum {
    FourFCaptureModeHand = 0,
    FourFCaptureModeThumb,
    FourFCaptureModeFinger,
    FourFCaptureModeAgentHand,
} VeridiumFourFCaptureMode;

typedef enum {
    FourFPrintToCaptureINVALID = 0,
    FourFPrintToCaptureTHUMB_RIGHT,
    FourFPrintToCaptureINDEX_RIGHT,
    FourFPrintToCaptureMIDDLE_RIGHT,
    FourFPrintToCaptureRING_RIGHT,
    FourFPrintToCaptureLITTLE_RIGHT,
    FourFPrintToCaptureTHUMB_LEFT,
    FourFPrintToCaptureINDEX_LEFT,
    FourFPrintToCaptureMIDDLE_LEFT,
    FourFPrintToCaptureRING_LEFT,
    FourFPrintToCaptureLITTLE_LEFT,
    FourFPrintToCaptureHAND_RIGHT,
    FourFPrintToCaptureHAND_LEFT
} VeridiumFourFPrintToCapture;

typedef enum {
    FourFBlockingUserActionNext = 0,
    FourFBlockingUserActionCancel
    // Do not renumber or reorder, or keep in sync with main FourF::Interface::BlockingUserAction
} VeridiumFourFIOSBlockingUserAction;

@protocol IOSPlatformFourFGui

- (void)displayUserInstruction:(VeridiumFourFIOSUserInstruction)instruction;


- (void)displayBlockingUserInstruction:(VeridiumFourFIOSBlockingUserInstruction)instruction;

- (void)setPreviewResolutionToWidth:(int)width andHeight:(int)height;

- (void)configureUI:(VeridiumFourFCaptureMode)captureMode withPrintToCapture:(VeridiumFourFPrintToCapture)printToCapture andTargetRegion:(CGRect)targetRegion andCanSwitchHand:(BOOL)canSwitch;

// Rois is an NSArray of CGRect values.
// handDistance is a float, values between -1 and 1 are acceptable.
- (void)displayRealTimeInformation:(NSArray<NSValue*>*)rois andHandDistance:(float)handDistance;

- (void)onProcessingStart;

- (void)onProcessingStop;

- (void)onTakePictureStart;

- (void)onTakePictureStop;

- (void)indicateImageAcceptance;

- (void)indicateImageRejection;

@end

// This is a promise that the FourF library will implement these functions.
#ifdef __cplusplus
extern "C" {
#endif
void libffid_ios_gui_requestCancel(void);
void libffid_ios_gui_requestSwitchHand(void);
void libffid_ios_gui_requestHelp(void);
void libffid_ios_gui_handledBlockingUIInstructionWithAction(VeridiumFourFIOSBlockingUserAction userAction);
#ifdef __cplusplus
}
#endif

#endif  // IOSPlatformGui_h
