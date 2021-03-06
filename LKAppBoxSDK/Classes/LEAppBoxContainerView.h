//
//  LEAppBoxContainerView.h
//  GameDemo
//
//  Created by leoan on 2020/3/27.
//  Copyright © 2020 leoan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LEAppBoxContainerView : UIViewController
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, copy)NSString *jsPath;
@property (nonatomic, copy)NSString *webPath;
@property (nonatomic, strong) id objectApi;

// 加载本地请求
- (void)loadRequest:(NSURLRequest *)request;
// 重新布局
- (void)gameViewDidLayoutSubviews;

@end

NS_ASSUME_NONNULL_END
