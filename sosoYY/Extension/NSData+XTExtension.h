//
//  NSData+XTExtension.h
//  XTFramework
//
//  Created by Qing Xiubin on 13-8-15.
//  Copyright (c) 2013年 XT. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (XTExtension)

//加密
- (NSString *) MD5String;
- (NSData *) md5Digest;
- (NSData *) sha1Digest;

- (NSString *)base64Encoded;
- (NSData *)base64Decoded;

@end


@interface NSData (XTJson)
//将NSData转化成对应的对象
- (id)objectFromJSONData;
//连同null的数据转成对象
- (id)objectFromJSONDataWithoutNull;

@end


@interface NSData (Encryption)

//加密
- (NSData *)encryptWithKey:(NSString *)key algorithm:(CCOptions)algorithm;
//解密
- (NSData *)decryptWithKey:(NSString *)key  algorithm:(CCOptions)algorithm;

//AES加密
- (NSData *)AESEncryptWithKey:(NSString *)key;

//AES解密
- (NSData *)AESDecryptWithKey:(NSString *)key;

//DES加密
- (NSData *)DESEncryptWithKey:(NSString *)key;

//DES解密
- (NSData *)DESDecryptWithKey:(NSString *)key;

//RSA加密(path:证书路径)
- (NSData *)RSAEncryptWithPath:(NSString *)path;

@end