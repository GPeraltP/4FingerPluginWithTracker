//
//  VeridiumBOPSBiometricInfoData.h
//  VeridiumBOPS
//
//  Created by razvan on 2/28/17.
//  Copyright © 2017 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VeridiumCore/VeridiumAbstractData.h>

/*!
 Data class for parsing the biometric info as part of the BOPS GetServerInfo endpoint response
 
 @see VeridiumBOPSServerInfoData
 */
@interface VeridiumBOPSBiometricInfoData : VeridiumAbstractData

/*!
 Biometric engine type (eg. FACE, 4F)
 */
@property (readonly, nonnull) NSString* type;

/*!
 Biometric engine version
 */
@property (readonly, nonnull) NSString* version;

/*!
 Biometric engine internal name (eg. FaceSDK, FFID)
 */
@property (readonly, nonnull) NSString* name;

@end
