//
//  VeridiumBOPSPairingData.h
//  VeridiumBOPS
//
//  Created by Catalin Stoica on 08/11/2017.
//  Copyright © 2017 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VeridiumCore/VeridiumAbstractData.h>
#import "VeridiumBOPSIntegrationDefinitionData.h"

/*!
 Data class holding VeridiumBOPSPairingData data.
 */
@interface VeridiumBOPSPairingData : VeridiumAbstractData

/*!
 Server name in human readable format
 */
@property (readonly, nonnull) NSString *serverName;

/*!
 The server API product version.
 */
@property (readonly, nonnull) NSString *productVersion;

/*!
 A Dictionary containig all the auth methods that are received from the server
 */
@property (readonly, nonnull) NSDictionary *authenticationMethods;

/*!
 The base64 encoded default certificate.
 */
@property (readonly, nonnull) NSString* defaultCertificate;

/*!
 The certificate password in plain text.
 */
@property (readonly, nonnull) NSString* defaultCertificatePassword;

/*!
 The base64 encoded server public key.
 */
@property (nonnull) NSArray<NSString*>* pinnedServerPublicKeyHashes;

/*!
 The websec url.
 */
@property (readonly, nonnull) NSString* url;

/*!
 Pairing information
 */
@property (readonly, nullable) NSString* pairingToken;

/*!
 The intergation definition data.
 */
@property (readonly, nonnull) VeridiumBOPSIntegrationDefinitionData* integration;

/*!
 System settings
 */
@property (readonly, nullable) NSDictionary* systemSettings;

@end
