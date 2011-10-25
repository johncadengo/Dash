//
//  DashTests.h
//  DashTests
//
//  Created by John Cadengo on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class DashAPI;

/** Handles testing our model, the managed object context, the persistent store, etc.
 */
@interface DashTests : SenTestCase

/** Returns the managed object context attached to the test cases, gotten from the app delegate
 */
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

/** Returns the DashAPI object for communicating with our API
 */
@property (strong, nonatomic) DashAPI *dash;

@end
