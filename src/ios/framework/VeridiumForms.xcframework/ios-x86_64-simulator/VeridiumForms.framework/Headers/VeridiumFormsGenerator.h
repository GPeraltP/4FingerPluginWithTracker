//
//  VeridiumFormsGenerator.h
//  VeridiumForms
//
//  Created by Catalin Stoica on 18/10/2017.
//  Copyright © 2017 VeridiumID. All rights reserved.
//

@import VeridiumCore;
@import VeridiumBOPS;
#import <Foundation/Foundation.h>
#import "XLForm.h"


@interface VeridiumFormsGenerator: NSObject

FOUNDATION_EXPORT NSString *const _Nonnull VeridiumFormsErrorDomain;

/*!
 @enum VeridumFormType
 @abstract constants for the VeridiumForm types.

 - VeridiumFormTypePlaceholderDescription: Form type with the form description in placeholder.
 - VeridiumFormTypeLabelDescription: Form type with the form description in the left side of the form.
 */

typedef NS_ENUM(NSUInteger, VeridiumFormType) {
  VeridiumFormTypePlaceholderDescription = 0,
  VeridiumFormTypeLabelDescription
};

/*!
 @enum VeridiumFormsErrorCode
 @abstract Constants for the VeridiumForms errors.
 
 - VeridiumFormsUnknownRegistrationModeError: registration modes for a given profile status were not found error.
 - VeridiumFormsMissingRegistrationModeError: registration modes missing error.
 */
typedef NS_ENUM(NSInteger, VeridiumFormsErrorCode) {
  VeridiumFormsUnknownRegistrationModeError = -1,
  VeridiumFormsMissingRegistrationModeError
};


/*!
 The registration modes used for the form generating.
 */
@property(readonly) NSArray<VeridiumBOPSRegistrationModeDefinitionData *> * _Nonnull registrationModes;

/*!
 The desired form type used when generating the forms.
 */
@property(readwrite) VeridiumFormType type;

/*!
 Generates a XLFormDescriptor based on the registration modes provided and the form type specified at initialization.

 @param status            the profile status.
 @param sectionName       the section title, pass 'nil' if you don't require a section title.
 @param registrationModes the registration modes.
 @param error             the errro.
 @return                  XLFormDescriptor.
 */
-(XLFormDescriptor * _Nullable)formForProfileStatus:(NSString* _Nullable)status
                                    withSectionName:(NSString* _Nullable)sectionName
                               andRegistrationModes:(NSArray<VeridiumBOPSRegistrationModeDefinitionData *> * _Nonnull)registrationModes
                                              error:(NSError* _Nullable* _Nullable) error;


/*!
 Generates a XLFormDescriptor based on the registration modes and form type specified when initialized.

 @param profileStastus  the profile status.
 @param sectionName     the section title, pass 'nil' if you don't require a section title.
 @param error           the errro if any.
 @return                XLFormDescriptor.
 */
-(XLFormDescriptor * _Nullable)formForProfileStatus:(NSString* _Nullable)profileStastus
                                    withSectionName:(NSString* _Nullable)sectionName
                                              error:(NSError* _Nullable* _Nullable) error;

/*!
 Checks if a form can be generated for a give profile status, e.g the provided status is a valid input status from the registration modes.

 @param status  the profile status.
 @return        YES if the provided status is a valid input status, NO otherwise.
 */
-(BOOL)hasNextEnrollmentStepForStatus:(NSString* _Nonnull) status;

/*!
 Class initializer

 @param formType          the form type.
 @param registrationModes the registration modes.
 @return                  VeridiumFormsGenerator instance.
 */
-(instancetype _Nullable)initWithType:(VeridiumFormType)formType andRegistrationModes:(NSArray<VeridiumBOPSRegistrationModeDefinitionData *> * _Nonnull)registrationModes;

/*!
 Converts the bops field descriptor to the propper XLFormRowDescriptorType

 @param bopsDescriptor  the bops field descriptor
 @return                XLFormRowDescriptorType
 */
-(NSString* _Nonnull)convertBopsRowDescriptorToXLDescritor:(NSString* _Nonnull)bopsDescriptor;

/*!
 Checks if the status is found in the available statuses list

 @param status    the status
 @param statuses  the available bops statuses
 @return          YES if the status is valid, NO otherwise
 */
-(BOOL)statusMatches:(NSString * _Nullable)status inStatuses:(NSArray<NSString *> * _Nonnull)statuses;

@end
