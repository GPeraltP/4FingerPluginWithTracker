//
//  VeridiumBOPSLoginDefinitionData.h
//  VeridiumBOPS
//
//  Created by razvan on 8/9/16.
//  Copyright © 2016 HoyosLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VeridiumBOPSAuthenticationModeDefinitionData.h"
#import "VeridiumBOPSRegistrationModeDefinitionData.h"
#import <VeridiumCore/VeridiumAbstractData.h>
#import "VeridiumBOPSLoginDefMinimumRequirements.h"

/*!
 Data class for holding the login definition part of the BOPSIntegrationDefinitionData
 */
@interface VeridiumBOPSLoginDefinitionData : VeridiumAbstractData

/*!
 The array of [authentication modes]([BOPSAuthenticationModeDefinitionData])
 */
@property (readonly, nonnull) NSArray<VeridiumBOPSAuthenticationModeDefinitionData*>* authenticationModes;

/*!
 The array of [registration modes]([BOPSRegistrationModeDefinitionData])
 */
@property (readonly, nonnull) NSArray<VeridiumBOPSRegistrationModeDefinitionData*>* registrationModes;

/*!
 Disclamer text
 */
@property (readonly, nonnull) NSString* disclaimer;

/*
 Minimum requirements e.g. mobile os version.
 */
@property (readonly, nullable) VeridiumBOPSLoginDefMinimumRequirements* minimumRequirements;

@end
