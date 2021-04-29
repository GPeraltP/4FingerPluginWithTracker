//
//  VeridiumBOPSFieldDefinitionData.h
//  VeridiumBOPS
//
//  Created by razvan on 8/9/16.
//  Copyright © 2016 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VeridiumCore/VeridiumAbstractData.h>

/*!
 Data class for holding the field definition meta data
 @see VeridiumBOPSIntegrationDefinitionData
 */
@interface VeridiumBOPSFieldDefinitionData : VeridiumAbstractData

/*!
 The field title
 */
@property (readonly, nonnull) NSString* title;

/*!
 The field name
 */
@property (readonly, nonnull) NSString* name;

/*!
 The control type - integration dependent (e.g. text, password, multivalue)
 */
@property (readonly, nonnull) NSString* controlType;

/*!
 Whether the field is required or optional
 */
@property (readonly) BOOL required;

@end
