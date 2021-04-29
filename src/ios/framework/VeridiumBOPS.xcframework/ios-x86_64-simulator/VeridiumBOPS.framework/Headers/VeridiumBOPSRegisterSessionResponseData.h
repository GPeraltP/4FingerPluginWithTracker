//
//  VeridiumBOPSRegisterSessionResponseData.h
//  VeridiumBOPS
//
//  Created by razvan on 8/14/16.
//  Copyright © 2016 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VeridiumCore/VeridiumAbstractData.h>
#import "VeridiumBOPSBiometricData.h"

/*!
 Data class for parsing the response of the BOPS RegisterSession endpoint
 */
@interface VeridiumBOPSRegisterSessionResponseData : VeridiumAbstractData

/*!
 The profile id
 */
@property (readonly, nonnull) NSString* profileId;

/*!
 The session id
 */
@property (readonly, nonnull) NSString* sessionId;

/*!
 Array with the mandatory biometrics for the session (set by the server)
 */
@property (readonly, nullable) NSArray<VeridiumBOPSBiometricData*>* requiredBiometrics;

@end
