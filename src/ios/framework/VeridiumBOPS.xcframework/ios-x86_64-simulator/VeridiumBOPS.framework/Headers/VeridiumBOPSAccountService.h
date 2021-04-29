//
//  VeridiumBOPSAccountService.h
//  VeridiumBOPS
//
//  Created by razvan on 8/9/16.
//  Copyright © 2016 Veridium. All rights reserved.
//

@import VeridiumCore;
#import "VeridiumBOPSAccount.h"
#import "VeridiumBOPSRegistrationConfig.h"
#import "VeridiumBOPSServerInfoData.h"
#import "VeridiumBOPSEndpointInfo.h"

/*!
 Alias for blocks receiving a VeridiumLocalAccount argument
 */
typedef void(^bopsAccountBlock)(VeridiumBOPSAccount* _Nonnull account);

/*!
 Alias for blocks receiving a Bops respone and an error as argument
 */
typedef void (^bopsCallBlock)(NSDictionary * _Nullable response, NSError * _Nullable error);


/*!
 The BOPS implementation of the AccountService abstract class
 
 An instance of this class is automatically instantiated on a successful [VeridiumSDK setup:] and is made avaliable via the [VeridiumSDK accountService] property
 */
@interface VeridiumBOPSAccountService : VeridiumAccountService <VeridiumPushHandlerProtocol>

/*!
 @name Raw BOPS calls support
 */

@property (readonly, nonatomic, nullable) VeridiumBOPSAccount* activeBopsAccount;

/*!
 Calls BOPS on specified endpoint with the default certificate.

 @param endpoint      the enpoint
 @param params        call parameters
 @param completion    the bops call callback
 */
-(nullable NSURLSessionTask*)callBOPSWithDefaultCertificateOnEndpoint:(nonnull VeridiumBOPSEndpointInfo *)endpoint
                                     withParams:(nonnull NSDictionary *)params
                              completionHandler:(bopsCallBlock _Nonnull)completion;


/*!
 Calls BOPS on specified endpoint with the generated client certificate.
 
 @param endpoint      the enpoint
 @param params call   parameters
 @param completion    the bops call callback
 */
-(void)callBOPSWithGeneratedCertificateOnEndpoint:(nonnull VeridiumBOPSEndpointInfo *)endpoint
                                       withParams:(nonnull NSDictionary *)params
                                completionHandler:(nonnull bopsCallBlock)completion;

/*!
Calls BOPS on specified endpoint with the generated client certificate.

@param endpoint      the enpoint
@param params call   parameters
@param completion    the bops call callback
*/
-(nullable NSURLSessionTask*)callBOPSWithGeneratedCertificateReturningTaskOnEndpoint:(nonnull VeridiumBOPSEndpointInfo *)endpoint
       withParams:(nonnull NSDictionary *)params
completionHandler:(nonnull bopsCallBlock)completion;

/*!
 @name Account management
 */


/*!
 Sends CSR for client certificate renewal to VeridiumID
 
 @param sessionId               Recent authenticated sessionID used to authorize the certificate renewal.
 SessionID is received on push notification 'revalidate_device'
 @param successBlock              success callback
 @param errorBlock                   error block callback
 */
-(void)renewClientCertificateWithSessionId:(NSString*)sessionId
                                 onSuccess:(voidBlock _Nonnull)successBlock
                                   onError:(errorBlock _Nonnull)errorBlock;

/*!
 Sends CSR for client certificate renewal to VeridiumID
 
 @param sessionId               Recent authenticated sessionID used to authorize the certificate renewal.
                                SessionID is received on push notification 'revalidate_device'
 @param completion              the callback contaning the error if any occurred and the newly created Bops account.
 */
-(void)renewClientCertificateWithSessionId:(NSString*)sessionId
                            withCompletion:(void (^_Nullable)(NSError * _Nullable))completion;
    
/*!
 Accessor for domain root that this account serves
 */
@property (readonly, nonnull) NSString* domainRoot;

///------------
/// @name Global BOPS instance properties
///------------

/*!
 All the business integrations available in your BOPS instance
 */
@property (readonly, nonnull) NSArray<VeridiumBOPSIntegrationDefinitionData*>* integrationDefinitions;


/*!
 The BOPS instance system settings
 */
@property (readonly, nonnull) NSDictionary* systemSettings;

