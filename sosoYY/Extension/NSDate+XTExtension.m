//
//  NSDate+XTExtension.m
//  XTFramework
//
//  Created by Qing Xiubin on 13-8-15.
//  Copyright (c) 2013年 XT. All rights reserved.
//

#import "NSDate+XTExtension.h"


@implementation NSDate (XTExtension)

/**********************************************************************/
#pragma mark Decomposing Dates
/**********************************************************************/

- (NSInteger)year{
	NSDateComponents *components = COMPONENTS(self);
	return components.year;
}

- (NSInteger)month{
	NSDateComponents *components = COMPONENTS(self);
	return components.month;
}

- (NSInteger)weekOfYear{
	NSDateComponents *components = COMPONENTS(self);
	return components.weekOfYear;
}

- (NSInteger)weekOfMonth{
	NSDateComponents *components = COMPONENTS(self);
	return components.weekOfMonth;
}

- (NSInteger)weekday{
	NSDateComponents *components = COMPONENTS(self);
	return components.weekday;
}

- (NSInteger)day{
	NSDateComponents *components = COMPONENTS(self);
	return components.day;
}

- (NSInteger)hour{
	NSDateComponents *components = COMPONENTS(self);
	return components.hour;
}

- (NSInteger) minute{
	NSDateComponents *components = COMPONENTS(self);
	return components.minute;
}

- (NSInteger)seconds{
	NSDateComponents *components = COMPONENTS(self);
	return components.second;
}

/**********************************************************************/
#pragma mark Relative Dates
/**********************************************************************/

+ (NSDate *)dateWithWeeksFromNow:(NSUInteger)weeks{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSince1970] + D_WEEK * weeks;
	NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
	return newDate;
}
+ (NSDate *)dateWithWeeksBeforeNow:(NSUInteger)weeks{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSince1970] - D_WEEK * weeks;
	NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
	return newDate;
}

+ (NSDate *)dateWithDaysFromNow:(NSUInteger)days{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSince1970] + D_DAY * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
	return newDate;
}

+ (NSDate *)dateWithDaysBeforeNow:(NSUInteger)days{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSince1970] - D_DAY * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
	return newDate;
}

+ (NSDate *)dateWithHoursFromNow:(NSUInteger)hours{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSince1970] + D_HOUR * hours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
	return newDate;
}

+ (NSDate *)dateWithHoursBeforeNow:(NSUInteger)hours{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSince1970] - D_HOUR * hours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
	return newDate;
}

+ (NSDate *)dateWithMinutesFromNow:(NSUInteger)minutes{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSince1970] + D_MINUTE * minutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
	return newDate;
}

+ (NSDate *)dateWithMinutesBeforeNow:(NSUInteger)minutes{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSince1970] - D_MINUTE * minutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
	return newDate;
}

#pragma mark Comparing Dates

- (NSInteger)daysFrom1970{
    return ([self timeIntervalSince1970]+28800)/D_DAY;
}

- (NSInteger)weeksFrom1970{
    return ([self timeIntervalSince1970]+28800)/D_WEEK;
}

- (BOOL)isToday{
    NSInteger dateInterval = [self daysFrom1970];
    NSInteger nowInterval = [[NSDate date] daysFrom1970];
    return dateInterval==nowInterval;
}

- (BOOL)isYesterday{
    NSInteger dateInterval = [self daysFrom1970];
    NSInteger nowInterval = [[NSDate date] daysFrom1970];
    return dateInterval==nowInterval-1;
}

- (BOOL)isTomorrow{
    NSInteger dateInterval = [self daysFrom1970];
    NSInteger nowInterval = [[NSDate date] daysFrom1970];
    return dateInterval==nowInterval+1;
}

- (BOOL)isThisWeek{
    NSInteger dateInterval = [self weeksFrom1970];
    NSInteger nowInterval = [[NSDate date] weeksFrom1970];
    return dateInterval==nowInterval;
}

- (BOOL)isLastWeek{
    NSInteger dateInterval = [self weeksFrom1970];
    NSInteger nowInterval = [[NSDate date] weeksFrom1970];
    return dateInterval==nowInterval-1;
}

- (BOOL)isNextWeek{
    NSInteger dateInterval = [self weeksFrom1970];
    NSInteger nowInterval = [[NSDate date] weeksFrom1970];
    return dateInterval==nowInterval+1;
}

- (BOOL)isThisMonth{
	NSDateComponents *components1 = COMPONENTS(self);
	NSDateComponents *components2 = COMPONENTS([NSDate date]);;
	return ((components1.year == components2.year) &&
			(components1.month == components2.month));
}

