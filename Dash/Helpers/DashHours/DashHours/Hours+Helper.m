//
//  Hours+Helper.m
//  DashHours
//
//  Created by Andrew Park on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Hours+Helper.h"

@implementation Hours (Helper)

/**Pumps out the days of the week in 2 formats.  A(discrete: M,Tu,W,Th) B(condensed:M-Th) in this format: M,Tu,W,Th/M-Th*/
- (NSString *)twoFormatDays
{
    NSUInteger days = [self.days intValue];
    
    
    //most common day intervals first
    if(days == 127)
    {
        return @"Mon, Tue, Wed, Thu, Fri, Sat, Sun/Mon-Sun";
    }
    else if(days == 124)
    {
        return @"Mon, Tue, Wed, Thu, Fri/Mon-Fri";   
    }
    else if(days == 3)
    {
        return @"Sat, Sun/Sat-Sun";
    }
    else if(days == 120)
    {
        return @"Mon, Tue, Wed, Thu/Mon-Thu";
    }
    else if(days == 7)
    {
        return @"Fri, Sat, Sun/Fri-Sun";
    }
    else if(days == 112)
    {
        return @"Mon, Tue, Wed/Mon-Wed";
    }
    else if(days == 15)
    {
        return @"Thu, Fri, Sat, Sun/Thu-Sun";
    }
    else if(days == 6)
    {
        return @"Fri, Sat/Fri-Sat";
    }
    else if(days == 122)
    {
        return @"Mon, Tue, Wed, Thu, Sat/Mon-Thu, Sat";
    }
    else if(days == 121)
    {
        return @"Mon, Tue, Wed, Thu, Sun/Mon-Thu, Sun";
    }
    else if(days == 62)
    {
        return @"Tue, Wed, Thu, Fri, Sat/Tue-Sat";
    }
    else if(days == 61)
    {
        return @"Tue, Wed, Thu, Fri, Sun/Tue-Fri, Sun";
    }
    else if(days == 126)
    {
        return @"Mon, Tue, Wed, Thu, Fri, Sat/Mon-Sat";
    }
    else if(days == 125)
    {
        return @"Mon, Tue, Wed, Thu, Fri, Sun/Mon-Fri, Sun";
    }
    else if(days == 63)
    {
        return @"Tue, Wed, Thu, Fri, Sat, Sun/Tue-Sun";
    }
    //End of Common Day Intervals
    
    
    // 1. 7/7
    else if(days == 64)
    {
        return @"Mon";
    }
    else if(days == 32)
    {
        return @"Tue";
    }
    else if(days == 16)
    {
        return @"Wed";
    }
    else if(days == 8)
    {
        return @"Thu";
    }
    else if(days == 4)
    {
        return @"Fri";
    }
    else if(days == 2)
    {
        return @"Sat";
    }
    else if(days == 1)
    {
        return @"Sun";
    }
    
    // 2. (bottom: 19) + (top:2) = 21/21 
    else if(days == 96)
    {
        return @"Mon, Tue/Mon-Tue";
    }
    else if(days == 80)
    {
        return @"Mon, Wed";
    }
    else if(days == 72)
    {
        return @"Mon, Thu";
    }
    else if(days == 68)
    {
        return @"Mon, Fri";
    }
    else if(days == 66)
    {
        return @"Mon, Sat";
    }
    else if(days == 65)
    {
        return @"Mon, Sun/Sun-Mon";
    }
    else if(days == 48)
    {
        return @"Tue, Wed/Tue-Wed";
    }
    else if(days == 40)
    {
        return @"Tue, Thu";
    }
    else if(days == 36)
    {
        return @"Tue, Fri";
    }
    else if(days == 34)
    {
        return @"Tue, Sat";
    }
    else if(days == 33)
    {
        return @"Tue, Sun";
    }
    else if(days == 24)
    {
        return @"Wed, Thu/Wed-Thu";
    }
    else if(days == 20)
    {
        return @"Wed, Fri";
    }
    else if(days == 18)
    {
        return @"Wed, Sat";
    }
    else if(days == 17)
    {
        return @"Wed, Sun";
    }
    else if(days == 12)
    {
        return @"Thu, Fri/Thu-Fri";
    }
    else if(days == 10)
    {
        return @"Thu, Sat";
    }
    else if(days == 9)
    {
        return @"Thu, Sun";
    }
    else if(days == 5)
    {
        return @"Fri, Sun";
    }
    
    //3. (Bottom: 33) + (Top:2) = 35/35
    else if(days == 104)
    {
        return @"Mon, Tue, Thu/Mon-Tue, Thur";
    }
    else if(days == 100)
    {
        return @"Mon, Tue, Fri/Mon-Tue, Fri";
    }
    else if(days == 98)
    {
        return @"Mon, Tue, Sat/Mon-Tue, Sat";
    }
    else if(days == 97)
    {
        return @"Mon, Tue, Sun/Mon-Tue, Sun";
    }
    else if(days == 88)
    {
        return @"Mon, Wed, Thu/Mon, Wed-Thu";
    }
    else if(days == 84)
    {
        return @"Mon, Wed, Fri";
    }
    else if(days == 82)
    {
        return @"Mon, Wed, Sat";
    }
    else if(days == 81)
    {
        return @"Mon, Wed, Sun";
    }
    else if(days == 76)
    {
        return @"Mon, Thu, Fri/Mon, Thu-Fri";
    }
    else if(days == 74)
    {
        return @"Mon, Thu, Sat";
    }
    else if(days == 73)
    {
        return @"Mon, Thu, Sun";
    }
    else if(days == 70)
    {
        return @"Mon, Fri, Sat/Mon, Fri-Sat";
    }
    else if(days == 69)
    {
        return @"Mon, Fri, Sun";
    }
    else if(days == 67)
    {
        return @"Mon, Sat, Sun/Mon, Sat-Sun";
    }
    else if(days == 56)
    {
        return @"Tue, Wed, Thu/Tue-Thu";
    }
    else if(days == 52)
    {
        return @"Tue, Wed, Fri/Tue-Wed, Fri";
    }
    else if(days == 50)
    {
        return @"Tue, Wed, Sat/Tue-Wed, Sat";
    }
    else if(days == 49)
    {
        return @"Tue, Wed, Sun/Tue-Wed, Sun";
    }
    else if(days == 44)
    {
        return @"Tue, Thu, Fri/Tue, Thu-Fri";
    }
    else if(days == 42)
    {
        return @"Tue, Thur, Sat";
    }
    else if(days == 41)
    {
        return @"Tue, Thu, Sun";
    }
    else if(days == 38)
    {
        return @"Tue, Fri, Sat";
    }
    else if(days == 37)
    {
        return @"Tue, Fri, Sun";
    }
    else if(days == 35)
    {
        return @"Tue, Sat, Sun/Tue, Sat-Sun";
    }
    else if(days == 28)
    {
        return @"Wed, Thu, Fri/Wed-Fri";
    }
    else if(days == 26)
    {
        return @"Wed, Thu, Sat/Wed-Thu, Sat";
    }
    else if(days == 25)
    {
        return @"Wed, Thu, Sun/Wed-Thu, Sun";
    }
    else if(days == 22)
    {
        return @"Wed, Fri, Sat/Wed, Fri-Sat";
    }
    else if(days == 21)
    {
        return @"Wed, Fri, Sun";
    }
    else if(days == 19)
    {
        return @"Wed, Sat, Sun/Wed, Sat-Sun";
    }
    else if(days == 14)
    {
        return @"Thu, Fri, Sat/Thu-Sat";
    }
    else if(days == 13)
    {
        return @"Thu, Fri, Sun/Thu-Fri, Sun";
    }
    else if(days == 11)
    {
        return @"Thu, Sat, Sun/Thu, Sat-Sun";
    }
    
    //4. (Bottom: 33) + (Top:2) = 35/35
    else if(days == 116)
    {
        return @"Mon, Tue, Wed, Fri/Mon-Wed, Fri";
    }
    else if(days == 114)
    {
        return @"Mon, Tue, Wed, Sat/Mon-Wed, Sat";
    }
    else if(days == 113)
    {
        return @"Mon, Tue, Wed, Sun/Mon-Wed, Sun";
    }
    else if(days == 108)
    {
        return @"Mon, Tue, Thu, Fri/Mon-Tue, Thu-Fri";
    }
    else if(days == 106)
    {
        return @"Mon, Tue, Thu, Sat/Mon-Tue, Thu, Sat";
    }
    else if(days == 105)
    {
        return @"Mon, Tue, Thu, Sun/Mon-Tue, Thu, Sun";
    }
    else if(days == 102)
    {
        return @"Mon, Tue, Fri, Sat/Mon-Tue, Fri-Sat";
    }
    else if(days == 101)
    {
        return @"Mon, Tue, Fri, Sun/Mon-Tue, Fri, Sun";
    }
    else if(days == 99)
    {
        return @"Mon, Tue, Sat, Sun/Mon-Tue, Sat-Sun";
    }
    else if(days == 92)
    {
        return @"Mon, Wed, Thu, Fri/Mon, Wed-Fri";
    }
    else if(days == 90)
    {
        return @"Mon, Wed, Thu, Sat/ Mon, Wed-Thu, Sat";
    }
    else if(days == 89)
    {
        return @"Mon, Wed, Thu, Sun/Mon, Wed-Thu, Sun";
    }
    else if(days == 86)
    {
        return @"Mon, Wed, Fri, Sat/Mon, Wed, Fri-Sat";
    }
    else if(days == 85)
    {
        return @"Mon, Wed, Fri, Sun";
    }
    else if(days == 83)
    {
        return @"Mon, Wed, Sat, Sun/Mon, Wed, Sat-Sun";
    }
    else if(days == 78)
    {
        return @"Mon, Thu, Fri, Sat/Mon, Thu-Sat";
    }
    else if(days == 77)
    {
        return @"Mon, Thu, Fri, Sun/Mon, Thu-Fri, Sun";
    }
    else if(days == 75)
    {
        return @"Mon, Thu, Sat, Sun/Mon, Thu, Sat-Sun";
    }
    else if(days == 71)
    {
        return @"Mon, Fri, Sat, Sun/Mon, Fri-Sun";
    }
    else if(days == 60)
    {
        return @"Tue, Wed, Thu, Fri/Tue-Fri";
    }
    else if(days == 58)
    {
        return @"Tue, Wed, Thu, Sat/Tue-Thu, Sat";
    }
    else if(days == 57)
    {
        return @"Tue, Wed, Thu, Sun/Tue-Thu, Sun";
    }
    else if(days == 54)
    {
        return @"Tue, Wed, Fri, Sat/Tue-Wed, Fri-Sat";
    }
    else if(days == 53)
    {
        return @"Tue, Wed, Fri, Sun/Tue-Wed, Fri, Sun";
    }
    else if(days == 51)
    {
        return @"Tue, Wed, Sat, Sun/Tue-Wed, Sat-Sun";
    }
    else if(days == 46)
    {
        return @"Tue, Thu, Fri, Sat/ Tue, Thu-Sat";
    }
    else if(days == 45)
    {
        return @"Tue, Thu, Fri, Sun/Tues, Thu-Fri, Sun";
    }
    else if(days == 43)
    {
        return @"Tue, Thu, Sat, Sun/Tue, Thu, Sat-Sun";
    }
    else if(days == 39)
    {
        return @"Tue, Fri, Sat, Sun/Tues, Fri-Sun";
    }
    else if(days == 30)
    {
        return @"Wed, Thu, Fri, Sat/Wed-Sat";
    }
    else if(days == 29)
    {
        return @"Wed, Thu, Fri, Sun/Wed-Fri, Sun";
    }
    else if(days == 27)
    {
        return @"Wed, Thu, Sat, Sun/Wed-Thu Sat-Sun";
    }
    else if(days == 23)
    {
        return @"Wed, Fri, Sat, Sun/Wed, Fri-Sun";
    }
    
    //5. (Bottom:16) + (Top:5) = /21
    else if(days == 118)
    {
        return @"Mon, Tue, Wed, Fri, Sat/Mon-Wed, Fri-Sat";
    }
    else if(days == 117)
    {
        return @"Mon, Tue, Wed, Fri, Sun/Mon-Wed, Fri, Sun";
    }
    else if(days == 115)
    {
        return @"Mon, Tue, Wed, Sat, Sun/Mon-Wed, Sat-Sun";
    }
    else if(days == 110)
    {
        return @"Mon, Tue, Thu, Fri, Sat/Mon-Tue, Thu-Sat";
    }
    else if(days == 109)
    {
        return @"Mon, Tue, Thu, Fri, Sun/Mon-Tue, Thu-Fri, Sun";
    }
    else if(days == 107)
    {
        return @"Mon, Tue, Thu, Sat, Sun/Mon-Tue, Thu, Sat-Sun";
    }
    else if(days == 103)
    {
        return @"Mon, Tue, Fri, Sat, Sun/Mon-Tue, Fri-Sun";
    }
    else if(days == 94)
    {
        return @"Mon, Wed, Thu, Fri, Sat/Mon, Wed-Sat";
    }
    else if(days == 93)
    {
        return @"Mon, Wed, Thu, Fri, Sun/Mon, Wed-Fri, Sun";
    }
    else if(days == 87)
    {
        return @"Mon, Wed, Fri, Sat, Sun/Mon, Wed, Fri-Sun";
    }
    else if(days == 91)
    {
        return @"Mon, Wed, Thu, Sat, Sun/Mon, Wed-Thu, Sun-Sun";
    }
    else if(days == 79)
    {
        return @"Mon, Thu, Fri, Sat, Sun/Mon, Thu-Sun";
    }
    else if(days == 59)
    {
        return @"Tue, Wed, Thu, Sat, Sun/Tue-Thu, Sat-Sun";
    }
    else if(days == 55)
    {
        return @"Tue, Wed, Fri, Sat, Sun/Tue-Wed, Fri-Sun";
    }
    else if(days == 47)
    {
        return @"Tue, Thu, Fri, Sat, Sun/Tue, Thu-Sun";
    }
    else if(days == 31)
    {
        return @"Wed, Thu, Fri, Sat, Sun/Wed-Sun";
    }
    
    //6. (Bottom:4) + (Top:3) = 7/7
    else if(days == 95)
    {
        return @"Mon, Wed, Thu, Fri, Sat, Sun/Mon, Wed-Sun";
    }
    else if(days == 111)
    {
        return @"Mon, Tue, Thu, Fri, Sat, Sun/Mon-Tue, Thu-Sun";
    }
    else if(days == 119)
    {
        return @"Mon, Tue, Wed, Fri, Sat, Sun/Mon-Wed, Fri-Sun";
    }
    else if(days == 123)
    {
        return @"Mon, Tue, Wed, Thu, Sat, Sun/Mon-Thu, Sat-Sun";
    }

    //if no days are open
    else if(days == 0)
    {
        return @"";
    }
    
    return @"FAIL";
}

