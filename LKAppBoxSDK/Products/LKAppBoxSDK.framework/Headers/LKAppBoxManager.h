//
//  LKAppBoxManager.h
//  GameDemo
//
//  Created by leoan on 2020/3/27.
//  Copyright © 2020 leoan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,LKAESENCRYPT) {
    LKAESENCRYPT_CBC = 1,
    LKAESENCRYPT_ECB
};

@class LEAppBoxContainerView;

@protocol LKAppBoxManagerDelegate <NSObject>

@optional
- (void)appboxGagmeDidLoadDisplay;
- (void)appboxInitializaSuccess;

@end

@interface LKAppBoxManager : NSObject
@property (nonatomic, weak) id <LKAppBoxManagerDelegate> delegate;
@property (nonatomic, strong,readonly) LEAppBoxContainerView *appBoxVC;
@property (nonatomic, assign)  BOOL isInitSuccess;
@property (nonatomic, assign) BOOL isEncrypt; // 是否对bundle 进行了加密处理
@property (nonatomic, assign,readonly)  BOOL isExistWebFolder;

// 加密部分
@property (nonatomic, assign) LKAESENCRYPT encryptStyle;
@property (nonatomic, strong) NSDictionary *bundleJsLocalOpeners;
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
/// @param frame 视图frame
/// @param objcetApi 接口定义类
/// @param jsPath js路径
- (void)initializationAppGameRootViewController:(UIViewController *)rootViewController withViewFrame:(CGRect)frame withObjcetApi:(id)objcetApi withAppendingJavaScriptPathComponent:(NSString *)jsPath;


/// 初始化游戏视图
/// @param rootViewController rootViewController g根控制器
/// @param frame 视图frame
/// @param objcetApi 接口定义类
/// @param jsPath  js路径
/// @param isEncrypt <#isEncrypt description#>
- (void)initializationAppGameRootViewController:(UIViewController *)rootViewController withViewFrame:(CGRect)frame withObjcetApi:(id)objcetApi withAppendingJavaScriptPathComponent:(NSString *)jsPath withBundleJSIsEncrypt:(BOOL)isEncrypt;

/// 初始化游戏视图
/// @param rootViewController rootViewController 根控制器
/// @param frame 视图frame
/// @param objcetApi 接口定义类
- (void)initializationAppGameRootViewController:(UIViewController *)rootViewController withViewFrame:(CGRect)frame withObjcetApi:(id)objcetApi;


/// 加载本地游戏
- (void)loadLocalGameToDisplay;
/// 加载配配置文件中的远程游戏
- (void)loadRemoteMenuGameToDisplay;
// 加载远程游戏
- (void)loadRemoteServerGameURLToDisplay:(NSURL *)url;
/// 测试js-oc 使用
- (void)loadGameJS_OCTestToDisplay;
/// 重新布局
- (void)gameViewDidLayoutSubviews;

@end


