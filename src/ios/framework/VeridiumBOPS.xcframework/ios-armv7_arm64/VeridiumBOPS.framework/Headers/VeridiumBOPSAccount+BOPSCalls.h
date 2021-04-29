//
//  VeridiumBOPSAccount+BOPSCalls.h
//  VeridiumBOPS
//
//  Created by razvan on 8/9/16.
//  Copyright © 2016 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VeridiumBOPSAccount.h"
#import <VeridiumCore/VeridiumProfileData.h>
#import "VeridiumBOPSSessionStatusResponseData.h"
#import "VeridiumBOPSRegisterSessionResponseData.h"
#import "VeridiumBOPSSessionData.h"
#import "VeridiumBOPSAccount+Authentication.h"
#import "VeridiumBOPSLocation.h"
#import "VeridiumBOPSAuthenticationResponse.h"
@import VeridiumCore;

/*!
  VeridiumBOPSAccount addition which wrapps all BOPS calls.
 */
@interface VeridiumBOPSAccount (BOPSCalls)

/*!
 Removes the entire account from server (all devices tied to this account will become unusable) and delete all the locally stored data
 
 @param onSuccess    onSuccess success callback
 @param onError      onError error callback (receiving BOPSError)
 */
-(void) bopsRemoveAccount:(voidBlock _Nonnull) onSuccess
                  onError:(errorBlock _Nonnull) onError;

/*!
 Removes the entire account from server (all devices tied to this account will become unusable) and delete all the locally stored data, using one block callback.

 @param completion the callback contaning the error if any occurred.
 */
-(void) bopsRemoveAccountWithCompletion:(void(^ _Nonnull)(NSError* _Nullable)) completion;

/*!
 Unlocks the BOPS account.
 An account is considered locked if it has no client certificate password.
 
 The client certificate password is kept in memory only and once the app closes the password is gone. Therefore when the app starts all registered BOPS accounts are by default locked.
 
 This method calls the BOPS 'unlockClient' endpoint using OTP and handles the outcome.
 
 The `enablePushNotifications` param is intepreted as a "wish" because if the app cannot receive pushes and you pass `true` as argument, still `false` is gonna be sent to server.
 
 So as a rule if you have a push-enabled app you shoul hardcode this to to `true` and you should call with `false` only when you definitely do not want pushes enabled even if the app is capable (e.g. you have a setting for enabling/disabling pushes and your app's user set it to "disable")
 
 @param enablePushNotifications   pass `true` if you wish to enable APNS push notifications on server for this account or `false` otherwise
 @param onSuccess                 onSuccess success callback
 @param onError                   onError error callback (receiving BOPSError)
 
 */
-(void) bopsUnlock:(BOOL)enablePushNotifications
         onSuccess:(voidBlock _Nonnull)onSuccess
           onError:(errorBlock _Nonnull)onError;
/*!
 Deletes a registered profile
 
 @param profileId   the profile id
 @param onSuccess   onSuccess success callback
 @param onError     onError error callback (receiving BOPSError)
 */
-(void) bopsDeleteProfile:(NSString* _Nonnull) profileId
                onSuccess:(voidBlock _Nonnull) onSuccess
                  onError:(errorBlock _Nonnull) onError;

/*!
 Deletes a registered profile

 @param profileId   the profile id
 @param completion  the callback contaning the error if any occurred.
 */
-(void) bopsDeleteProfile:(NSString* _Nonnull) profileId
           withCompletion:(void(^ _Nonnull)(NSError* _Nullable error)) completion;

/*!
 Initiates a biometric authentication session from client-side, using one block callback.

 @param profileId     the profile id
 @param sessionType   the session type (dependens on the integration)
 @param extraValues   arbitrary data sent to the server for the session (integration specific)
 @param completion    the callback contaning the error if any occurred and the updated profile.
 */
-(void) bopsStartAuthenticationSessionForProfile:(NSString* _Nonnull) profileId
                                     sessionType:(NSString* _Nonnull) sessionType
                                         context:(NSDictionary* _Nullable) context
                                     extraValues:(NSDictionary* _Nullable) extraValues
                                  withCompletion:(void(^ _Nullable)(VeridiumBOPSSessionStatusResponseData* _Nullable sessionStatusResponseData, NSError* _Nullable error)) completion;

/*!
  Registers a session for a session opportunity, using one block callback.

 @param sessionType   the session type (integration dependent)
 @param sessionId     the session opportunity id
 @param profileId     the profile id
 @param extraValues   arbitrary data sent to the server for the session (integration specific)
 @param completion    the callback contaning the error if any occurred and the BOPS session data.
 */
-(void) bopsRegisterSession:(NSString* _Nonnull) sessionType
                  sessionId:(NSString* _Nonnull) sessionId
                  profileId:(NSString* _Nonnull) profileId
                    context:(NSDictionary* _Nullable) context
                extraValues:(NSDictionary* _Nullable) extraValues
             withCompletion:(void(^ _Nullable)(VeridiumBOPSSessionData* _Nullable sessionData, NSError* _Nullable error)) completion;



