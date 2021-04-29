//
//  BOPSAuthenticationModeDefinitionData.h
//  VeridiumBOPS
//
//  Created by razvan on 8/9/16.
//  Copyright © 2016 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VeridiumBOPSParamDefinitionData.h"
#import <VeridiumCore/VeridiumAbstractData.h>

/*!
 Data class for holding the definition of an authentication mode (that belongs to a login defintion)
 
 @see VeridiumBOPSLoginDefinitionData
 */
@interface VeridiumBOPSAuthenticationModeDefinitionData : VeridiumAbstractData

/*!
 The mode title
 */
@property (readonly, nonnull) NSString* title;

/*!
 The mode type
 */
@property (readonly, nonnull) NSString* type;

/*!
 The mode version
 */
@property (readonly, nonnull) NSString* version;

/*!
 The params definitons array (VeridiumBOPSParamDefinitionData)
 */
@property (readonly, nonnull) NSArray<VeridiumBOPSParamDefinitionData*>* parameters;

@end
