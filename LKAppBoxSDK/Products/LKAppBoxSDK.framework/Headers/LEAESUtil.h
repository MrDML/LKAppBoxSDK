//
//  LEAESUtil.h
//  LKAppBoxSDK_Example
//
//  Created by leoan on 2020/3/31.
//  Copyright © 2020 MrDML. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LEAESUtil : NSObject
/// ECB 模式下128 加密
/// @param encData 字符串待加密内容
/// @param aeskey AES KEY
+ (NSString *)AES128ECBEncrypt:(NSString *)encData withAESKey:(NSString *)aeskey;
///  ECB 模式下128 加密
/// @param encData  二进制待加密内容
/// @param key AES KEY
+ (NSData *)AES128ECBEncryptData:(NSData *)encData WithKey:(NSString *)key;
///  ECB 模式下128 解密
/// @param decData  字符串待解密内容
/// @param aeskey AES KEY
+ (NSString *)AES128ECBDecrypt:(NSString *)decData withAESKey:(NSString *)aeskey;
/// ECB 模式下128 解密
/// @param decData 字符串带解密内容
/// @param key AES KEY
+ (NSData *)AES128ECBDecryptData:(NSData *)decData withAESKey:(NSString *)key;



/// CBC 模式下 128 加密
/// @param encData  字符串待加密内容
/// @param aeskey  AES KEY (32位)
/// @param ivKey ivKey (16位)
+ (NSString *)AES256CBCEncrypt:(NSString *)encData withAESKey:(NSString *)aeskey withIvkey:(NSString *)ivKey;
///  CBC 模式下 256 加密
/// @param encData  二进制待加密内容
/// @param aeskey AES KEY
/// @param ivKey ivKey
+ (NSData *)AES256CBCEncryptData:(NSData *)encData withAESKey:(NSString *)aeskey withIvkey:(NSString *)ivKey;
/// CBC 模式下  128 解密
/// @param decData 字符串待解密内容
/// @param aeskey AES KEY (32位)
/// @param ivKey ivKey (16位)
+ (NSString *)AES256CBCDecrypt:(NSString *)decData withAESKey:(NSString *)aeskey withIvkey:(NSString *)ivKey;
/// CBC 模式下  128 解密
/// @param decData 二进制待解密内容
/// @param aeskey AES KEY (32位)
/// @param ivKey ivKey (16位)
+ (NSData *)AES256CBCDecryptData:(NSData *)decData withAESKey:(NSString *)aeskey withIvkey:(NSString *)ivKey;
@end

NS_ASSUME_NONNULL_END
