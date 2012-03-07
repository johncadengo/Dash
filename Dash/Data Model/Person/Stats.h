//
//  Stats.h
//  Dash
//
//  Created by John Cadengo on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person;

@interface Stats : NSManagedObject

@property (nonatomic, retain) NSNumber * highlights;
@property (nonatomic, retain) NSNumber * recommends;
@property (nonatomic, retain) NSNumber * saves;
@property (nonatomic, retain) Person *person;

@end