/*!
  Gets a Bops session for a specific session id.

 @param sessionId   the session id.
 @param onSuccess   onSuccess callback with BOPS session data.
 @param onError     onError error callback (receiving BOPSError)
 */
-(void) bopsGetSession:(NSString* _Nonnull)sessionId
             onSuccess:(void(^ _Nonnull)(VeridiumBOPSSessionData* _Nonnull)) onSuccess
               onError:(errorBlock _Nonnull) onError;


/*!
 Gets a Bops session for a specific session id, using one block callback.

 @param sessionId   the session id.
 @param completion  the callback contaning the error if any occurred and the BOPS session data.
 */
-(void) bopsGetSession:(NSString* _Nonnull)sessionId
        withCompletion:(void(^ _Nullable)(VeridiumBOPSSessionData* _Nullable, NSError* _Nullable error)) completion;


/*!
 Longpolls for the active session status

 @param sessionId the session id
 @param onSuccess onSuccess callback with session status
 @param onError onError error callback (receiving BOPSError)
 */
-(NSURLSessionTask* _Nonnull) bopsGetSessionStatusAsync:(NSString* _Nonnull)sessionId onSuccess:(void(^ _Nonnull)(NSDictionary * _Nullable status)) onSuccess onError:(errorBlock _Nonnull) onError;


/*!
 Longpolls fo the active session status

 @param sessionId the session id
 @param completion the callback contaning the error if any occurred and the BOPS session status.
*/
-(NSURLSessionTask* _Nonnull)bopsGetSessionStatusAsync:(NSString * _Nonnull)sessionId withCompletion:(void (^ _Nullable)(NSDictionary * _Nullable sessionStatus, NSError * _Nullable error))completion;

/*!
 Retrieves the public biometric vector halfs from the server
 
 @param tags        array containing the tags of the private vector halfs (stored on the device)
 @param onSuccess   onSuccess callback wich receives a dictionary with NSString:VeridiumBiometricPublicVector pairs (`engine name`:`vector`)
 @param onError     onError error callback (receiving BOPSError)
 */
-(void) bopsGetBiometrics:(NSArray<NSString*>* _Nonnull) tags
                onSuccess:(void(^ _Nonnull)(NSDictionary<NSString*,VeridiumBiometricPublicVector*>* _Nonnull vectors)) onSuccess
                  onError:(errorBlock _Nonnull) onError;


/*!
 Retrieves the public biometric vector halfs from the server, using one block callback.

 @param tags        array containing the tags of the private vector halfs (stored on the device)
 @param completion  the callback contaning the error if any occurred and the VeridiumBiometricPublicVector.
 */
-(void) bopsGetBiometrics:(NSArray<NSString*>* _Nonnull) tags
           withCompletion:(void(^ _Nullable)(NSDictionary<NSString*,VeridiumBiometricPublicVector*>* _Nonnull vectors, NSError* _Nullable error)) completion;

/*!
 Updates the public biometric vector halfs on server
 
 @param newVectors  array with VeridiumBiometricVectorWithMatchingPairTag instances (which pair a public vector half with its private counterpart tag)
 @param onSuccess   onSuccess success callback
 @param onError     onError error callback (receiving BOPSError)
 */
-(void) bopsSetBiometrics:(NSArray<VeridiumBiometricVector*>* _Nonnull) newVectors
                onSuccess:(voidBlock _Nonnull) onSuccess
                  onError:(errorBlock _Nonnull) onError;

/*!
 Updates the public biometric vector halfs on server, using one block callback.

 @param newVectors  array with VeridiumBiometricVectorWithMatchingPairTag instances (which pair a public vector half with its private counterpart tag
 @param completion  the callback contaning the error if any occurred.
 */
-(void)bopsSetBiometrics:(NSArray<VeridiumBiometricVector*>* _Nonnull)newVectors
          withCompletion:(void (^_Nonnull)(NSError * _Nullable error))completion;


/*!
 Performs a biometric match on server
 
 @param sessionId     the session id of the session in whose context will the authentication take place
 @param currentVector the authentication vector (the one to be verified)
 @param enrollVector  the enrolled vector (the private half)
 @param onSuccess     onSuccess callback which receives an update of the vector to be stored on the client side (the caller of this method must handle the storing inside this success callback)
 @param onFail        onFail fail callback
 @param onError       onError error callback (receiving BOPSError)
 */
-(void) bopsMatch:(NSString* _Nonnull)sessionId
    currentVector:(VeridiumBiometricVector* _Nonnull) currentVector
   enrolledVector:(VeridiumBiometricVector* _Nullable) enrollVector
        onSuccess:(void(^ _Nonnull)(VeridiumBiometricPrivateVector* _Nullable updatedPrivateVector)) onSuccess
           onFail:(voidBlock _Nonnull) onFail
          onError:(errorBlock _Nonnull) onError;


