//
//  Location.h
//  Dash
//
//  Created by John Cadengo on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Location : NSManagedObject

@property (nonatomic, retain) NSNumber * cosRadLat;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * radLat;
@property (nonatomic, retain) NSNumber * radLng;
@property (nonatomic, retain) NSNumber * sinRadLat;

@end
