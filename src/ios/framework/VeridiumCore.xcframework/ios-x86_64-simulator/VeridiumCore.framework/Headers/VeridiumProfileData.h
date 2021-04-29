//
//  VeridiumProfileData.h
//  VeridiumCore
//
//  Created by Alex ILIE on 17/04/2019.
//  Copyright © 2019 Veridium IP Ltd. All rights reserved.
//

#import "VeridiumAbstractData.h"

/*!
 Data class for holding a registered profile data
 
 This profiles, once created or fetched from the server, are stored in the keychain storage in the context of the BOPSAccount they belong to.
 
 The profiles are made available via the VeridiumAccount [profiles]([VeridiumAccount profiles]) property
 
 __See also__
 
 - [VeridiumAccount profiles]
 - [VeridiumAccount profileById:]
 - [VeridiumAccount profileByExternalId:]
 
 */
@interface VeridiumProfileData : VeridiumAbstractData

/*!
 The profile unique id (an UUID generated by the BOPS server during profile registration)
 */
@property (readonly, nonnull) NSString* profileId;

/*!
 The profile external identifier
 */
@property (readonly, nonnull) NSString* profileExternalId;

/*!
 The profile display name
 */
@property (readonly, nonnull) NSString* displayName;

/*!
 The profile's business integration external identifier
 */
@property (readonly, nonnull) NSString* integrationExternalId;

/*!
 Container for arbitrary data (business integration specific)
 */
@property (readonly, nullable) NSDictionary* externalValues;

/*!
 The profile status string (business integration specific)
 */
@property (readonly, nonnull) NSString* status;

/*!
 The profile (serverside) encrypted login data
 */
@property (readonly, nullable) NSString* encryptedLoginData;

/*!
 The credentials (serverside) encrypted data
 */
@property (readonly, nullable) NSString* encryptedCredentialsData;

@property (readonly, nullable) NSDictionary* deviceIdSecretMap;

/*
 TOTP authentication parameters. Do not confuse with the AD OTP for offline authentication!
 This is used for as an alternative to biometric authenticators for this profile.
 */
- (void)setTOTPOptions:(nonnull NSDictionary *)options;

@property (readonly, nullable) NSString* totpSeed;
@property (readonly) NSUInteger totpValidity;
@property (readonly, nullable) NSString* totpAlgorithm;
@property (readonly) NSUInteger totpLength;

/*!
 The profile user defined required biometric auth methods
 
 This setting can be changed at anytime by calling [BOPSAccount updateProfile]([BOPSAccount bopsUpdateProfile:credentials:registrationMode:biometricMethods:extraValues:onSuccess:onError:])
 
 __IMPORTANT__ During authentication this setting does NOT override the [integration level mandatory biometric methods]([BOPSIntegrationDefinitionData biometricMethods]), but they are merged, eg. business integration methods: ['Face','4F'], profile methods ['Face'] => Authentication methods: ['Face','4F']
 */
@property (readonly, nullable) NSArray<NSString*>* biometricMethods;

/*!
 The profile integration defined enrollment available biometric methods
 */
@property (readonly, nullable) NSArray<NSString*>* availableBiometricMethods;

/*!
 The profile integration defined mandatory biometric methods
 */
@property (readonly, nullable) NSArray<NSString*>* requiredBiometricMethods;

@property (readonly) BOOL isTOTPOnly;
@property (readonly) BOOL containsTOTP;

///*!
// The profile corresponding BOPSIntegrationDefinitionData instance
// */
//@property (readonly, nonnull) VeridiumBOPSIntegrationDefinitionData* integration;

@end