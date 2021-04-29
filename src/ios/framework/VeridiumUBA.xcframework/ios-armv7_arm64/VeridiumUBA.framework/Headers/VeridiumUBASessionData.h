//
//  VeridiumUBASessionData.h
//  VeridiumUBA
//
//  Created by Paul Paul on 10/23/17.
//  Copyright © 2017 VeridiumID. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VeridiumUBASessionData : NSObject

+(instancetype _Nonnull)newFromDictionary:(NSDictionary* _Nonnull)dataDict;

@property (nonatomic) NSDictionary<NSString*,NSArray*>* _Nonnull attitudeData;
@property (nonatomic) NSDictionary<NSString*,NSArray*>* _Nonnull rotationRate;
@property (nonatomic) NSDictionary<NSString*,NSArray*>* _Nonnull gravity;
@property (nonatomic) NSDictionary<NSString*,NSArray*>* _Nonnull acceleration;
@property (nonatomic) NSDictionary<NSString*,NSArray*>* _Nonnull linearAcceleration;
@property (nonatomic) NSDictionary<NSString*,NSArray*>* _Nonnull magneticField;
@property (nonatomic) NSString* _Nonnull sessionId;
@property (nonatomic) NSDictionary* _Nonnull eventList;

@property (readonly)  NSDictionary* _Nonnull dict;


@end

typedef void (^_Nullable ubaDataBlock)(VeridiumUBASessionData* _Nullable, NSError* _Nullable error);
