//
//  VeridiumSDK+BOPS.h
//  VeridiumBOPS
//
//  Created by razvan on 8/9/16.
//  Copyright © 2016 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>
@import VeridiumCore;
#import "VeridiumBOPSAccountService.h"
#import "VeridiumBOPSAccount.h"
#import "VeridiumBOPSServerInfoData.h"
#import "VeridiumBOPSPairingData.h"


@interface VeridiumSDK (BOPS)

/*!
 The setup method that creates and configures an account service bound to the provided BOPS domain root.
 
 Can be accessed later via the `[VeridiumSDK BOPSAccountServiceForURL:]` (or `[VeridiumSDK defaultBOPSAccountService]` for single bops scenarios)

 @param pairingData     The  'VeridiumBOPSPairingData' instance including server related info to be used for setting up 'VeridiumBOPSAccountService'
 @return true if successful, false otherwise
 */
- (BOOL)setupBOPSAccountServiceWithPairingData:(nonnull VeridiumBOPSPairingData *)pairingData;

/*!
 Multiton access to an account service bound to an BOPS domain root (previously setup)

 @param bopsDomainRoot the BOPS domain root provided at setup
 @return the configured account service or null if no account service has been setup for the provided BOPS domain root
 */
-(nullable VeridiumBOPSAccountService*) BOPSAccountServiceForURL:(nonnull NSString*) bopsDomainRoot;

/*!
 This method calls gets the BOPS pairing info from a provided token

 @param tokenBase64String   the integration base64 encoded token
 @param completion          the callback containing the pairing info, and error if any occured
 */
-(void) getBOPSPairingInfoWithToken:(nonnull NSString*) tokenBase64String withCompletion:(void(^ _Nonnull)(VeridiumBOPSPairingData* _Nullable pairingData, NSError* _Nullable error))completion;

/*!
 Returns the configured BOPS account services
 */
@property (nonnull, readonly)  NSArray<NSString*>* configuredBOPSAccountServices;

@end
