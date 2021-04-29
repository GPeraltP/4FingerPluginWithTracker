//
//  VeridiumBOPSServerInfoData.h
//  VeridiumBOPS
//
//  Created by razvan on 2/28/17.
//  Copyright © 2017 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VeridiumCore/VeridiumAbstractData.h>
#import "VeridiumBOPSBiometricInfoData.h"

/*!
 Data class for parsing the response of the BOPS GetServerInfo endpoint
 */
@interface VeridiumBOPSServerInfoData : VeridiumAbstractData

/*!
 The device status (ACTIVATED, BLOCKED_BY_ADMIN, etc.)
 */
@property (readonly, nonnull) NSString* deviceStatus;

/*!
 The BOPS server app version
 */
@property (readonly, nonnull) NSString* appVersion;

/*!
 The BOPS server app build date
 */
@property (readonly, nonnull) NSString* appBuildDate;

/*!
 The BOPS server app version
 */
@property (readonly, nullable) NSArray<VeridiumBOPSBiometricInfoData*>* biometricInfo;



@end
