//
//  AppDelegate.m
//  Dash
//
//  Created by John Cadengo on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "JCLocationManagerSingleton.h"
#import "Constants.h"
#import "DashAPI.h"
#import "DashViewController.h"
#import "TestFlight.h"
#import "Appirater.h"

// Category to make sure that we have accessors to managedobjectcontext
@interface UIViewController (Helper)
-(void)setManagedObjectContext:(NSManagedObjectContext *)context;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize facebook = _facebook;
@synthesize locationManager = _locationManager;

// Make sure we start out on the Dash Tab.
enum {
    kFeedTabIndex = 0,
    kPlacesTabIndex = 1,
    kDashTabIndex = 2,
    kSearchTabIndex = 3,
    kProfileTabIndex = 4,
    kNumTabs = 5
};

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set up the test flight sdk
    [TestFlight takeOff:@"df277f5ccd3ae69fadf14324b2725d73_ODMxNDkyMDEyLTA0LTI0IDE4OjUyOjQ5LjA5MjkyMg"];
    
    // TODO: Do not use this in production.
    #define TESTING 1
    #ifdef TESTING
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    #endif
    
    [Appirater appLaunched:YES];
    
    // Custom navigation bar color and button color
    [[UINavigationBar appearance] setBackgroundImage: [UIImage imageNamed:@"TopBarWithoutDash.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    // Get the TabBarController so we can start off on a different index.
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    [tabBarController setSelectedIndex: kDashTabIndex];
    
    // Grab our managed object context
    NSManagedObjectContext *context = [self managedObjectContext];
    if (!context) {
        // TODO: Handle the error.
        TFLog(@"Cannot initialize context!");
    }
    
    // and make sure everyone gets a reference to it.
    for (UINavigationController *nav in [tabBarController viewControllers]) {
        id controller = [nav topViewController];
        if ([controller respondsToSelector: @selector(setManagedObjectContext:)]) {
            [controller setManagedObjectContext:context];
        }
        else {
            // This should never happen.
            TFLog(@"Something went wrong trying to assign managed object context to one of the view controllers!");
        }
    }
    
    // Configure manager
    [RKObjectManager objectManagerWithBaseURL:@"https://thedashapp.com/api"];
    
    // Color Dash Tab Bar Icon
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DashFourColorIcon.png"]];
    [tabBarController.tabBar addSubview:imageView];
    
    // Handle fb connect
    self.facebook = [[Facebook alloc] initWithAppId:kFBAppID andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if ([self.facebook isSessionValid]) {
        [DashAPI setLoggedIn:YES];
        
        if (DashAPI.me == nil) {
            [self.facebook requestWithGraphPath:@"me" andDelegate:self];
        }
    }
    
    // Handle location manager stuff
    self.locationManager = [JCLocationManagerSingleton sharedInstance];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.locationManager startUpdatingLocation];
    
    // Make sure we have internet connection available always
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(reachabilityDidChange:) name:RKReachabilityDidChangeNotification object:nil];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation 
{
    return [self.facebook handleOpenURL:url]; 
}

- (void)fbDidLogin 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [DashAPI setLoggedIn:YES];
    [self.facebook requestWithGraphPath:@"me" andDelegate:self];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
    TFLog(@"Facebook did not log in");
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    Person *newMe = [Person personWithFBResult:result context:self.managedObjectContext];
    [DashAPI setMe:newMe];
    
    // Let everyone know that we're logged in and to respond accordingly
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fbDidLogin" object:nil userInfo:[NSDictionary dictionaryWithObject:newMe forKey:@"newMe"]];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
    // TODO: Take singleton instance of location manager and stop getting location when we resign
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    
    [Appirater appEnteredForeground:YES];
    [self.locationManager startUpdatingLocation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    [self.facebook extendAccessTokenIfNeeded];
    [self.locationManager startUpdatingLocation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            TFLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Restkit reachability notification

- (void)reachabilityDidChange:(NSNotification *)notification 
{
    RKReachabilityObserver* observer = (RKReachabilityObserver *) [notification object];
    RKReachabilityNetworkStatus status = [observer networkStatus];
    if (RKReachabilityNotReachable == status) {
        RKLogInfo(@"No network access!");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"We are having trouble accessing the internet. Please restore the connection or tap the home button to exit the app." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    } else if (RKReachabilityReachableViaWiFi == status) {
        RKLogInfo(@"Online via WiFi!");
    } else if (RKReachabilityReachableViaWWAN == status) {
        RKLogInfo(@"Online via Edge or 3G!");
    }
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // If it's a relatively recent event, turn off updates to save power
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0)
    {
        [manager stopUpdatingLocation];
        [manager startMonitoringSignificantLocationChanges];
        
        [TestFlight passCheckpoint:@"Got a lock on location"];
    }
}

- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error
{
    [manager stopUpdatingLocation];
    TFLog(@"Location Manager Error%@",error);
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Your location cannot be determined. Please tap the home button to exit the app or you may experience unintended behavior." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"To re-enable, please go to Settings and turn on Location Service for this app or the app may behave unexpectedly." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Your location cannot be determined. Please tap the home button to exit the app or you may experience unintended behavior." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Dash" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Dash.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        TFLog(@"Unresolved error with core data %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
