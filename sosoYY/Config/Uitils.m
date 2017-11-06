//
//  Uitils.m
//  MouthHealth
//
//  Created by 张海勇 on 15/3/16.
//  Copyright (c) 2015年 张海勇. All rights reserved.
//

#import "Uitils.h"
#import "UIImageView+WebCache.h"
#import <Reachability.h>

@implementation Uitils

+(BOOL)isNetWorkReach {
    
    Reachability *reachability=[Reachability reachabilityWithHostName:checkHost];
    return [reachability currentReachabilityStatus] > 0;
}

+(BOOL)some:(NSArray *)array content:(NSString *)objc {

    for (int i = 0; i<array.count; i++) {
        
        if ([array[i] isEqualToString:objc]) {
            
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)setIntervalSinceNow: (NSString *) theDate{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd"];
    NSDate *d = [date dateFromString:theDate];
    
    NSTimeInterval late = [d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate date];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    
    NSTimeInterval cha = late - now;
    if (cha >= 3600*24*365) {
        return YES;
    }else{
        return NO;
    }
}

//判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}




////检测可用网络
//+ (void)reach {
//    /**
//     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
//     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
//     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
//     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
//     */
//    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//    
//    // 检测网络连接的单例,网络变化时的回调方法
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case 0:
//                [Uitils alertWithTitle:@"请检查网络"];
//                break;
//            case 1:
//                [Uitils alertWithTitle:@"网络已连接"];
//                
//                break;
//            case 2:
//                [Uitils alertWithTitle:@"wifi已连接"];
//                
//                break;
//            default:
//                break;
//        }
//        
//        NSLog(@"%ld",status);
//    }];
//}


+ (void)shake:(UITextField *)label {
    
    label.transform = CGAffineTransformIdentity;
    [UIView beginAnimations:nil context:nil];//动画的开始
    [UIView setAnimationDuration:0.05];//完成时间
    [UIView setAnimationRepeatCount:3];//重复
    [UIView setAnimationRepeatAutoreverses:YES];//往返运动
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];//控制速度变化
    label.transform = CGAffineTransformMakeTranslation(-5, 0);//设置横纵坐标的移动
    [UIView commitAnimations];//动画结束
}


//照片压缩
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

//获取AuthData
+ (id)getUserDefaultsForKey:(NSString *)key
{
    if (key ==nil || [key length] <=0) {
        return nil;
    }
    id  AuthData = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return AuthData;
}

//保存AuthData
+ (void)setUserDefaultsObject:(id)value ForKey:(NSString *)key
{
    if (key !=nil && [key length] >0) {
        [[NSUserDefaults standardUserDefaults]setObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

//删除NSUserdefault
+ (void)UserDefaultRemoveObjectForKey:(NSString *)key
{
    if (key !=nil && [key length] >0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (UIColor *)colorWithHex:(unsigned long)col {
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(double)r/255.0f green:(double)g/255.0f blue:(double)b/255.0f alpha:1];
}


+(void)cacheImage:(NSString *)urlStr withImageV:(UIImageView *)imageV withPlaceholder:(NSString *)placehImg{

    [imageV sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:placehImg]];
    
}

+(NSArray *)returnWeekdy:(NSDate *)date
{

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitDay
                                         fromDate:date];
    // 得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekDay = [comp weekday];
    // 得到几号
    NSInteger day = [comp day];

    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 1;
        lastDiff = 0;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
        lastDiff = 9 - weekDay;
    }
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM"];
//    NSLog(@"星期一开始 %@",[formater stringFromDate:firstDayOfWeek]);
//    NSLog(@"当前 %@",[formater stringFromDate:now]);
//    NSLog(@"星期天结束 %@",[formater stringFromDate:lastDayOfWeek]);
    
    return [[NSArray alloc]initWithObjects:[formater stringFromDate:firstDayOfWeek],[formater stringFromDate:date],[formater stringFromDate:lastDayOfWeek], nil];
}

////某年的某月的天数
//+(int)getDaysOfMonth:(int)year withMonth:(int)month
//{
//    int days = 0;
//    
//    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 9 || month == 10 || month == 12)
//    {
//        days = 31;
//    }
//    else if (month == 4 || month == 6 || month == 8 || month == 11)
//    {
//        days = 30;
//    }
//    else
//    { // 2月份，闰年29天、平年28天
//        if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0)
//        {
//            days = 29;
//        }
//        else
//        {
//            days = 28;
//        }
//    }
//    
//    return days;
//}

+(BOOL)isEmpty:(NSString *)text
{
    if (text.length == 0) {
        return YES;
    }
    return NO;
}


+(NSString *)isNullClass:(id)obj
{
    if ([obj isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return obj;
}

+(NSString *)nullClass:(NSString *)obj returnStr:(NSString *)str
{
    if (obj.length == 0) {
        return str;
    }
    return obj;
}


//获取documents下的文件路径
+ (NSString *)getDocumentsPath:(NSString *)fileName {
    
    NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    return path;
}


////判断密码强弱
//+ (BOOL) judgeRange:(NSArray*) _termArray Password:(NSString*) _password
//{
//    NSRange range;
//    BOOL result =NO;
//    for(int i=0; i<[_termArray count]; i++)
//    {
//        range = [_password rangeOfString:[_termArray objectAtIndex:i]];
//        if(range.location != NSNotFound)
//        {
//            result =YES;
//        }
//    }
//    return result;
//}

//给你一个方法，输入参数是NSDate，输出结果是星期几的字符串。
+ (NSString*)weekdayStringFromDate:(NSString*)inputDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:inputDate];
    
    NSArray *weekdays = [NSArray arrayWithObjects:@"",@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    
    FxLog(@"%ld",theComponents.weekday);
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

/////判断密码强弱
//+ (NSString*) judgePasswordStrength:(NSString*) _password
//{
//    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
//    
//    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
//    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
//    NSArray* termArray3 = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
//    NSArray* termArray4 = [[NSArray alloc] initWithObjects:@"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/",@"、", nil];
//    
//    NSString* result1 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray1 Password:_password]];
//    NSString* result2 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray2 Password:_password]];
//    NSString* result3 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray3 Password:_password]];
//    NSString* result4 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray4 Password:_password]];
//    
//    [resultArray addObject:[NSString stringWithFormat:@"%@",result1]];
//    [resultArray addObject:[NSString stringWithFormat:@"%@",result2]];
//    [resultArray addObject:[NSString stringWithFormat:@"%@",result3]];
//    [resultArray addObject:[NSString stringWithFormat:@"%@",result4]];
//    
//    int intResult=0;
//    for (int j=0; j<[resultArray count]; j++)
//    {
//        if ([[resultArray objectAtIndex:j] isEqualToString:@"1"])
//        {
//            intResult++;
//        }
//    }
//    NSString* resultString = [[NSString alloc] init];
//    if (intResult <= 2)
//    {
//        resultString = @"密码强度低，建议修改";
//    }
//    else if (intResult == 2&&[_password length]>=6)
//    {
//        resultString = @"密码强度一般";
//    }
//    if (intResult > 2&&[_password length]>=6)
//    {
//        resultString = @"密码强度高";
//    }
//    return resultString;
//}

/*
 1.获得屏幕图像
 - (UIImage *)imageFromView: (UIView *) theView
 {
 
 UIGraphicsBeginImageContext(theView.frame.size);
 CGContextRef context = UIGraphicsGetCurrentContext();
 [theView.layer renderInContext:context];
 UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 
 return theImage;
 }
 
 2.label的动态size
 
 - (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize
 
 {
 
 NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
 
 paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
 
 NSDictionary* attributes =@{NSFontAttributeName:[UIFont fontWithName:@"MicrosoftYaHei" size:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
 
 CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
 
 labelSize.height=ceil(labelSize.height);
 return labelSize;
 
 }
 
 3.时间戳转化为时间
 
 -(NSString*)TimeTrasformWithDate:(NSString *)dateString
 {
 NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
 [formatter setDateFormat:@"YY-MM-dd HH:mm"];
 [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
 
 NSString *date = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:dateString.integerValue]];
 //NSLog(@"date1:%@",date);
 return date;
 
 }
 
 4.RGB转化成颜色
 
 + (UIColor *)colorFromHexRGB:(NSString *)inColorString
 {
 UIColor *result = nil;
 unsigned int colorCode = 0;
 unsigned char redByte, greenByte, blueByte;
 
 if (nil != inColorString)
 {
 NSScanner *scanner = [NSScanner scannerWithString:inColorString];
 (void) [scanner scanHexInt:&colorCode]; // ignore error
 }
 redByte = (unsigned char) (colorCode >> 16);
 greenByte = (unsigned char) (colorCode >> 8);
 blueByte = (unsigned char) (colorCode); // masks off high bits
 result = [UIColor
 colorWithRed: (float)redByte / 0xff
 green: (float)greenByte/ 0xff
 blue: (float)blueByte / 0xff
 alpha:1.0];
 return result;
 }
 
 5.加边框
 
 UIRectCorner corners=UIRectCornerTopLeft | UIRectCornerTopRight;
 UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
 byRoundingCorners:corners
 cornerRadii:CGSizeMake(4, 0)];
 CAShapeLayer *maskLayer = [CAShapeLayer layer];
 maskLayer.frame         = view.bounds;
 maskLayer.path          = maskPath.CGPath;
 view.layer.mask         = maskLayer;
 6.//压缩图片
 + (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
 {
 //创建一个图形上下文形象
 UIGraphicsBeginImageContext(newSize);
 // 告诉旧图片画在这个新的环境,所需的
 // new size
 [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
 //获取上下文的新形象
 UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
 // 结束上下文
 UIGraphicsEndImageContext();
 return newImage;
 }
 
 7.textfield的placeholder
 
 [textF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
 [textF setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
 8.
 
 butLeft. imageEdgeInsets = UIEdgeInsetsMake (7 , 5 , 7 , 25  );
 butLeft.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
 9.//调用此方法改变label最后2个字符的大小
 - (void)label:(UILabel *)label BehindTextSize:(NSInteger)integer
 {
 NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc] initWithString:label.text];
 
 [mutaString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(label.text.length-2, 2)];
 label.attributedText = mutaString;
 }
 
 10.- (void)ChangeLabelTextColor:(UILabel *)label
 {
 NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc] initWithString:label.text];
 
 [mutaString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:207/255.0 green:34/255.0 blue:42/255.0 alpha:1] range:NSMakeRange(0, 5)];
 label.attributedText = mutaString;
 }
 
 11.
 
 if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
 
 [tableView setSeparatorInset:UIEdgeInsetsZero];
 
 }
 if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
 if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
 
 [tableView setLayoutMargins:UIEdgeInsetsZero];
 
 }
 }
 
 // Do any additional setup after loading the view.
 }
 - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
 
 {
 
 if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
 
 [cell setSeparatorInset:UIEdgeInsetsZero];
 
 }
 if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
 if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
 
 [cell setLayoutMargins:UIEdgeInsetsZero];
 
 }
 }
 
 
 }
 12。图片变灰度
 
 -(UIImage *) grayscaleImage: (UIImage *) image
 {
 CGSize size = image.size;
 CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width,
 image.size.height);
 // Create a mono/gray color space
 CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
 CGContextRef context = CGBitmapContextCreate(nil, size.width,
 size.height, 8, 0, colorSpace, kCGImageAlphaNone);
 CGColorSpaceRelease(colorSpace);
 // Draw the image into the grayscale context
 CGContextDrawImage(context, rect, [image CGImage]);
 CGImageRef grayscale = CGBitmapContextCreateImage(context);
 CGContextRelease(context);
 // Recover the image
 UIImage *img = [UIImage imageWithCGImage:grayscale];
 CFRelease(grayscale);
 return img;
 }
 13.16进制转rgb
 
 #define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
 */


@end
