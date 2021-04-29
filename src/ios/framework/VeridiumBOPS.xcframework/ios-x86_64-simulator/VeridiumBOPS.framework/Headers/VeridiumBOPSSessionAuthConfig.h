//
//  VeridiumBOPSSessionAuthConfig.h
//  VeridiumBOPS
//
//  Created by razvan on 8/9/16.
//  Copyright © 2016 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 Data class holding a BOPS authentication session parameters
 */
@interface VeridiumBOPSSessionAuthConfig : NSObject

/*!
 The session unique identifier
 */
@property (nonnull) NSString* sessionId;

/*!
 The session type (integration dependent eg. QR, PUSH)
 */
@property (nonnull) NSString* sessionType;

/*!
 The profile id of the authenticating profile
 */
@property (nonnull) NSString* profileId;

/*!
 Arbitrary data to be stored by BOPS in the context of this session
 */
@property (nonnull) NSDictionary* extraValues;


/*!
 Designated initializer
 
 @param sessionId   the session id
 @param sessionType the session type
 @param profileId   the profile id
 @param extraValues arbitrary data for the session context (integration dependent)
 
 */
-(instancetype _Nonnull)initWithSessionId:(NSString* _Nonnull) sessionId
                              sessionType:(NSString* _Nonnull) sessionType
                                profileId:(NSString* _Nonnull) profileId
                              extraValues:(NSDictionary* _Nonnull) extraValues;

@end