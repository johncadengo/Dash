//
//  Abstract.h
//  Dash
//
//  Created by John Cadengo on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Action.h"

@class Place;

@interface Abstract : Action

@property (nonatomic, retain) Place *place;

@end
