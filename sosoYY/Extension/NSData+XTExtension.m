//
//  NSData+XTExtension.m
//  XTFramework
//
//  Created by Qing Xiubin on 13-8-15.
//  Copyright (c) 2013年 XT. All rights reserved.
//

#import "NSData+XTExtension.h"

@implementation NSData (XTExtension)

static char encodingTable[64] = {
    'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
    'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
    'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
    'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/' };


- (NSString *) MD5String{
	NSData * value = [self md5Digest];
	if ( value ){
		char			tmp[16];
		unsigned char *	hex = (unsigned char *)malloc( 2048 + 1 );
		unsigned char *	bytes = (unsigned char *)[value bytes];
		unsigned long	length = [value length];
		
		hex[0] = '\0';
		
		for ( unsigned long i = 0; i < length; ++i ){
			sprintf( tmp, "%02X", bytes[i] );
			strcat( (char *)hex, tmp );
		}
		
		NSString * result = [NSString stringWithUTF8String:(const char *)hex];
		free( hex );
		return result;
	}
	else{
		return nil;
	}
}
- (NSData *)md5Digest{
	unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5([self bytes], (CC_LONG)[self length], result);
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}
- (NSData *)sha1Digest{
	unsigned char result[CC_SHA1_DIGEST_LENGTH];
    
	CC_SHA1([self bytes], (CC_LONG)[self length], result);
    return [NSData dataWithBytes:result length:CC_SHA1_DIGEST_LENGTH];
}

- (NSData *)base64Decoded{
	const unsigned char	*bytes = [self bytes];
	NSMutableData *result = [NSMutableData dataWithCapacity:[self length]];
	
	unsigned long ixtext = 0;
	unsigned long lentext = [self length];
	unsigned char ch = 0;
	unsigned char inbuf[4] = {0, 0, 0, 0};
	unsigned char outbuf[3] = {0, 0, 0};
	short i = 0, ixinbuf = 0;
	BOOL flignore = NO;
	BOOL flendtext = NO;
	
	while( YES ){
		if( ixtext >= lentext ) break;
		ch = bytes[ixtext++];
		flignore = NO;
		
		if( ( ch >= 'A' ) && ( ch <= 'Z' ) ) ch = ch - 'A';
		else if( ( ch >= 'a' ) && ( ch <= 'z' ) ) ch = ch - 'a' + 26;
		else if( ( ch >= '0' ) && ( ch <= '9' ) ) ch = ch - '0' + 52;
		else if( ch == '+' ) ch = 62;
		else if( ch == '=' ) flendtext = YES;
		else if( ch == '/' ) ch = 63;
		else flignore = YES;
		
		if( ! flignore ){
			short ctcharsinbuf = 3;
			BOOL flbreak = NO;
			
			if( flendtext ){
				if( ! ixinbuf ) break;
				if( ( ixinbuf == 1 ) || ( ixinbuf == 2 ) ) ctcharsinbuf = 1;
				else ctcharsinbuf = 2;
				ixinbuf = 3;
				flbreak = YES;
			}
			
			inbuf [ixinbuf++] = ch;
			
			if( ixinbuf == 4 ){
				ixinbuf = 0;
				outbuf [0] = ( inbuf[0] << 2 ) | ( ( inbuf[1] & 0x30) >> 4 );
				outbuf [1] = ( ( inbuf[1] & 0x0F ) << 4 ) | ( ( inbuf[2] & 0x3C ) >> 2 );
				outbuf [2] = ( ( inbuf[2] & 0x03 ) << 6 ) | ( inbuf[3] & 0x3F );
				
				for( i = 0; i < ctcharsinbuf; i++ )
					[result appendBytes:&outbuf[i] length:1];
			}
			
			if( flbreak )  break;
		}
	}
	
	return [NSData dataWithData:result];
}

- (NSString *)base64Encoded{
	const unsigned char	*bytes = [self bytes];
	NSMutableString *result = [NSMutableString stringWithCapacity:[self length]];
	unsigned long ixtext = 0;
	unsigned long lentext = [self length];
	long ctremaining = 0;
	unsigned char inbuf[3], outbuf[4];
	unsigned short i = 0;
	unsigned short charsonline = 0, ctcopy = 0;
	unsigned long ix = 0;
	
	while( YES ){
		ctremaining = lentext - ixtext;
		if( ctremaining <= 0 ) break;
		
		for( i = 0; i < 3; i++ ) {
			ix = ixtext + i;
			if( ix < lentext ) inbuf[i] = bytes[ix];
			else inbuf [i] = 0;
		}
		
		outbuf [0] = (inbuf [0] & 0xFC) >> 2;
		outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
		outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
		outbuf [3] = inbuf [2] & 0x3F;
		ctcopy = 4;
		
		switch( ctremaining ){
			case 1:
				ctcopy = 2;
				break;
			case 2:
				ctcopy = 3;
				break;
		}
		
		for( i = 0; i < ctcopy; i++ )
			[result appendFormat:@"%c", encodingTable[outbuf[i]]];
		
		for( i = ctcopy; i < 4; i++ )
			[result appendString:@"="];
		
		ixtext += 3;
		charsonline += 4;
	}
	
	return [NSString stringWithString:result];
}

@end


@implementation NSData (XTJson)

