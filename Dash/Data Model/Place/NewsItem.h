//
//  NewsItem.h
//  Dash
//
//  Created by John Cadengo on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place;

@interface NewsItem : NSManagedObject

@property (nonatomic, retain) NSString * blurb;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) Place *place;

@end
