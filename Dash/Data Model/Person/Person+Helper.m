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
+ (Person *)personWithFBResult:(id)result context:(NSManagedObjectContext *)context
{
    // The result of this query should only be one, and as such a dictionary
    NSDictionary *dict = (NSDictionary *)result;
    NSString *name = [dict objectForKey:@"name"];
    NSString *email = [dict objectForKey:@"email"];
    NSString *uid = [dict objectForKey:@"id"];
    
    Person *person = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"fb_uid == %@", uid];
    
    NSError *error = nil;
    person = [[context executeFetchRequest:request error:&error] lastObject];
    
    if (!error && !person) 
    {
        // if phone number can't be found, create new contact
        person = (Person *)[NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
        [person setName:name];
        [person setEmail:email];
        [person setFb_uid:uid];
    }
    
    // Saves the managed object context into the persistent store.
    [context save:&error];
    
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
