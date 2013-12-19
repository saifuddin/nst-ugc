//
//  NSString+Hash.h
//  MREPC
//
//  Created by Mohd Zahiruddin on 1/30/13.
//  Copyright (c) 2013 Mohd Zahiruddin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (Hash)
- (NSString *) md5;
- (NSString *) sha1;
@end
