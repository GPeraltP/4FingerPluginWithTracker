// Copyright © Veridium IP Ltd., 2018. All rights reserved
// This source is the sole property of Veridium IP Ltd and should not be copied
// in full or in part.

#ifndef IOSPlatformGui_h
#define IOSPlatformGui_h

typedef enum {
    VFaceInstructionBlank = 0,
    VFaceInstructionNoFace,
    VFaceInstructionMoveAway,
    VFaceInstructionMoveCloser,
    VFaceInstructionMoveDown,
    VFaceInstructionMoveUp,
    VFaceInstructionMoveLeft,
    VFaceInstructionMoveRight,
    VFaceInstructionNeedLevel,
    VFaceInstructionNeedFrontal,
    VFaceInstructionNeedSteady,
    VFaceInstructionNeedBrighter,
    VFaceInstructionNeedDarker,
    VFaceInstructionNeedSteadyFrontal,
    VFaceInstructionNeedHeadShakeHorizontal,
    VFaceInstructionNeedUprightPhone,
    VFaceInstructionNeedUpwardFacingPhone,
    VFaceInstructionProcessing,
    VFaceInstructionRemoveSunglasses,
} VeridiumVFaceIOSUserInstruction;

@protocol IOSPlatformVFaceGui

- (void)handleUIInstruction:(VeridiumVFaceIOSUserInstruction)instruction;

- (void)displayFeaturePointsWithXValues:(NSMutableArray<NSNumber*>*)xPoints
                             andYValues:(NSMutableArray<NSNumber*>*)yPoints;

- (void)processingStarted;

- (void)processingFinished;

@end

// This is a promise that the VFace library will implement these functions.
#ifdef __cplusplus
extern "C" {
#endif
void libvface_ios_gui_requestCancel(void);
#ifdef __cplusplus
}
#endif

#endif  // IOSPlatformGui_h
