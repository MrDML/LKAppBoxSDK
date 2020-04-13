//
//  LEAppBoxContainerView.m
//  GameDemo
//
//  Created by leoan on 2020/3/27.
//  Copyright © 2020 leoan. All rights reserved.
//

#import "LEAppBoxContainerView.h"
#import "LEABWebKitSupport.h"
#import "dsbridge.h"
@interface LEAppBoxContainerView ()<WKUIDelegate , WKNavigationDelegate>
@property (nonatomic , strong ) ABWeakScriptMessageDelegate *scriptDelegate; // 脚本代理
@property (nonatomic , strong ) DWKWebView *webView; //内容webview

@end

@implementation LEAppBoxContainerView
////
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initGameViewFrame:self.frame withJavaScriptPath:self.jsPath withWebPath:self.webPath];
    
}


- (void)gameViewDidLayoutSubviews{
    
    self.webView.frame = self.frame;
}
- (void)loadRequest:(NSURLRequest *)request{
    
    [self.webView loadRequest:request];
}


- (void)initGameViewFrame:(CGRect)frmae withJavaScriptPath:(NSString *)jsPath withWebPath:(NSString *)webPath{
      WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
           self.frame = frmae;
           webConfig.preferences = [[WKPreferences alloc] init]; // 设置偏好设置
           
        //   webConfig.preferences.minimumFontSize = 10; // 默认为0
           
          // webConfig.preferences.javaScriptEnabled = YES; // 默认认为YES
           
         //  webConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO; // 在iOS上默认为NO，表示不能自动通过窗口打开
           
           webConfig.userContentController = [[WKUserContentController alloc] init]; // 通过JS与webview内容交互
           
           // [webConfig.userContentController addScriptMessageHandler:self.scriptDelegate name:decodedString]; // 注入JS对象
           
    //       [webConfig.userContentController addScriptMessageHandler:self.scriptDelegate name:ScriptName_loadImage]; // 注入JS对象
    //
    //       [webConfig.userContentController addScriptMessageHandler:self.scriptDelegate name:ScriptName_loadGifImage]; // 注入JS对象
        

           webConfig.preferences.javaScriptEnabled = YES;
           webConfig.preferences.javaScriptCanOpenWindowsAutomatically = YES;
           webConfig.suppressesIncrementalRendering = YES; // 是否支持记忆读取
          [webConfig.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
           if (@available(iOS 10.0, *)) {
                [webConfig setValue:@YES forKey:@"allowUniversalAccessFromFileURLs"];
           }
        
        
           self.webView = [[DWKWebView alloc] initWithFrame:frmae configuration:webConfig];
           
           self.webView.backgroundColor = [UIColor whiteColor];
           
          // self.webView.UIDelegate = self;
           
           self.webView.navigationDelegate = self;
           
           self.webView.scrollView.bounces = NO;
           
           self.webView.scrollView.bouncesZoom = NO;
           
           self.webView.scrollView.showsHorizontalScrollIndicator = NO;
           
           self.webView.scrollView.directionalLockEnabled = YES;
           
           self.webView.scrollView.scrollEnabled = NO;

           [self.view addSubview:self.webView];
    
       
       //[self.webView addJavascriptObject:[[LEJsApi alloc] init] namespace:nil];
       [self.webView addJavascriptObject:self.objectApi namespace:nil];
        
       //[self.webView setDebugMode:true];
      
        [self.webView customJavascriptDialogLabelTitles:@{@"alertTitle":@"Notification",@"alertBtn":@"OK"}];
         //NSString *webPath = [self getWebFilePath:@"com.lingKing.www"];
        // webView
         // NSString *js_bundlePath  = [webPath stringByAppendingPathComponent:@"js/bundle"];
         NSString *js_bundlePath  = [webPath stringByAppendingPathComponent:jsPath];

          NSData *js_bundleData = [NSData dataWithContentsOfFile:js_bundlePath];

    if (js_bundleData == nil) {
        NSAssert(js_bundleData != nil, @"bundleData is nill please reload install app");
    }
    
          NSData *decodedData  = [[NSData alloc] initWithBase64EncodedData:js_bundleData options:0];

           //NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];

           NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];

//           NSLog(@"---->%@",decodedString);
         [self.webView evaluateJavaScript:decodedString completionHandler:^(id _Nullable response, NSError * _Nullable error) {

//            //更新webview高度
//            NSLog(@"----");
//            NSLog(@"error====>%@",error);
//            NSLog(@"response====>%@",response);
        }];
//

}


