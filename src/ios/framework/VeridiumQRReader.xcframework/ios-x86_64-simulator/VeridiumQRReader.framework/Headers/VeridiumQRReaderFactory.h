//
//  VeridiumQRReaderFactory.h
//  VeridiumQRReader
//
//  Created by Veridium on 10/12/2018.
//  Copyright © 2018 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VeridiumQR.h"
#import "VeridiumQRMock.h"

@interface VeridiumQRReaderFactory : NSObject

+ (VeridiumQR *) getQrReader: (BOOL) isTesting;

@end

