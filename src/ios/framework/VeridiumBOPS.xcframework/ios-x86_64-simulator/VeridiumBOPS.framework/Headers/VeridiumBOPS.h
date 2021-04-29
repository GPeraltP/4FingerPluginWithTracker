//
//  VeridiumBOPS.h
//  VeridiumBOPS
//
//  Created by razvan on 8/8/16.
//  Copyright © 2016 Veridium. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for VeridiumBOPS.
FOUNDATION_EXPORT double VeridiumBOPSVersionNumber;

//! Project version string for VeridiumBOPS.
FOUNDATION_EXPORT const unsigned char VeridiumBOPSVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <VeridiumBOPS/PublicHeader.h>


#import "VeridiumBOPSAccount.h"
#import "VeridiumBOPSAccount+BOPSCalls.h"
#import "VeridiumBOPSAccount+Authentication.h"
#import "VeridiumSDK+BOPS.h"
#import "VeridiumBOPSAccountService.h"
#import "VeridiumBOPSRegistrationConfig.h"
#import "VeridiumBOPSSessionAuthConfig.h"
#import "VeridiumBOPSEndpointInfo.h"

#import <VeridiumCore/VeridiumAbstractData.h>
#import "VeridiumBOPSLoginDefinitionData.h"
#import "VeridiumBOPSIntegrationDefinitionData.h"
#import <VeridiumCore/VeridiumProfileData.h>
#import "VeridiumBOPSFieldDefinitionData.h"
#import "VeridiumBOPSAuthenticationModeDefinitionData.h"
#import "VeridiumBOPSRegistrationModeDefinitionData.h"
#import "VeridiumBOPSAccountData.h"

#import "VeridiumBOPSSessionStatusResponseData.h"
#import "VeridiumBOPSIdentityTokenPublicData.h"
#import "VeridiumBOPSBiometricData.h"
#import "VeridiumBOPSSessionData.h"
#import "VeridiumBOPSErrors.h"
#import "VeridiumBOPSLocation.h"
#import "VeridiumBOPSAuthenticationResponse.h"
#import "VeridiumBOPSUbaOutput.h"
