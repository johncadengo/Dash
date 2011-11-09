//
//  JCImageGalleryViewController.h
//  Dash
//
//  Created by John Cadengo on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCImageGalleryView.h"

@interface JCImageGalleryViewController : UITableViewController

@property (nonatomic, strong) JCImageGalleryView *rowView;
@property (nonatomic, strong) NSMutableArray *images;

- (id)initWithStyle:(UITableViewStyle)style withSize:(CGSize)size;
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer;

- (void)showToolbar:(id)sender;
- (void)done:(id)sender;

@end