/*!
 The time difference between the server and the device
 */
@property (readonly) NSTimeInterval serverTimeDifference;

/*!
 Calculates time difference between the server and the device's local time and persists in user defaults
 */
- (void) calculateServerTimeDifferenceUsing:(NSNumber *_Nonnull)serverTimeMsec;

/*!
 Helper method for locating a business integration by its external identifier
 
 @param integrationExternalId the integration external identifier
 
 @return the corresponding BOPSIntegrationDefinitionData instance if found, `nil` otherwise
 */
-(VeridiumBOPSIntegrationDefinitionData* _Nullable) integrationDefByExternalId:(NSString* _Nonnull) integrationExternalId;



/*!
 Retrieves the BOPS server information
 
 @param onSuccess    success voidBlock callback
 @param onError      error intAndStringBlock callback (receiving BOPSError + Translated error message)
 */
-(void) bopsGetServerInfo:(void(^ _Nonnull)(VeridiumBOPSServerInfoData* _Nonnull)) onSuccess
                  onError:(errorBlock _Nonnull) onError;


/*!
 Retrieves the BOPS server information, with single completion block callback.

 @param completion the callback contaning the error if any occurred and the Bops server info.
 */
-(void) bopsGetServerInfoWithCompletion:(void (^ _Nonnull)(VeridiumBOPSServerInfoData * _Nullable, NSError* _Nullable error))completion;

/*!
 Check server connection by calling the /websec/test API and checking against specific network connection errors
 
 @param completion the callback contaning the error if any occurred.
 */
-(void) bopsTestServerWithCompletion:(void (^ _Nonnull)(NSError* _Nullable error))completion;


/*!
 Wrapper calling the BOPS **`/rest/enterprise/GetMembers`** endpoint
 
 @param onSuccess success callback (when this is called you can safely assume that the integrationDefinitions property contains the refreshed data)
 @param onError   error callback
 */
-(void) bopsRefreshIntegrations:(voidBlock _Nonnull)onSuccess
                        onError:(errorBlock _Nonnull)onError;


/*!
 Wrapper calling the BOPS **`/rest/enterprise/GetMembers`** endpoint, with single completion block callback.

 @param completion the callback contaning the error if any, `nil` otherwise (operation was successful).
 */
-(void) bopsRefreshIntegrationsWithCompletion:(void(^ _Nonnull)(NSError* _Nullable error))completion;


/*!
 Helper method reseting last update times, i.e for polling.
 */
-(void) resetLastUpdateTimestamps;


/*!
 @name Notifications Polling
 */

/*!
 Starts the polling for notifications mechanism.

 The polling is used as an alternative for receiving notification when the user opted out of push notifications
 
 @param interval                  the polling interval in seconds
 @param fireEvenWhenAPNSAvailable whether to fire it even when the pushes are on (could prove useful for cases when the pushes are slow)
 */
-(void) startPollingWithInterval:(NSTimeInterval)interval fireEvenWhenAPNSAvailable:(BOOL) fireEvenWhenAPNSAvailable;

/*!
 Stops the notifications polling
 */
-(void) stopPolling;

/*!
 Clears BOPS setup credential data (certificate, certificate password, public key, domain).
 */
-(void)clearBOPSCredentials;

/*!
 Server communication config update for certificates and pinning
 */
-(void)serverConfigUpdate:(NSString *)defaultCertificate
       defaultCertificatePassword:(NSString *)defaultCertificatePassword
       clientCertificate:(NSString *)clientCertificate
       clientCertificatePassword:(NSString *)clientCertificatePassword
      pinnedServerPublicKeyHashes:(NSArray<NSString*>*) pinnedServerPublicKeyHashes;

/*!
 Signal that server communication update was completed and normal calls can proceed
 */
-(void)serverConfigUpdateFinished;

/*!
 Returns true if local biometry change detection is enforced by server configuration
 */
-(BOOL)isLocalBiometryChangeDetectionEnabled;

/*!
    Split biometrics vector based on storage policy
*/
- (NSArray *)processVector:(NSArray<VeridiumBiometricFullVector*>*)vectors basedOnAuthType:(BOPSAuthenticatorType)authType;

/*!
 TODO: do not keep this in production release. for testing only
 */
//-(void)breakPinning;

@end
