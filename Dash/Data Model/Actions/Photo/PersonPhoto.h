//
//  PersonPhoto.h
//  Dash
//
//  Created by John Cadengo on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Photo.h"

@class Person;

@interface PersonPhoto : Photo

@property (nonatomic, retain) Person *person;

@end
