//
//  VeridiumBOPSAccount.h
//  VeridiumBOPS
//
//  Created by razvan on 8/8/16.
//  Copyright © 2016 Veridium. All rights reserved.
//

@import VeridiumCore;
#import "VeridiumBOPSIntegrationDefinitionData.h"
#import "VeridiumBOPSAccountData.h"
@class VeridiumBOPSAccountService;

/*!
 Subclass of VeridiumAccount for BOPS accounts
 */
@interface VeridiumBOPSAccount : VeridiumAccount

/*!
 The account name
 */
@property (readonly, nonnull) NSString* accountName;


/*!
 The account status string 
 
 The possible values are highly dependent on the business integration
 */
@property (nonnull) NSString* accountStatus;

/*!
 Last update check of licenses for account
 */
@property NSDate* lastUpdateLicenseOnClient;

@end
