//
//  AppDelegate.h
//  Dash
//
//  Created by John Cadengo on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "FBConnect.h"

@class LoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, weak) LoginViewController *loginViewController;
@property (nonatomic, strong) Facebook *facebook;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)fbDidLogin;

@end
