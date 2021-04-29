//
//  VeridiumBOPSSessionStatusResponseData.h
//  VeridiumBOPS
//
//  Created by razvan on 8/9/16.
//  Copyright © 2016 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VeridiumBOPSIdentityTokenPublicData.h"
#import "VeridiumBOPSBiometricData.h"
#import <VeridiumCore/VeridiumAbstractData.h>

/*!
 Data class for parsing the response of the BOPS GetSessionStatus/RegisterSession endpoints
 */
@interface VeridiumBOPSSessionStatusResponseData : VeridiumAbstractData

/*!
 The session status
 */
@property (readonly, nonnull) NSString* status;

/*!
 The session id
 */
@property (readonly, nonnull) NSString* sessionId;

/*!
 The session expiration time in millis
 */
@property (readonly) NSInteger expirationMilliseconds;

/*!
 Arbitrary data (set via the extra values param when the session was created)
 */
@property (readonly, nullable) NSDictionary* extraData;

/*!
 The identity token public data
 */
@property (readonly, nullable) VeridiumBOPSIdentityTokenPublicData* identityToken;

/*!
 The identity token in JWT format
 */
@property (readonly, nullable) NSString* identityTokenJWT;

/*!
 The mandatory biometrics 
 */
@property (readonly, nullable) NSArray<VeridiumBOPSBiometricData*>* requiredBiometrics;

@end
