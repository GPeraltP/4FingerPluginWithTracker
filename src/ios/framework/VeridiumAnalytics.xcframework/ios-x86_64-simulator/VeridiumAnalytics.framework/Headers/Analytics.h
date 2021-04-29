//
//  Analytics.h
//  VeridiumAnalytics
//
//  Created by Lewis Carney on 08/08/2017.
//  Copyright © 2017 veridium. All rights reserved.
//


#import <UIKit/UIKit.h>

// Levels of verbosity. Set a level using "analyticsCurrentVerbosity"
// Messages wiuth Levels below this are not tracked
typedef enum analyticsVerbosity
{
    VERBOSE,
    DDEBUG,
    INFO,
    ERROR
} Verbosity;

/* Label messages with components. You can add to the bottom of this list
   Converted to a string in Analytics.m
 */
typedef enum analyticsComponent {
  FOURF,
  FOURF_EXP,
  LUXAND_FACE,
  VERID_FACE,
  NATIVE_BIO,
  SERVER,
  CORE,
  UBA
} Component;

extern NSString * const ComponentType_toString[]; // convert component enum to string ID

/*
 Categories of message
 */
typedef enum analyticsCategory
{
  SETTINGS, // settings related
  CONFIG,   // set configurations
  SEQUENCE, // program flow
  LICENCE,  // Licence related
  CAPTURE,   // Sensor capture
  AUTH,     // related to authentication
  ENROL,    // related to enrollement
  LIVENESS,
  
  // Legit Failures
  GEN_FAIL,       // general failure
  CAPTURE_FAIL,
  AUTH_FAIL,
  ENROL_FAIL,
  LIVENESS_FAIL,
  LICENCE_FAIL,
  
  // Errors. Things that should not happen
  GEN_ERROR,
  CAPTURE_ERROR,
  AUTH_ERROR,
  ENROL_ERROR,
  LIVENESS_ERROR
} Category;

typedef void(^voidBlock)(void);

extern NSString * const CategoryType_toString[];  // Convert category enum to string

@interface Analytics : NSObject

+siAnalytics;

+(NSString *) NSStringFromVerbosity:(Verbosity) verbosity;

+(void)track:(Verbosity)verbosityLevel andComponent:(Component)component andCategory:(Category)category andEvent:(NSString *)event;

+(void)v:(Component)component andCategory:(Category)category andEvent:(NSString *)event;     // verbose shortcut

+(void)d:(Component)component andCategory:(Category)category andEvent:(NSString *)event;     // debug shortcut

+(void)i:(Component)component andCategory:(Category)category andEvent:(NSString *)event;     // info shortcut

+(void)e:(Component)component andCategory:(Category)category andEvent:(NSString *)event;     // error shortcut

+(void)sendAnalyticsDataWithVerbosity:(Verbosity) verbosityLevel andData:(NSData *) data andTag:(NSString*) tag andMessage:(NSString*) message;

+(void)provideServerCredentialsWithServerID:(NSString*) serverID andPassword:(NSString*) serverPassword;

+(void)logAnalyticsFileData:(Verbosity) verbosityLevel andTag:(NSString*) tag andMessage:(NSString*) message;

+(void)sendAnalyticsEvents:(Verbosity)verbosityLevel andCategoryName:(NSString *)category andEventName:(NSString *)event;

+(void)forceFilesToBeSentToServerOnComplete:(voidBlock)completionBlock withViewController:(UIViewController*) controller;

@end

