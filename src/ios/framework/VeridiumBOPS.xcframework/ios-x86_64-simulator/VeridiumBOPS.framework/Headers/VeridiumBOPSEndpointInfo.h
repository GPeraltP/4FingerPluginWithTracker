//
//  BOPSEndpointConfig.h
//  VeridiumBOPS
//
//  Created by razvan on 8/9/16.
//  Copyright © 2016 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
  VeridiumBops endpoint info data class.
 */
@interface VeridiumBOPSEndpointInfo : NSObject

/*!
 The enpoint's URL.
 */
@property (readonly) NSString* URL;

/*!
 The endpoint's content-type.
 */
@property (readonly) NSString* contentType;

/*!
 HTTP request-respone timeout interval.
 */
@property (readonly) NSTimeInterval timeoutInterval;

/*!
 Designated class initializer. The timeout interval is set by default to 30 seconds.

 @param url           the URL
 @param contentType   the content-type
 @return              initialized class
 */
-(instancetype)init:(NSString*)url contentType:(NSString*)contentType;

/*!
 Class initializer.

 @param url               the URL
 @param contentType       the content-type
 @param timeoutInterval   the timeout interval in seconds
 @return                  initialized class
 */
-(instancetype)init:(NSString*)url contentType:(NSString*)contentType timeoutInterval:(NSTimeInterval) timeoutInterval;

+ (NSArray*) setupServerMethods;

/*!
 URL classifier for server setup methods
 
 @return                  true if the method is a server setup methods (UnlockClient, GetLicense, RenewClientCertificate)
 */
-(BOOL)isServerSetupMethod;


@end
