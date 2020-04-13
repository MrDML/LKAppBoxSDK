//
//  LEABUUID.m
//  LKAppBoxSDK
//
//  Created by leoan on 2020/4/11.
//  Copyright © 2020 dml1630@163.com. All rights reserved.
//

#import "LEABUUID.h"
#import "LEABKeyChainStore.h"
#define  KEY_USERNAME_PASSWORD @"com.company.app.usernamepassword"
#define  KEY_USERNAME @"com.company.app.username"
#define  KEY_PASSWORD @"com.company.app.password"
@implementation LEABUUID
+ (NSString *)getUUID
{
    
    //  NSString *app_Name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *bundleIdentifier = @"com.leaon.wwww";
    //[[NSBundle mainBundle] bundleIdentifier];
   
    NSString * strUUID = (NSString *)[LEABKeyChainStore load: @"com.leaon.wwww"];
    
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        
        //生成一个uuid的方法
        
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        
        [LEABKeyChainStore save:bundleIdentifier data:strUUID];
        
    }
    return strUUID;
}
@end
