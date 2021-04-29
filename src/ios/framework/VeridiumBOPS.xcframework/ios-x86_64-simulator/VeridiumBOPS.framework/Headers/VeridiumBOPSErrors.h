//
//  VerdiumBOPSErrors.h
//  VeridiumBOPS
//
//  Created by razvan on 4/4/17.
//  Copyright © 2017 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
The error domain for all errors from VeridiumBOPS.
*/
FOUNDATION_EXPORT NSErrorDomain const _Nonnull VeridiumBOPSErrorDomain;

/**
The userInfo key for the internal server error description coming from the VeridiumID server. Expects `NSString` as value.
*/
FOUNDATION_EXPORT NSErrorUserInfoKey const _Nonnull VeridiumBOPSServerInternalErrorDescriptionKey;

/**
The userInfo key describing the absolute URL of a network request during which an error happened. Expects `NSURL` as value.
*/
FOUNDATION_EXPORT NSErrorUserInfoKey const _Nonnull VeridiumBOPSRequestURLKey;

/**
The userInfo key describing the operation/flow during which an error happened. Expects `NSString` as value.
*/
FOUNDATION_EXPORT NSErrorUserInfoKey const _Nonnull VeridiumBOPSOperationNameKey;

/**
The userInfo key describing the missing required parameters  in API call responses. Expects `NSArray` as value.
*/
FOUNDATION_EXPORT NSErrorUserInfoKey const _Nonnull VeridiumBOPSMissingParamsKey;

/**
VeridiumBOPSPairingError
Error codes for VeridiumBOPSErrorDomain.
*/
typedef NS_ERROR_ENUM(VeridiumBOPSErrorDomain, VeridiumBOPSPairingError) {
    VeridiumBOPSPairingErrorInvalidToken = 1015,
    VeridiumBOPSPairingErrorMissingPairingInfo = 1031,
    VeridiumBOPSPairingErrorUntrustedServer = 1032
};

/**
VeridiumBOPSServerConnectionError
Error codes for VeridiumBOPSErrorDomain.
*/
typedef NS_ERROR_ENUM(VeridiumBOPSErrorDomain, VeridiumBOPSServerConnectionError) {
    VeridiumBOPSServerConnectionErrorSocketTimeout = 1024,
    VeridiumBOPSServerConnectionErrorUnableToConnect = 1025,
    VeridiumBOPSServerConnectionErrorOther = -1025,
    VeridiumBOPSServerConnectionErrorClientCertificateRejected = -1205,
    VeridiumBOPSServerConnectionErrorServerRequiresClientCertificate = -1206
};

/**
VeridiumBOPSAccountRegistrationError
Error codes for VeridiumBOPSErrorDomain.
*/
typedef NS_ERROR_ENUM(VeridiumBOPSErrorDomain, VeridiumBOPSAccountRegistrationError) {
    VeridiumBOPSAccountRegistrationErrorFailingCSRGeneration = -1022,
    VeridiumBOPSAccountRegistrationErrorMissingIntegrationBiometries = -1022,
    VeridiumBOPSAccountRegistrationErrorFailingKeyGeneration = -1022,
    VeridiumBOPSAccountRegistrationErrorFailingClientCertificateGeneration = -1022
};

/**
VeridiumBOPSProfileRegistrationError
Error codes for VeridiumBOPSErrorDomain.
*/
typedef NS_ERROR_ENUM(VeridiumBOPSErrorDomain, VeridiumBOPSProfileRegistrationError) {
    VeridiumBOPSProfileRegistrationErrorMissingIntegrationBiometrics = -1022,
    VeridiumBOPSProfileRegistrationErrorMissingRequiredBiometrics = -1022,
    VeridiumBOPSProfileRegistrationErrorFailingKeyGeneration = -1022
};

/**
 VeridiumBOPSAPIResponseError
 Error codes for VeridiumBOPSErrorDomain.
 */
typedef NS_ERROR_ENUM(VeridiumBOPSErrorDomain, VeridiumBOPSAPIResponseError) {
    VeridiumBOPSAPIResponseErrorMissingResponseData = -1000,
    VeridiumBOPSAPIResponseErrorMalformedResponse = -1026
};
  
