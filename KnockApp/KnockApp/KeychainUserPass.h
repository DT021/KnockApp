//
//  KeychainUserPass.h
//  MC3
//
//  Created by Fangzhou Sun on 6/5/14.
//  Copyright (c) 2014 Fangzhou Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainUserPass : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
