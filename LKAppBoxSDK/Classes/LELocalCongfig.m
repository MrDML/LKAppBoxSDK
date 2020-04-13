//
//  LELocalCongfig.m
//  LKAppBoxSDK
//
//  Created by leoan on 2020/4/1.
//  Copyright © 2020 MrDML. All rights reserved.
//

#import "LELocalCongfig.h"

@implementation LELocalCongfig

- (instancetype)initWithDictonary:(NSDictionary *)dicttionary{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dicttionary];
    }
    return self;
}
// 解码
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {

        self.serUrl = [coder decodeObjectForKey:@"serUrl"];
        self.ver = [coder decodeObjectForKey:@"ver"];
        self.gameID = [coder decodeObjectForKey:@"gameID"];
        self.gameName = [coder decodeObjectForKey:@"gameName"];
        self.channel = [coder decodeObjectForKey:@"channel"];
        self.wx_appid = [coder decodeObjectForKey:@"wx_appid"];
        self.td_appid = [coder decodeObjectForKey:@"td_appid"];
        self.bugly_appid = [coder decodeObjectForKey:@"bugly_appid"];
        self.bugly_debugMode = [coder decodeObjectForKey:@"bugly_debugMode"];
        self.csj_appid = [coder decodeObjectForKey:@"csj_appid"];
        self.csj_appname = [coder decodeObjectForKey:@"csj_appname"];
        self.td_Adtracking_appid = [coder decodeObjectForKey:@"td_Adtracking_appid"];
  
    }
    return self;
}

// 编码
- (void)encodeWithCoder:(NSCoder *)coder
{
   [coder encodeObject:self.serUrl forKey:@"serUrl"];
   [coder encodeObject:self.ver forKey:@"ver"];
   [coder encodeObject:self.gameID forKey:@"gameID"];
   [coder encodeObject:self.gameName forKey:@"gameName"];
   [coder encodeObject:self.channel forKey:@"channel"];
   [coder encodeObject:self.wx_appid forKey:@"wx_appid"];
   [coder encodeObject:self.td_appid forKey:@"td_appid"];
   [coder encodeObject:self.bugly_appid forKey:@"bugly_appid"];
   [coder encodeObject:self.bugly_debugMode forKey:@"bugly_debugMode"];
   [coder encodeObject:self.csj_appid forKey:@"csj_appid"];
   [coder encodeObject:self.csj_appname forKey:@"csj_appname"];
   [coder encodeObject:self.td_Adtracking_appid forKey:@"td_Adtracking_appid"];
    
}
+ (LELocalCongfig *)getLocalConfigInfos{
    // 或取本地数据
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"LOCALCONFIG"];
    if(data == nil){
       NSLog(@"No configuration information is available or obtained locally!!!");
       return nil;
    }
    LELocalCongfig *sdkConf = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return sdkConf;
}


@end
