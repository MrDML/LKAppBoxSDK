//
//  LKAppBoxManager.m
//  GameDemo
//
//  Created by leoan on 2020/3/27.
//  Copyright © 2020 leoan. All rights reserved.
//

#import "LKAppBoxManager.h"
#import <SSZipArchive/SSZipArchive.h>
#import "LEAppBoxContainerView.h"
#import "LELocalCongfig.h"
#import "LERemoteConfig.h"
#import "LEABNetWorking.h"
#import "LELoadingView.h"

static LKAppBoxManager *_instance = nil;

@interface LKAppBoxManager ()

// document自定义文件夹根路径名字 name
@property (nonatomic, copy) NSString *rootPathName;

// 项目目录引用文本文件路径
@property (nonatomic, copy) NSString *folderPath;

@property (nonatomic, strong) LEAppBoxContainerView *appBoxVC;

@property (nonatomic, strong) UIViewController *rootViewController;

@property (nonatomic, copy) void (^requestComplete)(BOOL isSuccess,LERemoteConfig *remoteConfig,NSError *error);


@end

@implementation LKAppBoxManager

+ (instancetype)instance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LKAppBoxManager alloc] init];
    });
    return _instance;
}
/// 初始化AppBoxSDK
/// @param folderPath 项目目录引用路径
/// @param rootPathName 根路径Name
- (void)initializationAppBoxSDKWithFolder:(NSString *)folderPath withRootDocumentPathName:(NSString *)rootPathName{
    
    self.folderPath = folderPath;
    self.rootPathName = rootPathName;
    // 文件路径
    NSString *lingkingPath = [self getRootFilePath:rootPathName];
    //[self getRootFilePath:@"com.lingKing.www"];
     // 初始化压缩
    NSString *webFilePAth =[lingkingPath stringByAppendingPathComponent:@"web"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:webFilePAth]) { // 如果不存在web路径在进行压缩
        [self ssZipArchiveWithFolder:folderPath withFilePath:lingkingPath];
        [self uSSZipArchiveFilePath:lingkingPath];
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//           [self ssZipArchiveWithFolder:folderPath withFilePath:lingkingPath];
//           [self uSSZipArchiveFilePath:lingkingPath];
//        });
    
    }
    
     // 读取本地json文件
    
    // 请求网络服务配置文件
    
}

/// 初始化AppBoxSDK
/// @param folderPath 项目目录引用路径
/// @param rootPathName 根路径Name
/// @param configs 本地配置
- (void)initializationAppBoxSDKWithFolder:(NSString *)folderPath withRootDocumentPathName:(NSString *)rootPathName withLoadLocalConfig:(NSDictionary *)configs {
    
    self.folderPath = folderPath;
    self.rootPathName = rootPathName;
    // 文件路径
    NSString *lingkingPath = [self getRootFilePath:rootPathName];
    //[self getRootFilePath:@"com.lingKing.www"];
     // 初始化压缩
    NSString *webFilePAth =[lingkingPath stringByAppendingPathComponent:@"web"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:webFilePAth]) { // 如果不存在web路径在进行压缩
        [self ssZipArchiveWithFolder:folderPath withFilePath:lingkingPath];
        [self uSSZipArchiveFilePath:lingkingPath];
    
    }
    
    // 加载本地配置
    [self setAppGameLocalConfigs:configs];
    

}

/// 配置本地config 对SDK 进行初始化
/// @param configs configs
- (void)setAppGameLocalConfigs:(NSDictionary *)configs{
    
    if (configs == nil) {
        return;
    }
    LELocalCongfig *sdkConf = [[LELocalCongfig alloc] initWithDictonary:configs];
    NSData *sdkConfData =[NSKeyedArchiver archivedDataWithRootObject:sdkConf];
    [[NSUserDefaults standardUserDefaults] setObject:sdkConfData forKey:@"LOCALCONFIG"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)setAppGameLocalConfigsPath:(NSString *)path{
    if (path == nil || path.length <= 0) {
        return;
    }
    NSData *contentData = [NSData dataWithContentsOfFile:path];
    if (contentData != nil) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"---->%@",dict);
        [self setAppGameLocalConfigs:dict];
    }
}

// 请求远程配置信息
- (void)requestRemoteConfigRootViewController:(UIViewController *)rootViewController{
 
    [[LELoadingView instance] showLoging:rootViewController.view];
    
    LELocalCongfig *config = [LELocalCongfig getLocalConfigInfos];
    
    [LEABNetWorking getWithURLString:config.serUrl success:^(id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{

            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                LERemoteConfig *remoteConfig = [[LERemoteConfig alloc] initWithDictonary:responseObject];
                if (self.requestComplete) {
                    self.requestComplete(YES, remoteConfig, nil);
                }
            }
        });
        
    } failure:^(NSError *error) {
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.requestComplete) {
                self.requestComplete(NO, nil, error);
            }
        });

    }];
    
}



/// 初始化游戏视图
/// @param rootViewController rootViewController g根控制器
/// @param frmae 视图frame
/// @param objcetApi 接口定义类
/// @param jsPath js路径
- (void)initializationAppGameRootViewController:(UIViewController *)rootViewController withViewFrame:(CGRect)frmae withObjcetApi:(id)objcetApi withAppendingJavaScriptPathComponent:(NSString *)jsPath{
      self.appBoxVC =[[LEAppBoxContainerView alloc] init];
      self.appBoxVC.modalPresentationStyle =  UIModalPresentationCustom;
      self.appBoxVC.frame = frmae;
      self.appBoxVC.jsPath = jsPath;
      self.appBoxVC.webPath = [self getWebFilePath:self.rootPathName];
      self.appBoxVC.objectApi = objcetApi;
      self.rootViewController = rootViewController;
     

}

