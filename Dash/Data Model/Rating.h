//
//  Rating.h
//  Dash
//
//  Created by John Cadengo on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place;

@interface Rating : NSManagedObject

@property (nonatomic, retain) NSString * stars;
@property (nonatomic, retain) Place *place;
@property (nonatomic, retain) NSManagedObject *person;

@end
