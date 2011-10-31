//
//  Footprint.h
//  Dash
//
//  Created by John Cadengo on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Action;

@interface Footprint : NSObject

@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) NSString *blurb;
@property (nonatomic, strong) NSString *longago;

/** Don't call this. Won't do anything useful.
 */
- (id)init;

/** Figures out what kind of Action object it is: Photo, Highlight, Comment, etc.
    And fills in all the public ivars necessary to display the Footprint.
 */
- (id)initWithAction:(Action*) action;

@end
