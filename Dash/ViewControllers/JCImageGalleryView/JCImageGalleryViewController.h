//
//  JCImageGalleryViewController.h
//  Dash
//
//  Created by John Cadengo on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCImageGalleryView.h"

/** Keeps track of the state of the view
 */
typedef enum {
    JCImageGalleryViewStateRow = 0,
    JCImageGalleryViewStateOverlay = 1
}JCImageGalleryViewState;

@interface JCImageGalleryViewController : UITableViewController

@property (nonatomic, strong) JCImageGalleryView *view;
@property (nonatomic, strong) UIGestureRecognizer *tap;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *done;
@property (nonatomic) JCImageGalleryViewState state;

- (id)initWithStyle:(UITableViewStyle)style withSize:(CGSize)size;
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer;

- (void)showToolbar:(id)sender;
- (void)handleDone:(id)sender;
- (void)flipState;

@end
