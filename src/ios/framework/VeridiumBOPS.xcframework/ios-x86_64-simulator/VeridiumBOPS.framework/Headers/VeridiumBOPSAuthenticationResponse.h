//
//  VeridiumBOPSAuthenticationResponse.h
//  VeridiumBOPS
//
//  Created by Alex ILIE on 18/11/2019.
//  Copyright © 2019 Veridium IP Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VeridiumCore/VeridiumAbstractData.h>
#import "VeridiumBOPSIdentityTokenPublicData.h"
NS_ASSUME_NONNULL_BEGIN


/*!
 Data class for parsing the AuthenticationResponse message from the Veridium server
 */
@interface VeridiumBOPSAuthenticationResponse : VeridiumAbstractData

/*!
 The mode title
 */
@property (readonly, nonnull) NSString* status;

/*!
 The sessionID
 */
@property (readonly, nonnull) NSString* sessionID;

/*!
 Resulting identity token for a successful authentication
 */
@property (readonly, nullable) VeridiumBOPSIdentityTokenPublicData* identityToken;

/*!
 Resulting identity token for a successful authentication in JWT format
 */
@property (readonly, nullable) NSString* identityTokenJWT;

@end

NS_ASSUME_NONNULL_END
