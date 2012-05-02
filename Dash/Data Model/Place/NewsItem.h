//
//  NewsItem.h
//  Dash
//
//  Created by John Cadengo on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person, Place;

@interface NewsItem : NSManagedObject

@property (nonatomic, retain) NSString * blurb;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) Place *place;
@property (nonatomic, retain) Person *author;

@end
