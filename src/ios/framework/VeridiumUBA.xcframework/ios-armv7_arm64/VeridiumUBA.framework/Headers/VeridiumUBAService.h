//
//  VeridiumUBAService.h
//  VeridiumUBA
//
//  Created by Alex ILIE on 09/01/2019.
//  Copyright © 2019 VeridiumID. All rights reserved.
//

#import <Foundation/Foundation.h>
@import VeridiumCore;
#import "VeridiumUBASessionData.h"

@interface VeridiumUBAService : NSObject

/*!
 Session started so start collecting data for it
 */
+(void) sessionStartedFromEvent:(NSString*_Nullable) eventName
                      sessionId:(NSString*_Nullable) sessionId;

+(void) sessionEndedWithSuccess:(BOOL) success
                     onComplete:(ubaDataBlock)onComplete;

/*!
 Set UBA data collect the `sessionId`
 */
+(void) setSession:(NSString* _Nonnull)sessionId;

+(void) addEvent:(NSString* _Nonnull)event;

+(BOOL) isSessionActive;

@end
