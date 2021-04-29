//
//  VeridiumSDK+Forms.h
//  VeridiumForms
//
//  Created by Paul Paul on 9/15/17.
//  Copyright © 2017 VeridiumID. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VeridiumFormsGenerator.h"
@import VeridiumCore;
@import VeridiumBOPS;

/*!
 SDK addition wrapping forms generator.
 */
@interface VeridiumSDK (VeridiumForms)

-(VeridiumFormsGenerator* _Nullable) createFormsGeneratorWithType:(VeridiumFormType)formType forRegistrationModes:(NSArray<VeridiumBOPSRegistrationModeDefinitionData *> * _Nonnull)registrationModes;

@end
