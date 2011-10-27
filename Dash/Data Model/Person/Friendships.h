//
//  Friendships.h
//  Dash
//
//  Created by John Cadengo on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Action.h"

@class Person;

@interface Friendships : Action

@property (nonatomic, retain) NSNumber * confirmed;
@property (nonatomic, retain) Person *source;

@end
