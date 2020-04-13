//
//  LEABWebKitSupport.h
//  LKAppBoxSDK
//
//  Created by leoan on 2020/4/11.
//  Copyright © 2020 dml1630@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface LEABWebKitSupport : NSObject
@property (nonatomic, strong,readonly) WKProcessPool *processPool;

+ (instancetype)sharedSupport;

+ (NSURLRequest *)fixRequest:(NSURLRequest *)request;

+ (NSURL *)urlAddParams:(NSURL *)url Params:(NSDictionary *)params;
@end

@interface NSHTTPCookie (ABUtils)

- (NSString *)lee_javascriptString;

@end

@interface ABWeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic , weak ) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end

@interface WKWebView (ABCrashHandle)

@end

NS_ASSUME_NONNULL_END
