//
//  CreateHighlightViewController.h
//  Dash
//
//  Created by John Cadengo on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@class Place;
@class DashAPI;

@interface CreateHighlightViewController : UIViewController <UITextViewDelegate, RKRequestDelegate, RKObjectLoaderDelegate>

@property (nonatomic, strong) Place *place;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, weak) id <RKObjectLoaderDelegate> delegate;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) UIBarButtonItem *toolbarTitle;
@property (nonatomic, strong) UILabel *characterCountLabel;

- (void)createHighlight:(id)sender;

@end
