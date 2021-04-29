//
//  VeridiumBOPSSessionContext.h
//  VeridiumBOPS
//
//  Created by Alex ILIE on 11/11/2019.
//  Copyright © 2019 Veridium IP Ltd. All rights reserved.
//

#import <VeridiumCore/VeridiumAbstractData.h>

/*!
 Data class holding the VeridiumBOPSSessionContext data.
 */
@interface VeridiumBOPSSessionContext : VeridiumAbstractData

/*!
 App name
 */
@property (readonly, nullable) NSString* appName;

/*!
 App version
 */
@property (readonly, nullable) NSString* appVersion;

/*!
 Device name
 */
@property (readonly, nullable) NSString* deviceName;

/*!
 Location city
 */
@property (readonly, nullable) NSString* cityName;

/*!
 Location country
*/
@property (readonly, nullable) NSString* countryName;

/*!
 Location street
 */
@property (readonly, nullable) NSString* street;

/*!
 Location street number
 */
@property (readonly, nullable) NSString* streetNumber;

/*!
 IP
 */
@property (readonly, nullable) NSString* ip;

/*!
 Service identifier
 */
@property (readonly, nullable) NSString* serviceIdentifier;

/*!
 OS version
 */
@property (readonly, nullable) NSString* osVersion;

/*!
 OS name
 */
@property (readonly, nullable) NSString* osName;

@end
