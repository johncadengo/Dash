//
//  Like.h
//  Dash
//
//  Created by John Cadengo on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Action.h"

@class Action;

@interface Like : Action

@property (nonatomic, retain) Action *action;

@end