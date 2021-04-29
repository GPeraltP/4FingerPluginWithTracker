//
//  VeridiumBopsLocation.h
//  VeridiumBOPS
//
//  Created by Alex ILIE on 31/10/2018.
//  Copyright © 2018 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <VeridiumCore/VeridiumCore.h>

/*!
 Data class holding the VeridiumBOPSLocation data.
 */
@interface VeridiumBOPSLocation : NSObject

// CLLocation is needed since geocoordinates have greater precision than CLPlacemark
-(nonnull instancetype)initWithPlacemark:(nonnull CLPlacemark *)placemark location:(nonnull CLLocation*)location filterAttr:(nullable NSArray<NSString*>*) filterAttr;
// CLLocation is needed since geocoordinates have greater precision than CLPlacemark
-(nonnull instancetype)initWithPlacemark:(nonnull CLPlacemark *)placemark location:(nonnull CLLocation*)location;
-(nonnull instancetype)initWithError:(nonnull NSError *)error;

-(NSDictionary*) serialize;

/*!
 Accuracy
 */
@property (readonly) double accuracy;

/*!
 latitude
 */
@property (readonly) double latitude;

/*!
 longitude
 */
@property (readonly) double longitude;


/*!
 The country code
 */
@property (readonly) NSString* countryCode;

/*!
 The country code
 */
@property (readonly) NSString* countryName;

/*!
 The country code
 */
@property (readonly) NSString* postalCode;

/*!
 The country code
 */
@property (readonly) NSString* regionName;

/*!
 The country code
 */
@property (readonly) NSString* source;


/*!
 The district
 */
@property (readonly) NSString* district;

/*!
 The city
 */
@property (readonly) NSString* city;

/*!
 The street
 */
@property (readonly) NSString* street;

/*!
 The street number
 */
@property (readonly) NSString* streetNumber;


/*!
 Error code for location fail
 */
@property (readonly) NSInteger errorCode;

@end
