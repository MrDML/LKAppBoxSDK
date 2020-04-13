//
//  LELoadingView.m
//  LKAppBoxSDK
//
//  Created by leoan on 2020/4/1.
//  Copyright © 2020 MrDML. All rights reserved.
//

#import "LELoadingView.h"
#import <WebKit/WebKit.h>
#import "LKAppBoxManager.h"
static LELoadingView *_instance;
@interface LELoadingView ()
@property (nonatomic,strong) WKWebView  *webView;
@end

@implementation LELoadingView


+ (instancetype)instance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LELoadingView alloc] init];
    });
    return _instance;
}

- (void)showLoging:(UIView *)superView{

    self.frame = CGRectMake(0, 0, 150, 150);
    [self setCenter:superView.center];
    self.backgroundColor = [UIColor orangeColor];
    [superView insertSubview:self atIndex:superView.subviews.count - 1];
    self.hidden = NO;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    self.webView .backgroundColor = [UIColor whiteColor];
    [self addSubview:self.webView ];

      NSBundle *bundle = [NSBundle bundleForClass:[LELoadingView class]];
      NSURL *url_tmp = [bundle URLForResource:@"LKAppBoxSDK" withExtension:@".bundle"];
      if (url_tmp != nil) {
          bundle = [NSBundle bundleWithURL:url_tmp];
          NSString *gifPath = [bundle pathForResource:@"pika" ofType:@"gif"];
          NSURL *url = [[NSURL alloc] initFileURLWithPath:gifPath];
          [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
      }

}


- (void)hiddenLoging{
    [self.webView removeFromSuperview];
    self.webView = nil;
    self.hidden = YES;
    [self removeFromSuperview];
    
}

@end
