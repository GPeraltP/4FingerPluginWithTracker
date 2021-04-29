//
//  VeridiumBOPSBiometricData.h
//  VeridiumBOPS
//
//  Created by razvan on 8/9/16.
//  Copyright © 2016 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VeridiumCore/VeridiumAbstractData.h>

/*!
 Data class for parsing requested BOPS Biometric or sending the result of a biometric authentication
 */
@interface VeridiumBOPSBiometricData : VeridiumAbstractData

/*!
 The biometric method aka engine name (eg. FACE, 4F)
 */
@property (readonly, nonnull) NSString* method;

/*!
 The auth status (true if succeeded)
 */
@property (readonly) BOOL status;

/*!
 Number of retries allowed
 */
@property (readonly) NSInteger retries;

@end
