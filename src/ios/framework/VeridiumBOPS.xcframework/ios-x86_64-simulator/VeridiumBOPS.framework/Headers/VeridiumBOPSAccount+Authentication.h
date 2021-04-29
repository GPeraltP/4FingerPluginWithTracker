//
//  VeridiumBOPSAccount+Authentication.h
//  VeridiumBOPS
//
//  Created by razvan on 8/10/16.
//  Copyright © 2016 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VeridiumBOPSAccount.h"
#import "VeridiumBOPSSessionData.h"
#import "VeridiumBOPSErrors.h"

@interface VeridiumBOPSAccount (Authentication)

/*!
 The authentication side (where is the BOPS authentication performed on client or server)
 */
@property (readonly) BOPSAuthenticatorType authenticatorType;

/*!
 Performs an authentication with Transaction Signing.

 @param sessionData active Bops session
 @param transactionTextFormatString a string representing a format string for displaying the transaction text in the authentication UI (e.g @"Your are authenticating for %@" where '%@' will be replaced with the actual transaction text). Can be used for wrapping or translating. If [NSString stringWithFormat:transactionTextFormatString, transactionText] evaluates to an empty string, the SDK will pass your translation of the "Please authenticate" string
 @param completion the callback contaning the error if any occurred and the aggregated authentication result.
 */

-(void) authenticateTXOnActiveSession:(VeridiumBOPSSessionData* _Nonnull)sessionData
          transactionTextFormatString:(NSString* _Nullable)transactionTextFormatString
                       withCompletion:(void(^ _Nonnull)(VeridiumAggregatedTXSignAuthResult* _Nullable authResult, NSError * _Nullable error)) completion;

-(void) longPollForSessionStatus:(NSString* _Nonnull)sessionId withCompletion:(void (^ _Nonnull)(NSDictionary * _Nullable sessionStatus, NSError * _Nullable error))completion;


@end
