//
//  AppDelegate.h
//  Dash
//
//  Created by John Cadengo on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FBConnect.h"

@class LoginViewController;
@class RecommendedPlacesViewController;
@class ProfileViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate, FBRequestDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) CLLocationManager *locationManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)fbDidLogin;
- (void)reachabilityDidChange:(NSNotification *)notification;

@end
