//
//  Constants.h
//  VeridiumVFaceBiometrics
//
//  Created by Lewis Carney on 18/07/2018.
//  Copyright © 2018 veridium. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#import <Foundation/Foundation.h>
#import <VeridiumCore/VeridiumCore.h>

#define kVeridiumBiometricEngineNameVFace @"VFACE"

@interface VeridiumVFaceLicenseStatus : VeridiumLicenseStatus

@end

// MARK: - Error definitions

FOUNDATION_EXPORT NSString *const _Nonnull VeridiumVFaceBiometricsErrorDomain;

typedef NS_ERROR_ENUM(VeridiumVFaceBiometricsErrorDomain, VeridiumVFaceBiometricsLicenseError) {
    VeridiumVFaceBiometricsLicenseErrorLicenseExpired = -1,
    VeridiumVFaceBiometricsLicenseErrorDecodeFailed = -2,
    VeridiumVFaceBiometricsLicenseErrorVersionMismatch = -3,
    VeridiumVFaceBiometricsLicenseErrorOther = -4
};

typedef NS_ERROR_ENUM(VeridiumVFaceBiometricsErrorDomain, VeridiumVFaceBiometricsAuthenticationError) {
    VeridiumVFaceBiometricsAuthenticationErrorLivenessFailed = 1047,
    VeridiumVFaceBiometricsAuthenticationErrorMismatch = 1047
};

#endif /* Constants_h */
