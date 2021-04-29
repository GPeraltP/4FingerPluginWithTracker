//
//  VeridiumBOPSRegistrationModeDefinitionData.h
//  VeridiumBOPS
//
//  Created by razvan on 8/9/16.
//  Copyright © 2016 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VeridiumCore/VeridiumAbstractData.h>
#import "VeridiumBOPSParamDefinitionData.h"

/*!
 Data class holding VeridiumBOPSRegistrationModeDefinitionData data.
 */
@interface VeridiumBOPSRegistrationModeDefinitionData : VeridiumAbstractData

/*!
 The input status
 */
@property (readonly, nonnull )NSArray<NSString*>* inputStatus;

/*!
 The output statuses
 */
@property (readonly, nonnull) NSArray<NSString*>* outputStatuses;

/*!
 The tile
 */
@property (readonly, nonnull) NSString* title;

/*!
 The type
 */
@property (readonly, nonnull) NSString* type;

/*!
 The version
 */
@property (readonly, nonnull) NSString* version;

/*!
 The parameters
 */
@property (readonly, nonnull) NSArray<VeridiumBOPSParamDefinitionData*>* parameters;

/*!
 The agreement message
 */
@property (readonly, nullable) NSDictionary<NSString*,NSString*>* agreementMsg;

/*!
 The welcome message
 */
@property (readonly, nullable) NSDictionary<NSString*,NSString*>* welcomeMsg;

/*!
 The page description
 */
@property (readonly, nullable) NSString* pageDescription;

/*!
 The page action name
 */
@property (readonly, nullable) NSString* enrollmentStepActionName;

/*!
 The page enrollment restart action name
 */
@property (readonly, nullable) NSString* restartEnrollmentStepActionName;

/*!
 Hint for completion of enrollment step
 */
@property (readonly, nullable) NSString* hint;

/*!
 Hint for completion of enrollment step
 */
@property (readonly, nullable) NSString* enforcedErrorMessage;

@end
