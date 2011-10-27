//
//  Hours.h
//  Dash
//
//  Created by John Cadengo on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Uniqueness.h"

@class Place;

@interface Hours : Uniqueness

@property (nonatomic, retain) NSNumber * close;
@property (nonatomic, retain) NSNumber * days;
@property (nonatomic, retain) NSNumber * open;
@property (nonatomic, retain) Place *place;

@end
