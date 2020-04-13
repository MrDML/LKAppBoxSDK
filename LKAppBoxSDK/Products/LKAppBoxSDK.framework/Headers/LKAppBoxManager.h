//
//  LKAppBoxManager.h
//  GameDemo
//
//  Created by leoan on 2020/3/27.
//  Copyright © 2020 leoan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LKAppBoxManagerDelegate <NSObject>

@optional
- (void)appboxGagmeDidLoadDisplay;

@end

@interface LKAppBoxManager : NSObject
@property (nonatomic, weak) id <LKAppBoxManagerDelegate> delegate;
+ (instancetype)instance;
/// 初始化AppBoxSDK
/// @param folderPath 项目目录引用路径
/// @param rootPathName 根路径Name
- (void)initializationAppBoxSDKWithFolder:(NSString *)folderPath withRootDocumentPathName:(NSString *)rootPathName;

/// 初始化AppBoxSDK
/// @param folderPath 项目目录引用路径
/// @param rootPathName 根路径Name
/// @param configs 本地配置
- (void)initializationAppBoxSDKWithFolder:(NSString *)folderPath withRootDocumentPathName:(NSString *)rootPathName withLoadLocalConfig:(NSDictionary *)configs;


// ==========  新增 ============
/// 配置本地config 对SDK 进行初始化
/// @param configs configs
- (void)setAppGameLocalConfigs:(NSDictionary *)configs;
- (void)setAppGameLocalConfigsPath:(NSString *)path;


// (加载本地配置后请求才可以请求远程配置信息)请求远程配置信息
- (void)requestRemoteConfigRootViewController:(UIViewController *)rootViewController;
// ==========  新增 ============

/// 初始化游戏视图
/// @param rootViewController rootViewController g根控制器
/// @param frmae 视图frame
/// @param objcetApi 接口定义类
/// @param jsPath js路径
- (void)initializationAppGameRootViewController:(UIViewController *)rootViewController withViewFrame:(CGRect)frmae withObjcetApi:(id)objcetApi withAppendingJavaScriptPathComponent:(NSString *)jsPath;
/// 展示游戏
- (void)loadGameToDisplay;
- (void)loadGameJS_OCTestToDisplay;
/// 重新布局
- (void)gameViewDidLayoutSubviews;
@end

NS_ASSUME_NONNULL_END