/** Pumps out the days of the week that these hours apply in human readable format, i.e. "M-Th", "M,W,F", etc.
 */
- (NSString *)weekdays
{
    //gather the days
    NSString *day;
    day = [self twoFormatDays];
    
    //check if there is a dash
    //if there is not, return the human-readable day(s)
    if([day rangeOfString:@"/"].location == NSNotFound)
    {
        return day;
    }
    //if there is a dash, parse and return the string after the dash
    else 
    {
        NSArray *stringHolder = [day componentsSeparatedByString:@"/"];
        NSString *afterDash = [stringHolder objectAtIndex:1];
        return afterDash;
    }    

    return @"this failed";
}

- (BOOL)openOnDate:(NSDate *)date
{
    
    // Probably want to move openToday into here and then call [self openOnDate:[NSDate date]] there.
    
    
    
    //Convert nsdate to an actual day (ie. monday, wednesday, saturday etc)
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];  
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *today = [dateFormatter stringFromDate:date]; 
    
    //find out what days the restaurant is open
    NSString *day;
    day = [self twoFormatDays];
    
    //check if there is a dash
    //if there is, keep the expanded (Mon, Tues, Wed  vs Mon-Wed) human-readable day(s)
    if(!([day rangeOfString:@"/"].location == NSNotFound))
    {
        NSArray *stringHolder = [day componentsSeparatedByString:@"/"];
        day = [stringHolder objectAtIndex:0];
    }
    
    //see if today is open 
    if([today isEqualToString:@"Monday"])
    {
        if([day rangeOfString:@"Mon"].location == NSNotFound)
        {
            return FALSE;
        }
        else 
        {
            return TRUE;
        }
    }
    else if([today isEqualToString:@"Tuesday"])
    {
        if([day rangeOfString:@"Tue"].location == NSNotFound)
        {
            return FALSE;
        }
        else 
        {
            return TRUE;
        }  
    }
    else if([today isEqualToString:@"Wednesday"])
    {
        if([day rangeOfString:@"Wed"].location == NSNotFound)
        {
            return FALSE;
        }
        else 
        {
            return TRUE;
        }
    }
    else if([today isEqualToString:@"Thursday"])
    {
        if([day rangeOfString:@"Thu"].location == NSNotFound)
        {
            return FALSE;
        }
        else 
        {
            return TRUE;
        }
    }
    else if([today isEqualToString:@"Friday"])
    {
        if([day rangeOfString:@"Fri"].location == NSNotFound)
        {
            return FALSE;
        }
        else 
        {
            return TRUE;
        }
    }
    else if([today isEqualToString:@"Saturday"])
    {
        if([day rangeOfString:@"Sat"].location == NSNotFound)
        {
            return FALSE;
        }
        else 
        {
            return TRUE;
        }
    }
    else if([today isEqualToString:@"Sunday"])
    {
        if([day rangeOfString:@"Sun"].location == NSNotFound)
        {
            return FALSE;
        }
        else 
        {
            return TRUE;
        }
    }
    
    
    return YES;
}

