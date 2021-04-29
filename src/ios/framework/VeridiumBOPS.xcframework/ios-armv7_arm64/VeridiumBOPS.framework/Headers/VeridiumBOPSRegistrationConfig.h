  //
//  VeridiumBOPSRegistrationConfigWithVector.h
//  VeridiumBOPS
//
//  Created by Catalin Stoica on 28/11/16.
//  Copyright © 2016 Veridium. All rights reserved.
//

@import VeridiumCore;
#import "VeridiumBOPSAccount+Authentication.h"

/*!
 The VeridiumBOPSRegistrationConfig data class.
 */
@interface VeridiumBOPSRegistrationConfig : NSObject

/*!
 BOPS bussiness integration external identifier see __Integrations/your integration/External ID__ field in your BOPS admin console
 */
@property (readonly, nonnull) NSString* integrationExternalId;

/*!
 One of the registration modes available for the chosen business integration - these are integration specific (e.g 'form','QR','1Tap',etc.) see the __Integrations/your integration/Login definition__ section in your BOPS admin console
 */
@property (readonly, nonnull) NSString* registrationMode;

/*!
 Dictionary with data collected from the user using the meta information specified by the registration mode
 */
@property (readonly, nonnull) NSDictionary* loginData;

/*!
 The biometric vector.
 */
@property (readonly, nullable) NSArray<VeridiumBiometricFullVector*>* vectors;

/*!
 The default authentication methods (engines) to be set for the registered account
 */
@property (readonly, nonnull) NSArray<NSString*>* defaultBiometricMethods;

/*!
 Property storing the BOPS authentication type.
 */
@property (readonly) BOPSAuthenticatorType authenticatorType;


/*!
 Designated class initializer.

 @param integrationExternalId the integration External Id
 @param registrationMode the registration mode e.g.(form, QR..)
 @param authenticatorType the authenticatorType
 @param loginData additional login data e.g (username and password..)
 @param defaultBiometricMethods the default biometrics
 @param biometricVectors an array of `VeridiumBiometricFullVector`(s)
 @return self
 */
-(instancetype _Nonnull)initWithIntegrationExternalId:(NSString* _Nonnull) integrationExternalId
                                     registrationMode:(NSString* _Nonnull) registrationMode
                                    authenticatorType:(BOPSAuthenticatorType) authenticatorType
                                            loginData:(NSDictionary* _Nonnull) loginData
                              defaultBiometricMethods:(NSArray<NSString*>* _Nonnull) defaultBiometricMethods
                           biometricEnrollmentVectors:(NSArray<VeridiumBiometricFullVector*>* _Nullable) biometricVectors;


@end
