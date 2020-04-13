//
//  LELocalCongfig.h
//  LKAppBoxSDK
//
//  Created by leoan on 2020/4/1.
//  Copyright © 2020 MrDML. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LELocalCongfig : NSObject<NSCoding>
- (instancetype)initWithDictonary:(NSDictionary *)dicttionary;
+ (LELocalCongfig *)getLocalConfigInfos;
@property(nonatomic, copy)NSString         *serUrl;
@property(nonatomic, copy)NSString         *ver;
@property(nonatomic, copy)NSString         *gameID;
@property(nonatomic, copy)NSString         *gameName;
@property(nonatomic, copy)NSString         *channel;
@property(nonatomic, copy)NSString         *wx_appid;
@property(nonatomic, copy)NSString         *td_appid;
@property(nonatomic, copy)NSString         *bugly_appid;
@property(nonatomic, copy)NSString         *bugly_debugMode;
@property(nonatomic, copy)NSString         *csj_appid;
@property(nonatomic, copy)NSString         *csj_appname;
@property(nonatomic, copy)NSString         *td_Adtracking_appid;
@end

NS_ASSUME_NONNULL_END


