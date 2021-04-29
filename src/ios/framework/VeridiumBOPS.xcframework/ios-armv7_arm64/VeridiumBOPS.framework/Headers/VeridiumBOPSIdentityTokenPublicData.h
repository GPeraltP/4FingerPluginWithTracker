//
//  VeridiumBOPSIdentityTokenPublicData.h
//  VeridiumBOPS
//
//  Created by razvan on 8/9/16.
//  Copyright © 2016 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VeridiumCore/VeridiumAbstractData.h>
#import "VeridiumBOPSUbaOutput.h"

/*!
 Data class for parsing the BOPSIdentityTokenPublicData as part of the VeridiumBOPSSessionStatusResponseData response of the BOPS GetSessionStatus endpoint
 */
@interface VeridiumBOPSIdentityTokenPublicData : VeridiumAbstractData

/*!
 The token id
 */
@property (readonly, nonnull) NSString* tokenId;

/*!
 The authentication request time in millis
 */
@property (readonly) NSInteger authenticationRequestTimeMilliseconds;

/*!
 The authentication granted time in millis
 */
@property (readonly) NSInteger authenticationGrantedTimeMilliseconds;

/*!
 The authentication device id
 */
@property (readonly, nullable) NSString* authenticationDeviceId;


/*!
 The exploiter device id
 */
@property (readonly, nullable) NSString* exploiterDeviceId;

/*!
 The exipration time in millis
 */
@property (readonly) NSInteger expirationTimeMilliseconds;

/*!
 The subject
 */
@property (readonly, nonnull) NSString* subject;

/*!
 UBA response
 */
@property (readonly, nullable) VeridiumBOPSUbaOutput* ubaOutput;

@end