/** Returns YES if the restaurant is open today, even if it is not necessarily open now.
 */
- (BOOL)openToday
{
    //What Day is it today?
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];  
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *today = [dateFormatter stringFromDate:[NSDate date]];    
    
    //find out what days the restaurant is open
    NSString *day;
    day = [self twoFormatDays];
    
    //check if there is a dash
    //if there is, keep the expanded (Mon, Tues, Wed  vs Mon-Wed) human-readable day(s)
    if(!([day rangeOfString:@"/"].location == NSNotFound))
    {
        NSArray *stringHolder = [day componentsSeparatedByString:@"/"];
        day = [stringHolder objectAtIndex:0];
    }
    
    
    //see if today is open 
    if([today isEqualToString:@"Monday"])
    {
        if([day rangeOfString:@"Mon"].location == NSNotFound)
        {
            return FALSE;
        }
        else 
        {
            return TRUE;
        }
    }
    else if([today isEqualToString:@"Tuesday"])
    {
        if([day rangeOfString:@"Tue"].location == NSNotFound)
        {
            return FALSE;
        }
        else 
        {
            return TRUE;
        }  
    }
    else if([today isEqualToString:@"Wednesday"])
    {
        if([day rangeOfString:@"Wed"].location == NSNotFound)
        {
            return FALSE;
        }
        else 
        {
            return TRUE;
        }
    }
    else if([today isEqualToString:@"Thursday"])
    {
        if([day rangeOfString:@"Thu"].location == NSNotFound)
        {
            return FALSE;
        }
        else 
        {
            return TRUE;
        }
    }
    else if([today isEqualToString:@"Friday"])
    {
        if([day rangeOfString:@"Fri"].location == NSNotFound)
        {
            return FALSE;
        }
        else 
        {
            return TRUE;
        }
    }
    else if([today isEqualToString:@"Satday"])
    {
        if([day rangeOfString:@"Sat"].location == NSNotFound)
        {
            return FALSE;
        }
        else 
        {
            return TRUE;
        }
    }
    else if([today isEqualToString:@"Sunday"])
    {
        if([day rangeOfString:@"Sun"].location == NSNotFound)
        {
            return FALSE;
        }
        else 
        {
            return TRUE;
        }
    }
    
    
    return YES;
}

