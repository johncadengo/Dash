//
//  Location.h
//  Dash
//
//  Created by John Cadengo on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Uniqueness.h"


@interface Location : Uniqueness

@property (nonatomic, retain) NSNumber * cos_rad_lat;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * rad_lat;
@property (nonatomic, retain) NSNumber * rad_lng;
@property (nonatomic, retain) NSNumber * sin_rad_lat;

@end
