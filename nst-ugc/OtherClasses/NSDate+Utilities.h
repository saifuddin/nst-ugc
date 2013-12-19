//
//  NSDate+Utilities.h
//  nst-ugc
//
//  Created by saifuddin on 19/12/13.
//  Copyright (c) 2013 saifuddin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utilities)
+ (NSString *)relativeStringFromDate:(NSDate *)date;
+ (BOOL)date:(NSDate *)date isDayWithTimeIntervalSinceNow:(NSTimeInterval)interval;
+ (BOOL)dateIsToday:(NSDate *)date;
+ (BOOL)dateIsYesterday:(NSDate *)date;
+ (BOOL)dateIsTwoToSixDaysAgo:(NSDate *)date;
+ (NSString *)dateAsStringDate:(NSDate *)date;
+ (NSString *)dateAsStringTime:(NSDate *)date;
+ (NSString *)dateAsStringDay:(NSDate *)date;
@end
