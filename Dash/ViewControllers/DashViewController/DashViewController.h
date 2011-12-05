//
//  DashViewController.h
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@class DashAPI;

@interface DashViewController : UIViewController <RKObjectLoaderDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;

// UI Elements
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *popButton;

- (void)pop:(id) sender;

@end