/**
VeridiumBOPSAuthenticationError
Error codes for VeridiumBOPSErrorDomain.
*/
typedef NS_ERROR_ENUM(VeridiumBOPSErrorDomain, VeridiumBOPSAuthenticationError) {
    VeridiumBOPSAuthenticationErrorInvalidOrMissingProfile = -1002,
    VeridiumBOPSAuthenticationErrorUnknownAuthenticationType = -1020,
    VeridiumBOPSAuthenticationErrorInvalidSessionInput = -1021,
    VeridiumBOPSAuthenticationErrorInvalidAuthenticationType = -1023,
    VeridiumBOPSAuthenticationErrorAuthenticationFailed = -1027,
    VeridiumBOPSAuthenticationErrorMissingRequiredAuthMethods = 1010
};


/**
 VeridiumBOPSErrorCode
 Error codes for VeridiumBOPSErrorDomain.
 */
typedef NS_ENUM(NSInteger, VeridiumBOPSErrorCode) {
  //VeridiumBOPSMissingDataForBOPSCallError = -1003,
  VeridiumBOPSAccountLockedError = -1004,
  VeridiumBOPSNoAccountRegisteredError = -1024,
  VeridiumBOPSSslHandshakeErrorPeer = 1033,
  VeridiumBOPSSslHandshakeErrorClient = 1034,
};


/**
 VeridiumBOPSServerError
 Error codes for VeridiumBOPSErrorDomain.
 */
typedef NS_ERROR_ENUM(VeridiumBOPSErrorDomain, VeridiumBOPSServerError) {
    VeridiumBOPSServerErrorGeneric = 100,
    VeridiumBOPSServerErrorInvalidParameter = 101,
    VeridiumBOPSServerErrorInvalidSessionOpportunityState = 111,
    VeridiumBOPSServerErrorDeviceNotFound = 118,
    VeridiumBOPSServerErrorAccountNotFound = 138,
    VeridiumBOPSServerErrorInvalidUserCredentials = 141,
    VeridiumBOPSServerErrorUserNotFound = 145,
    VeridiumBOPSServerErrorInvalidUnlockPassword = 153,
    VeridiumBOPSServerErrorInvalidUnlockSeed = 154,
    VeridiumBOPSServerErrorInvalidAccountState = 164,
    VeridiumBOPSServerErrorInvalidDeviceData = 165,
    VeridiumBOPSServerErrorAuthOngoingOnDifferenceDevice = 176,
    VeridiumBOPSServerErrorInvalidIntrusionDetectionValues = 303,
    VeridiumBOPSServerErrorProfileAlreadyRegistered = 606
};

#define kVeridiumBopsCustomIntegrationTranslationTable @"BopsCustomIntegrationErrorMessages"


/*!
 Abstract class of Bops errors
 */
@interface VeridiumBOPSError : NSError

/*!
 The operationName.
 */
@property (readonly, nullable) NSString* operationName;

@end


/*!
 Subclass of VeridiumBOPSError, for generic BOPS calls error
 */
@interface VeridiumBOPSCallError : VeridiumBOPSError

/*!
 The original request URL.
 */
@property (readonly, nullable) NSURL* requestURL;

+ (nonnull VeridiumBOPSCallError *)createConnectionErrorWithUnderlyingError:(nonnull NSError *)underlyingError
                                                                 requestURL:(nullable NSURL *)requestURL;

+ (nonnull VeridiumBOPSCallError *)createMissingResponseParamsError:(nonnull NSArray *)missingParams
                                                         requestURL:(nullable NSURL *)requestURL;

@end


/*!
 Subclass of VeridiumBOPSCallError, for internal errors
 */
@interface VeridiumBOPSServerInternalError : VeridiumBOPSCallError

/*!
 The localized server error message
 */
@property (readonly,nullable) NSString* localizedServerErrorMessage;


/*!
 Server's raw response error message
 */
@property (readonly,nullable) NSString* rawServerErrorMessage;

+ (nullable VeridiumBOPSServerInternalError *)getServerErrorIfExistsInResponseDictionary:(nullable NSDictionary *)responseDictionary
                                                                              requestURL:(nullable NSURL *)requestURL;

@end


/*!
 Subclass of VeridiumBOPSServerInternalError, for integration specific errors
 */
@interface VeridiumBOPSIntegrationCustomError : VeridiumBOPSServerInternalError

/*!
 The localized server error message
 */
@property (readonly,nullable) NSString* localizedServerErrorMessage;

/*!
 Server's raw response error message
 */
@property (readonly,nullable) NSString* rawServerErrorMessage;

@end
