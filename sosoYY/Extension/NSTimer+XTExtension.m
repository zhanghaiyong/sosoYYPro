//
//  NSTimer+XTExtension.m
//  XTFramework
//
//  Created by Qing Xiubin on 13-8-15.
//  Copyright (c) 2013年 XT. All rights reserved.
//

#import "NSTimer+XTExtension.h"
#import <objc/runtime.h>

static NSString *kIsPausedKey				= @"BS IsPaused Key";
static NSString *kRemainingTimeIntervalKey	= @"BS RemainingTimeInterval Key";

@interface NSTimer (Private)

- (NSMutableDictionary *)pauseDictionary;

@end


@implementation NSTimer (Private)

- (NSMutableDictionary *)pauseDictionary{
    
	// Create a global dictionary for all instances
	static NSMutableDictionary *globalDictionary = nil;
	if (!globalDictionary) {
		globalDictionary = [[NSMutableDictionary alloc] init];
    }
	
	// Create a local dictionary for this instance
    NSNumber *localDictionaryKey = [NSNumber numberWithInt:(int)self];
    NSMutableDictionary *localDictionary = [globalDictionary objectForKey:localDictionaryKey];
	if (!localDictionary) {
        localDictionary = [NSMutableDictionary dictionary];
		[globalDictionary setObject:localDictionary forKey:localDictionaryKey];
	}
	
	// Return the local dictionary
	return localDictionary;
}

@end


@implementation NSTimer (XTExtension)
@dynamic name;

- (NSString *)name{
	NSObject * obj = objc_getAssociatedObject( self, "NSTimer.name" );
	if ( obj && [obj isKindOfClass:[NSString class]] )
		return (NSString *)obj;
    
	return nil;
}

- (void)setName:(NSString *)name{
	objc_setAssociatedObject( self, "NSTimer.name", name, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (void)pause{
	// Prevent invalid timers from being paused
	if (![self isValid]) {
		return;
    }
    NSMutableDictionary *pauseDictionary = [self pauseDictionary];
	
	// Prevent paused timers from being paused again
	NSNumber *isPausedNumber = [pauseDictionary objectForKey:kIsPausedKey];
	if(isPausedNumber && YES == [isPausedNumber boolValue]){
		return;
    }
	
	// Calculate remaining time interval
	NSDate *now		= [NSDate date];
	NSDate *then	= [self fireDate];
	NSTimeInterval remainingTimeInterval = [then timeIntervalSinceDate:now];
	NSNumber *remainingTimeNumber = [NSNumber numberWithDouble:remainingTimeInterval];
	
	// Store remaining time interval
	[pauseDictionary setObject:remainingTimeNumber forKey:kRemainingTimeIntervalKey];
	
	// Pause timer
	[self setFireDate:[NSDate distantFuture]];
	[pauseDictionary setObject:@YES forKey:kIsPausedKey];
}

- (void)resume{
	// Prevent invalid timers from being resumed
	if(![self isValid]){
		return;
    }
    NSMutableDictionary *pauseDictionary = [self pauseDictionary];
	
	// Prevent paused timers from being paused again
	NSNumber *isPausedNumber = [pauseDictionary objectForKey:kIsPausedKey];
	if(!isPausedNumber || NO == [isPausedNumber boolValue]){
		return;
    }
	
	// Load remaining time interval
	NSNumber *remainingTimeNumber = [pauseDictionary objectForKey:kRemainingTimeIntervalKey];
	NSTimeInterval remainingTimeInterval = [remainingTimeNumber doubleValue];
	
	// Calculate new fire date
	NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:remainingTimeInterval];
	
	// Resume timer
	[self setFireDate:fireDate];
	[pauseDictionary setObject:@NO forKey:kIsPausedKey];
}

@end
