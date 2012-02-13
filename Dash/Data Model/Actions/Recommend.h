//
//  Recommend.h
//  Dash
//
//  Created by John Cadengo on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person, Place;

@interface Recommend : NSManagedObject

@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) Place *place;
@property (nonatomic, retain) Person *from;
@property (nonatomic, retain) Person *to;

@end
