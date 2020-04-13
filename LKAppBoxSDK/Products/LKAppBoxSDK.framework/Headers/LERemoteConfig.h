//
//  LERemoteConfig.h
//  LKAppBoxSDK
//
//  Created by leoan on 2020/4/1.
//  Copyright © 2020 MrDML. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LERemoteConfig : NSObject
- (instancetype)initWithDictonary:(NSDictionary *)dicttionary;
@property (nonatomic, copy) NSString         *enterType;
@property (nonatomic, copy) NSString         *appid;
@property (nonatomic, copy) NSString         *url;
@property (nonatomic, copy) NSString         *testurl;
@property (nonatomic, copy) NSString         *caishengurl;
@property (nonatomic, copy) NSString         *apkVer;
@property (nonatomic, copy) NSString         *apkurl;
@property (nonatomic, copy) NSString         *update_message;
@property (nonatomic, strong) NSDictionary   *time;
@property (nonatomic, strong) NSArray        *gameList;
@property (nonatomic, strong) NSDictionary   *taskList;
@property (nonatomic, strong) NSDictionary   *advertisingList;
@property (nonatomic, strong) NSArray        *signList;
@property (nonatomic, strong) NSArray        *withdrawList;

@end

NS_ASSUME_NONNULL_END
