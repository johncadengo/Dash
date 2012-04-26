//
//  CreateHighlightViewController.h
//  Dash
//
//  Created by John Cadengo on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Place;

@interface CreateHighlightViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) Place *place;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) UITextField *textField;

@end
