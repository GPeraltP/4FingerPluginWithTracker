//
//  VeridiumTOTPEnroller.h
//  VeridiumCore
//
//  Created by Vlad Hudea on 23/03/2020.
//  Copyright © 2020 Veridium IP Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VeridiumTOTPEnrollConfig.h"
#import "VeridiumUtils.h"
#import "VeridiumBiometricsProtocols.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 Block that receives a pin (used by enrollers)
 @param pin the pin
 */
typedef void(^totpPinBlock)(NSString * _Nonnull pin);

@protocol TOTPUIDelegate <NSObject>

- (void)setSuccessClosure:(totpPinBlock _Nonnull)success;
- (void)setCancelClosure:(voidBlock _Nonnull)cancel;

@end

@protocol TOTPUIConfigDelegate <NSObject>

- (void)setTotpTitle:(NSString *)title;
- (void)setTotpPageDescription:(NSString *)description;
- (void)setTotpPinLength:(NSUInteger)pinLength;
- (void)setTotpPinType:(NSString *)pinType;

@end


@interface VeridiumTOTPEnroller : NSObject <VeridiumBioEnroller>

@property (nonatomic, readonly) NSString *engineName;
@property UIViewController<TOTPUIDelegate, TOTPUIConfigDelegate> *uiDelegate;
@property (nonatomic) VeridiumTOTPEnrollConfig *config;

- (instancetype)initWithConfig:(VeridiumTOTPEnrollConfig *)config;

- (void)configUI:(NSDictionary *)uiSettings;

- (void)enroll:(totpPinBlock _Nonnull)onSuccess
          fail:(voidBlock _Nonnull)failCompletion
        cancel:(voidBlock _Nonnull)cancelCompletion
         error:(errorBlock _Nonnull)onError;

@end

NS_ASSUME_NONNULL_END