/// 重新布局
- (void)gameViewDidLayoutSubviews{
    [self.appBoxVC gameViewDidLayoutSubviews];
}

/// 展示游戏
- (void)loadGameToDisplay{
    
   __weak typeof(self)WeakSelf = self;

     self.requestComplete = ^(BOOL isSuccess, LERemoteConfig *remoteConfig, NSError *error) {
    
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [[LELoadingView instance] hiddenLoging];
              [WeakSelf.rootViewController presentViewController:WeakSelf.appBoxVC  animated:NO completion:nil];
             
             if (isSuccess) { // 请求成功加载网络游戏
                 
                    NSURL *url = [NSURL URLWithString:remoteConfig.url];
                 
                   // 加载远程游戏
                    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest

                    [WeakSelf.appBoxVC loadRequest:request];
                
             }else{ // 请求失败加载本地游戏
                  
                   NSString *webPath =  [WeakSelf getWebFilePath:WeakSelf.rootPathName];

                    NSString *indexPath  = [webPath stringByAppendingPathComponent:@"index.html"];

                    NSURL* url = [NSURL  fileURLWithPath:indexPath];
                   //  yyyy-MM-dd HH:mm:ss
                    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest

                   [WeakSelf.appBoxVC loadRequest:request];
                 
             }
         });
         
    };

}

- (void)loadGameJS_OCTestToDisplay{
          [self.rootViewController presentViewController:self.appBoxVC  animated:NO completion:nil];
           NSString *webPath =  [self getWebFilePath:self.rootPathName];

           NSString *indexPath  = [webPath stringByAppendingPathComponent:@"jsoc/test_bridge.html"];

           NSURL* url = [NSURL  fileURLWithPath:indexPath];
         
           NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest

          [self.appBoxVC loadRequest:request];
}


- (NSString *)getWebFilePath:(NSString *)rootPathName{
    
    // 缓存目录结构: temp/com.lee.content/[folder]
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
     
//    NSString *documentPath  =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString*documentPath_FilePath = [self getRootFilePath:rootPathName];
    //[self getFilePath:@"www.lingKing.www"];
    //NSLog(@"----->%@",documentPath_FilePath);
    
    NSString *filePathWeb = [NSString stringWithFormat:@"%@/%@",documentPath_FilePath,@"web"];
    
    //NSString *filePath = [NSString stringWithFormat:@"%@%@/%@" , NSTemporaryDirectory() , @"com.lee.content" , folder ? folder : @""];
    
    // 判断该文件夹是否存在
    if(![fileManager fileExistsAtPath:filePathWeb]){
        
        NSAssert([fileManager fileExistsAtPath:filePathWeb] == YES, @"web路径不存在，初始化失败...");
    }
    
    return filePathWeb;
}


/// 创建文件夹
/// @param dir <#dir description#>
- (NSString *)createDirectory:(NSString *)dir{
    
    NSString *documentPath  =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    // @"com.lingKing.www"
    NSString  *filePath = [documentPath stringByAppendingPathComponent:dir];
      
    NSFileManager *fileManager = [NSFileManager defaultManager];
      
      if (![fileManager fileExistsAtPath:filePath]) {
          
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
          
          return filePath;
          
      }
    return nil;
}


/// 获取根document目录文件夹
/// @param path <#path description#>
- (NSString *)getRootFilePath:(NSString *)path{
    NSString *documentPath  =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath =  [documentPath stringByAppendingPathComponent:path];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) { // 存在就返回
        return filePath;
    }else{ // 不存在就创建
      return [self createDirectory:path];
    }
}


#pragma mark -- 压缩
- (BOOL)ssZipArchiveWithFolder:(NSString *)folderPath withFilePath:(NSString *)filePath {
    
      // document
      // NSString *documentPath  =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString*documentPath_FilePath = filePath;
    //[self getFilePath:@"com.lingKing.www"];
    
         //Caches路径
      // NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
      //zip压缩包保存路径
       NSString *path = [documentPath_FilePath stringByAppendingPathComponent:@"web.zip"];
        //需要压缩的文件夹路径
     //创建不带密码zip压缩包
       BOOL isSuccess = [SSZipArchive createZipFileAtPath:path withContentsOfDirectory:folderPath ];
     
       NSLog(@"path--->%@",path);
       return isSuccess;
}


#pragma mark -- 解压缩
- (BOOL)uSSZipArchiveFilePath:(NSString *)filePath{
    // NSString *documentPath  =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString*documentPath_FilePath = filePath;
    //[self getFilePath:@"www.lingKing.www"];
    // 解压目标路径
     NSString *destinationPath = [documentPath_FilePath stringByAppendingPathComponent:@"web"];
    // zip压缩包的路径
    NSString *path = [documentPath_FilePath stringByAppendingPathComponent:@"web.zip"];
    // 解压
    BOOL isSuccess = [SSZipArchive unzipFileAtPath:path toDestination:destinationPath];
    
     NSLog(@"path--->%@",path);
    
     return isSuccess;

}


@end