static id XTJSONObjectByRemovingKeysWithNullValues(id JSONObject, NSJSONReadingOptions readingOptions) {
    if ([JSONObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[(NSArray *)JSONObject count]];
        for (id value in (NSArray *)JSONObject) {
            [mutableArray addObject:XTJSONObjectByRemovingKeysWithNullValues(value, readingOptions)];
        }
        
        return (readingOptions & NSJSONReadingMutableContainers) ? mutableArray : [NSArray arrayWithArray:mutableArray];
    } else if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:JSONObject];
        for (id <NSCopying> key in [(NSDictionary *)JSONObject allKeys]) {
            id value = [(NSDictionary *)JSONObject objectForKey:key];
            if (!value || [value isEqual:[NSNull null]]) {
                [mutableDictionary removeObjectForKey:key];
            } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                [mutableDictionary setObject:XTJSONObjectByRemovingKeysWithNullValues(value, readingOptions) forKey:key];
            }
        }
        
        return (readingOptions & NSJSONReadingMutableContainers) ? mutableDictionary : [NSDictionary dictionaryWithDictionary:mutableDictionary];
    }
    
    return JSONObject;
}

- (id)objectFromJSONData{
    NSError *error = nil;
    NSJSONReadingOptions options = NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self options:options error:&error];
    if (error) {
        FxLog(@"解析JSON出错--->error:%@",error); return nil;
    }
    
    return jsonObject;
}
- (id)objectFromJSONDataWithoutNull{
    NSError *error = nil;
    NSJSONReadingOptions options = NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self options:options error:&error];
    if (error) {
        FxLog(@"解析JSON出错--->error:%@",error); return nil;
    }
    return XTJSONObjectByRemovingKeysWithNullValues(jsonObject,options);
}

@end


@implementation NSData (Encryption)

- (NSData *)encryptWithKey:(NSString *)key algorithm:(CCOptions)algorithm{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = 1204;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, algorithm, kCCOptionPKCS7Padding,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize, &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    
    return nil;
}

- (NSData *)decryptWithKey:(NSString *)key  algorithm:(CCOptions)algorithm{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = 1204;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, algorithm,
                                          kCCOptionPKCS7Padding,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    
    return nil;
}

//AES加密
- (NSData *)AESEncryptWithKey:(NSString *)key {
    return [self encryptWithKey:key algorithm:kCCAlgorithmAES128];
}

//AES解密
- (NSData *)AESDecryptWithKey:(NSString *)key {
    return [self decryptWithKey:key algorithm:kCCAlgorithmAES128];
}

//DES加密
- (NSData *)DESEncryptWithKey:(NSString *)key {
    return [self encryptWithKey:key algorithm:kCCAlgorithmDES];
}

//DES解密
- (NSData *)DESDecryptWithKey:(NSString *)key {
    return [self decryptWithKey:key algorithm:kCCAlgorithmDES];
}

//RSA加密(path:证书路径)
- (NSData *)RSAEncryptWithPath:(NSString *)path{
    
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
    if (publicKeyPath == nil) {
        FxLog(@"Can not find pub.der");
        return nil;
    }
    
    NSData *publicKeyData = [NSData dataWithContentsOfFile:publicKeyPath];
    if (publicKeyData == nil) {
        FxLog(@"Can not read from pub.der");
        return nil;
    }
    
    SecCertificateRef certificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)publicKeyData);
    if (certificate == nil) {
        FxLog(@"Can not read certificate from pub.der");
        return nil;
    }
    
    SecTrustRef trust;
    SecPolicyRef policy = SecPolicyCreateBasicX509();
    OSStatus returnCode = SecTrustCreateWithCertificates(certificate, policy, &trust);
    if (returnCode != 0) {
        FxLog(@"SecTrustCreateWithCertificates fail. Error Code: %ld", (long)returnCode);
        return nil;
    }
    
    SecTrustResultType trustResultType;
    returnCode = SecTrustEvaluate(trust, &trustResultType);
    if (returnCode != 0) {
        FxLog(@"SecTrustEvaluate fail. Error Code: %ld", (long)returnCode);
        return nil;
    }
    
    SecKeyRef publicKey = SecTrustCopyPublicKey(trust);
    CFRelease(certificate);
    CFRelease(trust);
    CFRelease(policy);
    
    
    size_t plainLen = [self length];
    size_t maxPlainLen = SecKeyGetBlockSize(publicKey) - 12;
    if (plainLen > maxPlainLen) {
        FxLog(@"content(%ld) is too long, must < %ld", plainLen, maxPlainLen);
        return nil;
    }
    
    void *plain = malloc(plainLen);
    [self getBytes:plain length:plainLen];
    
    size_t cipherLen = 128; // 当前RSA的密钥长度是128字节
    void *cipher = malloc(cipherLen);
    
    NSData *result = nil;
    returnCode = SecKeyEncrypt(publicKey, kSecPaddingPKCS1, plain, plainLen, cipher, &cipherLen);
    if (returnCode != errSecSuccess) {
        FxLog(@"SecKeyEncrypt fail. Error Code: %ld", (long)returnCode);
    } else {
        result = [NSData dataWithBytes:cipher length:cipherLen];
    }
    free(plain);
    free(cipher);
    
    return result;
}

@end
