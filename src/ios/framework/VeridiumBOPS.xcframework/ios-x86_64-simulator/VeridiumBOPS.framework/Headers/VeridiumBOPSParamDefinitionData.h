//
//  VeridiumBOPSParamDefinitionData.h
//  VeridiumBOPS
//
//  Created by razvan on 8/9/16.
//  Copyright © 2016 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VeridiumCore/VeridiumAbstractData.h>

/*!
  Data class holding the VeridiumBOPSParamDefinitionData data.
 */
@interface VeridiumBOPSParamDefinitionData : VeridiumAbstractData

/*!
 Param title
 */
@property (readonly, nonnull) NSString* title;

/*!
 Param name
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

/*!
 The field default value
 */
@property (readonly, nullable) NSString* value;

@end