#pragma mark - WKUIDelegate

// 创建新的webview
// 可以指定配置对象、导航动作对象、window特性
//- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
//
//    // 创建一个新的WebView（标签带有 target='_blank' 时，导致WKWebView无法加载点击后的网页的问题。）
//    // 接口的作用是打开新窗口委托
//
//    WKFrameInfo *frameInfo = navigationAction.targetFrame;
//
//    if (![frameInfo isMainFrame]) {
//
//        [webView loadRequest:navigationAction.request];
//    }
//
//    return nil;
//}

// webview关闭时回调
//- (void)webViewDidClose:(WKWebView *)webView{
//
//}
//
//// 调用JS的alert()方法
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
//
//    completionHandler();
//}
//
//// 调用JS的confirm()方法
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
//
//     completionHandler(YES);
//}

// 调用JS的prompt()方法
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
//    completionHandler(@"");
//}

#pragma mark - WKNavigationDelegate

// 决定导航的动作，通常用于处理跨域的链接能否导航。WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接
// 单独处理。但是，对于Safari是允许跨域的，不用这么处理。
// 这个是决定是否Request
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//
//    WKFrameInfo *targetFrameInfo = navigationAction.targetFrame;
//
//    if (targetFrameInfo) {
//
//        decisionHandler(WKNavigationActionPolicyAllow);
//
//    } else {
//
//        NSURL *url = navigationAction.request.URL;
//
//        [[UIApplication sharedApplication] openURL:url];
//
//        decisionHandler(WKNavigationActionPolicyCancel);
//    }
//
//}
//
//// 决定是否接收响应
//// 这个是决定是否接收response
//// 要获取response，通过WKNavigationResponse对象获取
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//
//    decisionHandler(WKNavigationResponsePolicyAllow);
//}
//
//// 当main frame的导航开始请求时，会调用此方法
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
//
//}
//
//// 当main frame接收到服务重定向时，会回调此方法
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
//
//}
//
//// 当main frame开始加载数据失败时，会回调
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
//
//}
//
//// 当main frame的web内容开始到达时，会回调
//- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
//
//}
//
//// 当main frame导航完成时，会回调
//- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
//
//    __weak typeof(self) weakSelf = self;
//
//}
//
//// 当main frame最后下载数据失败时，会回调
//- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
//
//}
//
//// 这与用于授权验证的API，与AFN、UIWebView的授权验证API是一样的
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler{
//
//    //AFNetworking中的处理方式
//
//    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
//
//    __block NSURLCredential *credential = nil;
//
//    //判断服务器返回的证书是否是服务器信任的
//
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//
//        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//
//        /*disposition：如何处理证书
//         NSURLSessionAuthChallengePerformDefaultHandling:默认方式处理
//         NSURLSessionAuthChallengeUseCredential：使用指定的证书    NSURLSessionAuthChallengeCancelAuthenticationChallenge：取消请求
//         */
//        if (credential) {
//
//            disposition = NSURLSessionAuthChallengeUseCredential;
//
//        } else {
//
//            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
//        }
//
//    } else {
//
//        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
//    }
//
//    //安装证书
//
//    if (completionHandler) completionHandler(disposition, credential);
//}
//
//// 9.0才能使用，web内容处理中断时会触发
//- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
//
//    [webView reload];
//}
////
////#pragma mark - WKScriptMessageHandler
////
//- (void)userContentController:(WKUserContentController *)userContentController
//      didReceiveScriptMessage:(WKScriptMessage *)message {
//
//    // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
//    // NSDictionary, and NSNull类型
//
//
//
//}
@end
