//
//  Person+Helper.h
//  Dash
//
//  Created by John Cadengo on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Person.h"
#import "FBConnect.h"

@class Like, FlagPlace, FlagPhoto, Comment, Pop;
@class Highlight, Save, Rate, Email, Visit, Place;

@interface Person (Helper)

+ (Person *)personWithFBResult:(id)result context:(NSManagedObjectContext *)context;

/** Saves a Place to this Person's list.
    
    TODO: Implement and write test case for it.
 */
- (void)save:(Place *)place;

/** Rate a Place with a rating.
 
    TODO: Implement and write test case for it.
 */
- (void)rate:(Place *)place withRating:(NSNumber *)rating;

/** Emails this Place's information to someone.
 
    TODO: Implement and write test case for it.
 */
- (void)email:(Place *)place;

/** Adds this Place to a Person's "Been Here" list.
 
    TODO: Implement and write test case for it.
 */
- (void)visit:(Place *)place;

- (NSURL *)photoURL;

@end
