//
//  NSDate+XTExtension.h
//  XTFramework
//
//  Created by Qing Xiubin on 13-8-15.
//  Copyright (c) 2013年 XT. All rights reserved.
//


#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

#define CALENDAR_CURRENT [NSCalendar currentCalendar]
#define CALENDAR_UNIT (\
NSCalendarUnitYear|\
NSCalendarUnitMonth |\
NSCalendarUnitWeekOfYear |\
NSCalendarUnitWeekOfMonth |\
NSCalendarUnitWeekdayOrdinal |\
NSCalendarUnitWeekday |\
NSCalendarUnitDay |\
NSCalendarUnitHour |\
NSCalendarUnitMinute)

#define COMPONENTS(date) [CALENDAR_CURRENT components:CALENDAR_UNIT fromDate:date]


@interface NSDate (XTExtension)

// Decomposing dates
@property (readonly) NSInteger year;
@property (readonly) NSInteger month;
@property (readonly) NSInteger weekOfYear;
@property (readonly) NSInteger weekOfMonth;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger day;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;

// Relative Dates
//weeks周之后的今天是好多号
+ (NSDate *)dateWithWeeksFromNow:(NSUInteger)weeks;
//weeks周之前的今天是好多号
+ (NSDate *)dateWithWeeksBeforeNow:(NSUInteger)weeks;
//days天后是几号
+ (NSDate *)dateWithDaysFromNow:(NSUInteger)days;
//days天之前是几号
+ (NSDate *)dateWithDaysBeforeNow:(NSUInteger)days;

+ (NSDate *)dateWithHoursFromNow:(NSUInteger)hours;
+ (NSDate *)dateWithHoursBeforeNow:(NSUInteger)hours;
+ (NSDate *)dateWithMinutesFromNow:(NSUInteger)minutes;
+ (NSDate *)dateWithMinutesBeforeNow:(NSUInteger)minutes;

// Comparing Dates
- (BOOL)isToday;
- (BOOL)isTomorrow;
- (BOOL)isYesterday;
- (BOOL)isThisWeek;
- (BOOL)isNextWeek;
- (BOOL)isLastWeek;
- (BOOL)isThisMonth;
- (BOOL)isNextMonth;
- (BOOL)isLastMonth;
- (BOOL)isThisYear;
- (BOOL)isNextYear;
- (BOOL)isLastYear;

- (BOOL)isEarlierThanDate:(NSDate *)date;
- (BOOL)isLaterThanDate:(NSDate *)date;
- (BOOL)isSameDayAsDate:(NSDate *)date;
- (BOOL)isSameWeekAsDate:(NSDate *)date;
- (BOOL)isSameMonthAsDate:(NSDate *)date;
- (BOOL)isSameYearAsDate:(NSDate *)date;

// Adjusting Dates
// 加上一周时间的日期
- (NSDate *)dateByAddingWeeks:(NSUInteger)weeks;
//减去一周的时间的日期
- (NSDate *)dateBySubtractingWeeks:(NSUInteger)weeks;
//加一天的日期
- (NSDate *)dateByAddingDays:(NSUInteger)days;
//减一周的日期
- (NSDate *)dateBySubtractingDays:(NSUInteger)days;
//加一个小时的日期
- (NSDate *)dateByAddingHours:(NSUInteger)hours;
//减去一周的日期
- (NSDate *)dateBySubtractingHours:(NSUInteger)hours;
//加上一分钟后的日期
- (NSDate *)dateByAddingMinutes:(NSUInteger)minutes;
//减去一分钟的日期
- (NSDate *)dateBySubtractingMinutes:(NSUInteger)minutes;

//今年开始第一天的日期
- (NSDate *)dateAtStartOfYear;
//这个月开始第一天的日期
- (NSDate *)dateAtStartOfMonth;
//这个周开始第一天的日期
- (NSDate *)dateAtStartOfWeek;
////今天开始第一天的日期
- (NSDate *)dateAtStartOfDay;
- (NSDate *)dateAtStartOfDayWithHour:(NSInteger)hour;

- (NSDate *)lastYear;
- (NSDate *)nextYear;
- (NSDate *)lastMonth;
- (NSDate *)nextMonth;
- (NSDate *) dateAtLastOfMonth;
- (NSDate *) dateAtNextOfMonth;

// Retrieving Intervals
//相差多少周
- (NSInteger)weeksAfterDate:(NSDate *)date;
- (NSInteger)weeksBeforeDate:(NSDate *)date;
//相差多少天
- (NSInteger)daysAfterDate:(NSDate *)date;
- (NSInteger)daysBeforeDate:(NSDate *)date;
//相差多少小时
- (NSInteger)hoursAfterDate:(NSDate *)date;
- (NSInteger)hoursBeforeDate:(NSDate *)date;
//相差多少分钟
- (NSInteger)minutesAfterDate:(NSDate *)date;
- (NSInteger)minutesBeforeDate:(NSDate *)date;

@end


@interface NSDate (XTFormate)

- (NSString *)stringWithFormate:(NSString *)formate;

@end