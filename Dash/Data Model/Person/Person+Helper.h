//
//  Person+Helper.h
//  Dash
//
//  Created by John Cadengo on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Person.h"

@class Like, FlagPlace, FlagPhoto, Comment, Pop;
@class Highlight, Save, Rate, Email, Visit, Place;

@interface Person (Helper)

-(void)save:(Place *)place;
-(void)rate:(Place *)place withRating:(NSNumber *)rating;
-(void)email:(Place *)place;
-(void)visit:(Place *)place;

@end