- (BOOL)isNextMonth{
	NSDateComponents *components1 = COMPONENTS(self);
	NSDateComponents *components2 = COMPONENTS([NSDate date]);;
    if (components1.year == components2.year+1 && components1.month==1 && components2.month==12) {
        return YES;
    }
	return ((components1.year == components2.year) &&
			(components1.month == components2.month + 1));
}

- (BOOL)isLastMonth{
	NSDateComponents *components1 = COMPONENTS(self);
	NSDateComponents *components2 = COMPONENTS([NSDate date]);;
    if (components1.year == components2.year-1 && components1.month==12 && components2.month==1) {
        return YES;
    }
	return ((components1.year == components2.year) &&
			(components1.month == components2.month - 1));
}

- (BOOL)isThisYear{
	NSDateComponents *components1 = COMPONENTS(self);
	NSDateComponents *components2 = COMPONENTS([NSDate date]);;
	return (components1.year == (components2.year));
}

- (BOOL)isNextYear{
	NSDateComponents *components1 = COMPONENTS(self);
	NSDateComponents *components2 = COMPONENTS([NSDate date]);;
	return (components1.year == (components2.year + 1));
}

- (BOOL)isLastYear{
	NSDateComponents *components1 = COMPONENTS(self);
	NSDateComponents *components2 = COMPONENTS([NSDate date]);;
	return (components1.year == (components2.year - 1));
}

- (BOOL)isEarlierThanDate:(NSDate *)date{
	return ([self earlierDate:date] == self);
}

- (BOOL)isLaterThanDate:(NSDate *)date{
	return ([self laterDate:date] == self);
}

- (BOOL)isSameDayAsDate:(NSDate *)date{
	NSDateComponents *components1 = COMPONENTS(self);
	NSDateComponents *components2 = COMPONENTS(date);
	return ((components1.year == components2.year) &&
			(components1.month == components2.month) &&
			(components1.day == components2.day));
}

- (BOOL)isSameWeekAsDate:(NSDate *)date{
	NSDateComponents *components1 = COMPONENTS(self);
	NSDateComponents *components2 = COMPONENTS(date);
	return ((components1.year == components2.year) &&
			(components1.weekOfYear == components2.weekOfYear));
}

- (BOOL)isSameMonthAsDate:(NSDate *)date{
	NSDateComponents *components1 = COMPONENTS(self);
	NSDateComponents *components2 = COMPONENTS(date);
	return ((components1.year == components2.year) &&
			(components1.month == components2.month));
}

- (BOOL)isSameYearAsDate:(NSDate *)date{
	NSDateComponents *components1 = COMPONENTS(self);
	NSDateComponents *components2 = COMPONENTS(date);
	return (components1.year == components2.year);
}

/**********************************************************************/
#pragma mark Adjusting Dates
/**********************************************************************/

- (NSDate *)dateByAddingWeeks:(NSUInteger)weeks{
	NSTimeInterval aTimeInterval = [self timeIntervalSince1970] + D_WEEK * weeks;
	NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
	return newDate;
}

- (NSDate *)dateBySubtractingWeeks:(NSUInteger)weeks{
	NSTimeInterval aTimeInterval = [self timeIntervalSince1970] - D_WEEK * weeks;
	NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
	return newDate;
}

- (NSDate *)dateByAddingDays:(NSUInteger)days{
	NSTimeInterval aTimeInterval = [self timeIntervalSince1970] + D_DAY * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
	return newDate;
}

- (NSDate *)dateBySubtractingDays:(NSUInteger)days{
	NSTimeInterval aTimeInterval = [self timeIntervalSince1970] - D_DAY * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
	return newDate;
}

- (NSDate *)dateByAddingHours:(NSUInteger)hours{
	NSTimeInterval aTimeInterval = [self timeIntervalSince1970] + D_HOUR * hours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
	return newDate;
}

- (NSDate *)dateBySubtractingHours:(NSUInteger)hours{
	NSTimeInterval aTimeInterval = [self timeIntervalSince1970] - D_HOUR * hours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
	return newDate;
}

- (NSDate *)dateByAddingMinutes:(NSUInteger)minutes{
	NSTimeInterval aTimeInterval = [self timeIntervalSince1970] + D_MINUTE * minutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
	return newDate;
}

- (NSDate *)dateBySubtractingMinutes:(NSUInteger)minutes{
	NSTimeInterval aTimeInterval = [self timeIntervalSince1970] - D_MINUTE * minutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
	return newDate;
}

