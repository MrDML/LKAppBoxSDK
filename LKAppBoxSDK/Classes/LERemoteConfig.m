//
//  LERemoteConfig.m
//  LKAppBoxSDK
//
//  Created by leoan on 2020/4/1.
//  Copyright © 2020 MrDML. All rights reserved.
//

#import "LERemoteConfig.h"

@implementation LERemoteConfig

- (instancetype)initWithDictonary:(NSDictionary *)dicttionary{
    
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dicttionary];
    }
    return self;
}





@end
