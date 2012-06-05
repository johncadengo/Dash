//
//  Hours+Helper.h
//  DashHours
//
//  Created by John Cadengo on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Hours.h"

// Values of the individual days as powers of two
typedef enum {
    kMonday = 64,
    kTuesday = 32,
    kWednesday = 16,
    kThursday = 8,
    kFriday = 4,
    kSaturday = 2,
    kSunday = 1,
} DashDay;

@interface Hours (Helper)

/**Pumps out the days of the week in 2 formats.  A(discrete: M,Tu,W,Th) B(condensed:M-Th) in this format: M,Tu,W,Th/M-Th
 */
- (NSString *)twoFormatDays;

/** Pumps out the days of the week that these hours apply in human readable format, i.e. "M-Th", "M,W,F", etc.
 */
- (NSString *)weekdays;

/** Returns YES if the restaurant is open on that day.
 */
- (BOOL)openOnDate:(NSDate *)date;

/** Returns YES if the restaurant is open today, even if it is not necessarily open now.
 */
- (BOOL)openToday;

/** Returns YES if the restaurant is open during this time specifically.
 */
- (BOOL)openAtTime:(NSDate *)date;

/** Returns YES if the restaurant is open soon, within the next hour or so.
 */
- (BOOL)openSoon;

/** Returns YES if the restaurant is currently open.
 */
- (BOOL)openNow;

/** This is the string we will display in dash, i.e. "M-Th 9am-1130am, 2-5pm"
 */
- (NSString *)description;

/** Human readable open time i.e. self.open == 1000 means "10:00am"
 */
- (NSString *)openTime;

/** Human readable close time i.e. self.close == 1000 means "10:00am"
 */
- (NSString *)closeTime;

/** Based on close time.
 */
- (NSComparisonResult)compare:(id)otherObject;

@end
