//
//  PlaceLocation.h
//  Dash
//
//  Created by John Cadengo on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Location.h"

@class Place;

@interface PlaceLocation : Location

@property (nonatomic, retain) Place *place;

@end