- (NSDate *)dateAtStartOfYear{
    NSDateComponents *components = COMPONENTS(self);
    [components setMonth:1];
    [components setDay:1];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	return [CALENDAR_CURRENT dateFromComponents:components];
}

- (NSDate *)dateAtStartOfMonth{
    NSDateComponents *components = COMPONENTS(self);
    [components setDay:1];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	return [CALENDAR_CURRENT dateFromComponents:components];
}

- (NSDate *)dateAtStartOfWeek{
	NSDateComponents *components = COMPONENTS(self);
    [components setWeekday:1];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	return [CALENDAR_CURRENT dateFromComponents:components];
}

- (NSDate *)dateAtStartOfDay{
	NSDateComponents *components = COMPONENTS(self);
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	return [CALENDAR_CURRENT dateFromComponents:components];
}

- (NSDate *)dateAtStartOfDayWithHour:(NSInteger)hour{
	NSDateComponents *components = COMPONENTS(self);
	[components setHour:hour];
	[components setMinute:0];
	[components setSecond:0];
	return [CALENDAR_CURRENT dateFromComponents:components];
}

- (NSDate *)lastYear{
    NSDateComponents *components = COMPONENTS(self);
    [components setYear:self.year-1];
    [components setMonth:1];
    [components setDay:1];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
    return [CALENDAR_CURRENT dateFromComponents:components];
}

- (NSDate *)nextYear{
    NSDateComponents *components = COMPONENTS(self);
    [components setYear:self.year+1];
    [components setMonth:1];
    [components setDay:1];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
    return [CALENDAR_CURRENT dateFromComponents:components];
}

- (NSDate *)lastMonth{
    NSDateComponents *components = COMPONENTS(self);
    if(self.month == 1){
        [components setYear:self.year-1];
        [components setMonth:12];
    }else{
        [components setMonth:self.month-1];
    }
    [components setDay:1];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
    return [CALENDAR_CURRENT dateFromComponents:components];
}

- (NSDate *)nextMonth{
    NSDateComponents *components = COMPONENTS(self);
    if(self.month == 12){
        [components setYear:self.year+1];
        [components setMonth:1];
    }else{
        [components setMonth:self.month+1];
    }
    [components setDay:1];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
    return [CALENDAR_CURRENT dateFromComponents:components];
}

- (NSDate *) dateAtLastOfMonth{
    NSDateComponents *components = COMPONENTS(self);
    if(self.month == 1){
        [components setMonth:12];
        [components setYear:self.year-1];
    }else{
        [components setMonth:self.month-1];
    }
    
    [components setDay:1];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
    
    return [CALENDAR_CURRENT dateFromComponents:components];
}

- (NSDate *) dateAtNextOfMonth{
    NSDateComponents *components = COMPONENTS(self);
    if(self.month == 12){
        [components setMonth:1];
        [components setYear:self.year+1];
    }else{
        [components setMonth:self.month+1];
    }
    
    [components setDay:1];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
    
    return [CALENDAR_CURRENT dateFromComponents:components];
}

/**********************************************************************/
#pragma mark Retrieving Intervals
/**********************************************************************/

- (NSInteger)weeksAfterDate:(NSDate *)date{
	NSTimeInterval ti = [self timeIntervalSinceDate:date];
	return (NSInteger) (ti / D_WEEK);
}

- (NSInteger)weeksBeforeDate:(NSDate *)date{
	NSTimeInterval ti = [date timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_WEEK);
}

- (NSInteger)daysAfterDate:(NSDate *)date{
	NSTimeInterval ti = [self timeIntervalSinceDate:date];
	return (NSInteger) (ti / D_DAY);
}

- (NSInteger)daysBeforeDate:(NSDate *)date{
	NSTimeInterval ti = [date timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_DAY);
}

- (NSInteger)hoursAfterDate:(NSDate *)date{
	NSTimeInterval ti = [self timeIntervalSinceDate:date];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger)hoursBeforeDate:(NSDate *)date{
	NSTimeInterval ti = [date timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger)minutesAfterDate:(NSDate *)date{
	NSTimeInterval ti = [self timeIntervalSinceDate:date];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger)minutesBeforeDate:(NSDate *)date{
	NSTimeInterval ti = [date timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_MINUTE);
}

@end

@implementation NSDate (XTFormate)

static NSDateFormatter *dateFormatter = nil;
- (NSString *)stringWithFormate:(NSString *)formate{
    if(self.timeIntervalSince1970 == 0){
        return @"";
    }
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:formate];
    

    
    return [dateFormatter stringFromDate:self];
}

@end