- (BOOL)openAtTime:(NSDate *)date
{
    
    //Find out what time it is: store it in variable "currentTime"    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    NSString *currentTime = [dateFormatter stringFromDate:date];
    
    //get rid of the colon to match formatting of our restaurant database
    currentTime = [currentTime stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSInteger currentTimeInt = [currentTime intValue];
    
    //find out what time the restaurant opens and closes
    NSInteger timeOpen = [self.open intValue];
    NSInteger timeClose = [self.close intValue];
    
    
    //if spot is open 24 hours then it is open
    if((timeClose - timeOpen == 0) || (timeClose - timeOpen == 2400))
    {
        return TRUE;
    }
    
    //if error input (time is over 2400 or negative)
    if(timeClose>2400 || timeClose<0 || timeOpen > 2400 || timeOpen<0)
    {
        return FALSE;
    }
    
    //check if the close time spills over to the next day (3am in the morning)
    if((timeClose - timeOpen) < 0)
    {
        if((currentTimeInt < timeClose) || (currentTimeInt > timeOpen))
        {
            return TRUE;
        }
        else 
        {
            return FALSE;
        }
    }
    
    //check if the current time is in between the open and close time
    if((timeOpen <= currentTimeInt)  && (timeClose > currentTimeInt))
    {
        return TRUE;
    }
    else 
    {
        return FALSE;
    }
}

- (BOOL)openSoon
{
    NSDate *now = [NSDate date];
    NSTimeInterval anHour = 60 * 60;
    return [self openAtTime:[now dateByAddingTimeInterval:anHour]];
}

/** Returns YES if the restaurant is currently open.
 */
- (BOOL)openNow
{
    //Check if it's within our current time
    return [self openAtTime:[NSDate date]];
}

/** This is the string we will display in dash, i.e. "M-Th 9am - 1130am"
 */
- (NSString *)description
{
    
    //gather the days that the restaurant is open
    NSString *days;
    days = [self weekdays];
    
    //open time and close time of restaurant
    NSString *openHour;
    NSString *closeHour;
    
    //find out what time the restaurant opens and closes
    NSInteger timeOpen = [self.open intValue];
    NSInteger timeClose = [self.close intValue];
    
    //if spot is open 24 hours
    if((timeClose - timeOpen == 0) || (timeClose - timeOpen == 2400))
    {
        return [NSString stringWithFormat:@"%@ 24 Hours", days];
        //hours = @"24 Hours";
    }
    
    //if error input (time is over 2400 or negative)
    if(timeClose>2400 || timeClose<0 || timeOpen > 2400 || timeOpen<0)
    {
        return @"Hours Unavailable";
    }
    
    
    

    openHour = [self openTime];
    closeHour = [self closeTime];



     
    return [NSString stringWithFormat:@"%@ %@ - %@", days, openHour, closeHour];
}
/** Human readable open time i.e. self.open == 1000 means "10:00am"
 */
- (NSString *)openTime
{
    NSMutableString *openHour;
    
    NSInteger timeOpen = [self.open intValue];

    //12:00am - 12:59am
    if(timeOpen < 60)
    {
        timeOpen = 1200 + timeOpen;
        openHour = [NSMutableString stringWithFormat:@"%d", timeOpen];
        [openHour appendString:@"am"];
    }
    //1am - 11:59am
    else if(timeOpen >= 100 && timeOpen <1200)
    {
        openHour = [NSMutableString stringWithFormat:@"%d", timeOpen];
        [openHour appendString:@"am"];
    }
    //12pm-12:59pm
    else if(timeOpen >= 1200 && timeOpen <1300)
    {
        openHour = [NSMutableString stringWithFormat:@"%d", timeOpen];
        [openHour appendString:@"pm"];
    }
    //1pm-11:59pm
    else if(timeOpen >= 1300 && timeOpen < 2400)
    {
        timeOpen = timeOpen - 1200;
        openHour = [NSMutableString stringWithFormat:@"%d", timeOpen];
        [openHour appendString:@"pm"];
    }
    //another way of saying 12am
    else if(timeOpen == 2400)
    {
        openHour = [NSMutableString stringWithFormat:@"1200am"];
    }
    else 
    {
        return @"Hours Unavailable";
    }
    
    //add ":" to format time
    [openHour insertString:@":" atIndex:[openHour length] - 4];

    return openHour;
}

- (NSString *)closeTime
{
    NSMutableString *closeHour;

    NSInteger timeClose = [self.close intValue];

    if(timeClose < 60)
    {
        timeClose = 1200 + timeClose;
        closeHour = [NSMutableString stringWithFormat:@"%d", timeClose];
        [closeHour appendString:@"am"];
        
    }
    else if(timeClose >= 100 && timeClose <1200)
    {
        closeHour = [NSMutableString stringWithFormat:@"%d", timeClose];
        [closeHour appendString:@"am"];
    }
    else if(timeClose >= 1200 && timeClose <1300)
    {
        closeHour = [NSMutableString stringWithFormat:@"%d", timeClose];
        [closeHour appendString:@"pm"];
    }
    else if(timeClose >= 1300 && timeClose <2400)
    {
        timeClose = timeClose - 1200;
        closeHour = [NSMutableString stringWithFormat:@"%d", timeClose];
        [closeHour appendString:@"pm"];
    }
    else if(timeClose == 2400)
    {
        closeHour = [NSMutableString stringWithFormat:@"1200am"];
    }
    else 
    {
        return @"Hours Unavailable";
    }
    
    //add ":" to format string
    [closeHour insertString:@":" atIndex:[closeHour length] - 4];

    return closeHour;
}

- (NSComparisonResult)compare:(id)otherObject
{
    // TODO:
    // Return NSOrderedSame if close times are the same
    // NSOrderedAscending if self < other's close time
    // NSOrderedDescending if self > other

    Hours *otherHours = (Hours *)otherObject;
    return [self.closeTime compare:otherHours.closeTime];
}

@end
