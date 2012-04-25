//
//  Person+Helper.m
//  Dash
//
//  Created by John Cadengo on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Person+Helper.h"

@implementation Person (Helper)

/**
 {
 email = "akagodchild@hotmail.com";
 "first_name" = Ab;
 gender = male;
 id = 100002015691327;
 "last_name" = Ko;
 link = "http://www.facebook.com/profile.php?id=100002015691327";
 locale = "en_US";
 name = "Ab Ko";
 timezone = "-4";
 "updated_time" = "2012-04-23T15:46:06+0000";
 }
 */
+ (id)personWithFBResult:(id)result context:(NSManagedObjectContext *)context
{
    // The result of this query should only be one, and as such a dictionary
    NSDictionary *dict = (NSDictionary *)result;
    
    // TODO: Check if the person is already stored in our database
    Person *person = (Person *)[NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    
    NSString *name = [dict objectForKey:@"name"];
    NSString *email = [dict objectForKey:@"email"];
    NSString *uid = [dict objectForKey:@"id"];
    
    [person setName:name];
    [person setEmail:email];
    [person setFb_uid:uid];
    
    // Saves the managed object context into the persistent store.
    NSError *saveError = nil; 
    [context save:&saveError];
    
    return person;
}

- (void)save:(Place *)place
{
    
}

- (void)rate:(Place *)place withRating:(NSNumber *)rating
{
    
}

- (void)email:(Place *)place
{
    
}

- (void)visit:(Place *)place
{
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", self.name];
    //return [NSString stringWithFormat:@"%@ %@ %@", self.email, self.name, self.fb_uid];
}

@end
