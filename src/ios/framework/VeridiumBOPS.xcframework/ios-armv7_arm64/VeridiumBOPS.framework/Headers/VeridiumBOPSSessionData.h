//
//  VeridiumBOPSSessionData.h
//  VeridiumBOPS
//
//  Created by razvan on 2/16/17.
//  Copyright © 2017 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VeridiumCore/VeridiumAbstractData.h>
#import "VeridiumBOPSBiometricData.h"
#import "VeridiumBOPSSessionContext.h"


/*!
 Data class holding the VeridiumBOPSSessionData data.
 */
@interface VeridiumBOPSSessionData : VeridiumAbstractData

/*!
 The session status
 */
@property (readonly, nonnull) NSString* sessionStatus;

/*!
 The session transaction text
 */
@property (readonly, nonnull) NSString* transactionText;

/*!
 The session id
 */
@property (readonly, nonnull) NSString* sessionId;

/*!
 The profile id (for registered sessions)
 */
@property (readonly, nullable) NSString* profileId;

/*!
 The profile id (for registered sessions)
 */
@property (readonly, nullable) NSString* profileExternalId;

/*!
 Array with the mandatory biometrics for the session (set by the server)
 */
@property (readonly, nullable) NSArray<VeridiumBOPSBiometricData*>* requiredBiometrics;

/*!
 expiration time in ms
 */
@property (readonly) long expiration;

/*!
 Context data
 */
@property (readonly, nullable) VeridiumBOPSSessionContext* context;


@end
