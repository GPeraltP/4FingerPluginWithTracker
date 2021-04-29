//
//  VeridiumQR.h
//  VeridiumQRReader
//
//  Created by Paul Paul on 7/25/17.
//  Copyright © 2017 VeridiumID. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VeridiumQRType) {
  VeridiumQRTypeDashed = 0,
  VeridiumQRTypeSquareCorners,
};


/**
 VeridiumQR designated UI delegate protocol
 */
@protocol VeridiumQRUIDelegateProtocol <NSObject>

@required

/**
 Passing the camera preview view.

 @return the camera preview view.
 */
-(UIView* _Nonnull)previewView;

@end

/**
 VeridiumQR reader engine.
 */
@interface VeridiumQR : NSObject

/**
 Prints in the debug console the version of the framework.

 @return  the version of the framework.
 */
+(NSString* _Nonnull)version;

/**
 The ui delegate.
 */
@property(nonnull)id <VeridiumQRUIDelegateProtocol> uiDelegate;

/**
 Whether the engine should pause QR detection. Defaults to NO.
 */
@property BOOL pauseEngine;

/**
 Whether the camera is setup or not.
 */
@property (readonly) BOOL isCameraSetup;

/**
 Method sets up and starts the camera.
 */
-(void)setupAndStartCamera;

/**
 Starts scanning for QR codes

 @param onResult qr code data as String.
 */
-(void)startScanning:(void(^ _Nonnull)(NSString* _Nullable result))onResult;

/**
 Stops the camera.
 */
-(void)stopCamera;

/**
 Adds a dashed pattern in the center for the preview view.
 */
-(void)addDashedOverlay;

/**
 Adds a square pattern in the center for the preview view.
 */
-(void)addSquareOverlay;

/**
 Static method for in-line qr scanning and default UI.

 @param type                    overlay frame type
 @param description             the description for Human-Interface if needed.
 @param onResult                the qr result as string.
 @param onCancel                on cancel callback.
 @param onProcessInterrupted    when the process in interrupted this block is called, i.e. another VC is presented, etc..
 */
+(void)startScanningWithType:(VeridiumQRType)type
                 description:(NSString* _Nullable)description
                    onResult:(void(^ _Nonnull)(NSString* _Nullable result))onResult
                    onCancel:(void(^ _Nullable )(void))onCancel
        onProcessInterrupted:(void(^ _Nullable )(void))onProcessInterrupted;

@end
