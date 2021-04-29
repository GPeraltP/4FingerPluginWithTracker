//
//  BOPSAccountData.h
//  VeridiumBOPS
//
//  Created by razvan on 8/9/16.
//  Copyright © 2016 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VeridiumCore/VeridiumAbstractData.h>

/*!
 Data class for holding the BOPS Account data (parsed from the register account response)
 */
@interface VeridiumBOPSAccountData : VeridiumAbstractData

/*!
 The application id
 */
@property (readonly, nonnull) NSString* applicationId;

/*!
 The account external identifier (used as account name)
 */
@property (readonly, nonnull) NSString* externalId;

/*!
 The account unique identifier
 */
@property (readonly, nonnull) NSString* accountId;

@end