/*!
 Performs a biometric match on server, using one block callback.
 
 @param sessionId       the session id of the session in whose context will the authentication take place
 @param currentVector   the authentication vector (the one to be verified)
 @param enrollVector    the enrolled vector (the private half)
 @param completion      the callback contaning the error if any occurred and the updated VeridiumBiometricPrivateVector and a BOOL that indicates if the operation was successful or not.
 */
-(void) bopsMatch:(NSString* _Nonnull)sessionId
    currentVector:(VeridiumBiometricVector* _Nonnull) currentVector
   enrolledVector:(VeridiumBiometricVector* _Nullable) enrollVector
   withCompletion:(void(^ _Nullable)(BOOL succeeded, VeridiumBiometricPrivateVector* _Nullable updatedPrivateVector, NSError* _Nullable error)) completion;


/*!
 Sends the aggregated authentication results & transaction signature of an authentication session to the server to complete it, using one block callback.

 @param sessionId           the session id
 @param authOverallResult   array of VeridiumBOPSBiometricData with the authentication outcome for each biometric authentication
 @param detailedResults     array with the transaction signature data: {"authenticator": Authenticator identifier (eg. FACE, 4F), "signature": Signature Base64 encoded}
 @param signatures          array with the transaction signature data: {"authenticator": Authenticator identifier (eg. FACE, 4F), "signature": Signature Base64 encoded}
 @param context             context where the authentication took place
 @param loginData           the profile's encrypted loginData (used by the server to authenticate in the external system
 @param extraValues         arbitrary data sent to the server for the session (integration specific)
 @param completion          the callback contaning the error if any occurred and the status server response.
 */
-(void) bopsSendAuthenticationResponseForSessionId:(NSString* _Nonnull) sessionId
                                 authOverallResult:(VeridiumAuthResult) authOverallResult
                                   detailedResults:(NSArray<VeridiumEngineAuthResult*>* _Nonnull) detailedResults
                                        signatures:(NSArray<VeridiumAuthSignatureData*>* _Nullable) signatures
                                           context:(NSDictionary* _Nullable) context
                         profileEncryptedLoginData:(NSString* _Nullable) loginData
                                     behaviourData:(NSDictionary* _Nullable) behaviourData
                                       extraValues:(NSDictionary* _Nullable) extraValues
                                    withCompletion:(void(^ _Nullable)(VeridiumBOPSAuthenticationResponse* _Nullable status, NSError* _Nullable error)) completion;



/*!
 Method used for multi-step enrollment profiles.
 
 @param profileId   the profile id
 @param params      the params (business integration specific)
 @param onSuccess   the newly updated profile
 @param onError     error (receiving BOPSError)
 */
-(void) bopsAdvanceEnrollmentForProfileId:(NSString* _Nonnull) profileId
                                   params:(NSDictionary* _Nonnull) params
                                onSuccess:(void(^ _Nonnull)(VeridiumProfileData* _Nullable profileData)) onSuccess
                                  onError:(errorBlock _Nullable)onError;


/*!
 Method used for multi-step enrollment profiles, using one block callback.

 @param profileId   the profile id
 @param params      the params (business integration specific)
 @param completion  the callback contaning the error if any occurred and the newly updated profile.
 */
-(void) bopsAdvanceEnrollmentForProfileId:(NSString* _Nonnull) profileId
                                   params:(NSDictionary* _Nonnull) params
                           withCompletion:(void(^ _Nonnull)(VeridiumProfileData* _Nullable profileData, NSError* _Nullable error)) completion;

/*!
 Method used for restarting a multi-step enrollment step, using one callback

@param profileId    the profile id
@param completion   the callback contaning the newly updated profile and the error if any occured
 */
-(void) bopsRestartEnrollmentStepForProfileId:(NSString * _Nonnull) profileId
                               withCompletion:(void(^ _Nonnull)(VeridiumProfileData* _Nullable profileData, NSError* _Nullable error)) completion;

/*!
 Method used for restarting a multi-step enrollment step.

 @param profileId   the profileId
 @param onSuccess   the callback contaning the newly updated profile
 @param onError     the callback contaning the error if any occured
 */

-(void) bopsRestartEnrollmentStepForProfileId:(NSString * _Nonnull) profileId
                                    onSuccess:(void(^ _Nonnull)(VeridiumProfileData* _Nullable profileData)) onSuccess
                                      onError:(errorBlock _Nonnull) onError;

/*!
 Method used for refreshing bussiness integrations. When forced will get all bussiness integrations from server.

 @param forceUpdate  whether the operation is being forced or not
 @param completion   the callback contaning the error if any occured
 */
-(void) bopsRefreshIntegrationsForce:(BOOL)forceUpdate
                      withCompletion:(void (^_Nonnull)(NSError * _Nullable)) completion;


/*!
 Method used to get all VeridiumID available licenses

 @param completion the fetched licenses if any and the error if any occured.
 */
-(void) bopsGetLicenses:(BOOL)forced completion:(void(^_Nonnull)(NSArray<VeridiumLicenseData*>* _Nullable licenses, NSError* _Nullable error))completion;

@end
