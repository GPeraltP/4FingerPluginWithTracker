//
//  otpad.hpp
//  TestOTP
//
//  Created by Ciprian Caba on 29/03/16.
//  Copyright © 2016 HoyosLabs. All rights reserved.
//

#ifndef otpad_hpp
#define otpad_hpp

#include <stdio.h>

char* generateOTPAD(const char* seed, const unsigned char* salt);

#endif /* otpad_hpp */
