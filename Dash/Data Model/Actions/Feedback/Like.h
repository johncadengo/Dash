//
//  Like.h
//  Dash
//
//  Created by John Cadengo on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Action.h"

@class Action, Highlight;

@interface Like : Action

@property (nonatomic, retain) Action *action;
@property (nonatomic, retain) Highlight *highlight;

@end
