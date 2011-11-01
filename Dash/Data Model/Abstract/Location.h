//
//  Location.h
//  Dash
//
//  Created by John Cadengo on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Uniqueness.h"


@interface Location : Uniqueness

@property (nonatomic) double cosRadLat;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) double radLat;
@property (nonatomic) double radLng;
@property (nonatomic) double sinRadLat;

@end
