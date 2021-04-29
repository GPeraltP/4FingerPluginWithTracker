//
//  VeridiumBopsLoginDefMinimulRequirements.h
//  VeridiumBOPS
//
//  Created by Alex ILIE on 21/05/2019.
//  Copyright © 2019 Veridium IP Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VeridiumCore/VeridiumAbstractData.h>

/*!
 Data class holding VeridiumBOPSRegistrationModeDefinitionData data.
 */
@interface VeridiumBOPSLoginDefMinimumRequirements : VeridiumAbstractData

/*!
 iOS minimum required version
 */
@property (readonly, nullable) NSString* iOS;

/*!
 Android minimum required version
 */
@property (readonly, nullable) NSString* android;


@end
