//
//  LEABNetWorking.m
//  LKAppBoxSDK
//
//  Created by leoan on 2020/4/11.
//  Copyright © 2020 dml1630@163.com. All rights reserved.
//

#import "LEABNetWorking.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "LEABNetWorking.h"
#import "LEABUUID.h"
#import "LEABNetUtils.h"
typedef void (^LESuccessBlock)(id obj);
typedef void (^LEFailureBlock)(NSError *error);

//static AFHTTPSessionManager *manager;
static LEABNetWorking *manager = nil;
@implementation LEABNetWorking


+(LEABNetWorking *)sharedHttpSessionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        manager = [[LEABNetWorking alloc] init];
    });
    
    return manager;
}


+ (void)getWithURLString:(NSString *)urlString success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data != nil) {
            id object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                       
                   if ([object isKindOfClass:[NSDictionary class]]) {
                       
                       NSDictionary *responseDict = (NSDictionary *)object;
                       if (error) {
                           failure(error);
                       }else{
                                  
                         NSData *data = [NSJSONSerialization dataWithJSONObject:responseDict options:NSJSONWritingPrettyPrinted error:nil];
                         
                         NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                         
                         NSLog(@"josnStr:%@",responseStr);
                         
                         success(responseDict);
                       }
                   }
        }
     
        
    }]resume];
      
}


+ (void)postWithURLString:(NSString *)urlString  parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    
     NSError *error=nil;

     NSURLSession *session = [NSURLSession sharedSession];
     
    NSDictionary *resultDict = parameters;
    //[self dealParameters:parameters];
     NSData *data =[NSJSONSerialization dataWithJSONObject:resultDict options:NSJSONWritingPrettyPrinted error:&error];
     
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy  timeoutInterval:60.0];
     
     [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
     [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
     

     [request setHTTPMethod:@"POST"];
     [request setHTTPBody:data];
     
     NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         
         if (data != nil) {
             id object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                 
                 if ([object isKindOfClass:[NSDictionary class]]) {
                     
                     NSDictionary *responseDict = (NSDictionary *)object;
                     if (error) {
                         failure(error);
                     }else{
                                
                       NSData *data = [NSJSONSerialization dataWithJSONObject:responseDict options:NSJSONWritingPrettyPrinted error:nil];
                       
                       NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                       
                       NSLog(@"josnStr:%@",responseStr);
                       
                       success(responseDict);
                     }
                 }
         }
         
     }];
     
     [postDataTask resume];
}




+ (void)postWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters HTTPHeaderField:(NSDictionary *)headerField success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure
{

    NSError *error=nil;

    NSURLSession *session = [NSURLSession sharedSession];
    
    NSDictionary *resultDict = [self dealParameters:parameters];
    NSData *data =[NSJSONSerialization dataWithJSONObject:resultDict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy  timeoutInterval:60.0];
    
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if (headerField != nil) {
        for (NSString *key in headerField.allKeys) {
            [request setValue:headerField[key] forHTTPHeaderField:key];
        }
    }
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data != nil) {
            id object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                
                if ([object isKindOfClass:[NSDictionary class]]) {
                    
                    NSDictionary *responseDict = (NSDictionary *)object;
                    if (error) {
                        failure(error);
                    }else{
                               
                      NSData *data = [NSJSONSerialization dataWithJSONObject:responseDict options:NSJSONWritingPrettyPrinted error:nil];
                      
                      NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                      
                      NSLog(@"josnStr:%@",responseStr);
                      
                      success(responseDict);
                    }
                }
        }
        
    }];
    
    [postDataTask resume];
}

//+ (void)postWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
//
//    NSDictionary *resultDict = [self dealParameters:parameters];
//
//    NSData *data =[NSJSONSerialization dataWithJSONObject:resultDict options:NSJSONWritingPrettyPrinted error:nil];
//    AFURLSessionManager *session = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//
//    NSMutableURLRequest *request =  [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:parameters error:nil];
//
//    request.timeoutInterval = 60;
//    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setHTTPBody:data];
//
//    [[session dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//
//        if (error) {
//            failure(error);
//        }else{
//            NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
//
//            NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//            NSLog(@"josnStr:%@",responseStr);
//
//            success(responseObject);
//        }
//
//    }] resume];
//
//}

//+ (void)postWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
//
//
//    NSDictionary *resultParames =  [self dealParameters:parameters];
//
//    NSString *json = [[self dictionaryToJson:parameters] stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//    NSLog(@"---->%@",resultParames);
//
//
//    AFHTTPSessionManager *session = [LENetWorking sharedHttpSessionManager];
//    session.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//     // session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
//
//    //session.responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml",nil]];
//
//    //[session.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//
////   [session.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
////    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
//
// [session.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//  session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
//    //session.requestSerializer.timeoutInterval = 20;
//    session.requestSerializer = [AFJSONRequestSerializer serializer];
//
//
//    [session.requestSerializer requestWithMethod:@"POST" URLString:urlString parameters:resultParames error:nil];
//
//    [session POST:urlString parameters:resultParames progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        NSLog(@"-------->%@",responseObject);
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
//
//}

//+ (void)request{
//    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
//
//    [parames setObject:@"ios" forKey:@"channel"];
//    [parames setObject:@"AppStore" forKey:@"sub_channel"];
//    [parames setObject:[LEUUID getUUID] forKey:@"device_id"];
//    [parames setObject:[LENetUtils deviceInfo] forKey:@"device_info"];
//    [parames setObject:[[UIDevice currentDevice] systemName] forKey:@"os"];
//    [parames setObject:[[UIDevice currentDevice] systemVersion] forKey:@"version"];
//
//    // 获取随机字符串
//    NSString *randString = [LENetUtils randomString];
//
//    // 加密类型
//    NSString *sign_type = @"MD5";
//
//
//    [parames setObject:sign_type forKey:@"sign_type"];
//    [parames setObject:randString forKey:@"nonce_str"];
//
//
//    [self postWithURLString:@"http://47.75.141.161:8095/s/test/login/direct_login" parameters:parames success:^(id  _Nonnull responseObject) {
//
//    } failure:^(NSError * _Nonnull error) {
//
//    }];
//}


+ (NSDictionary *)dealParameters:(NSDictionary *)parames{
    
    NSMutableDictionary *resultParames = [NSMutableDictionary dictionaryWithDictionary:parames];
    
    // 数据签名
    NSString *signVal = [LEABNetUtils getSignData:parames];
    
    
    [resultParames setValue:signVal forKey:@"sign"];
    

//    NSData *data =[NSJSONSerialization dataWithJSONObject:resultParames options:NSJSONWritingPrettyPrinted error:nil];
//
//    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    return resultParames;
}
@end
