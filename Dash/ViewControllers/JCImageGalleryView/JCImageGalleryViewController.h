//
//  JCImageGalleryViewController.h
//  Dash
//
//  Created by John Cadengo on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCImageGalleryViewController : UITableViewController

@property (nonatomic, strong) UIView *rowView;

- (id)initWithStyle:(UITableViewStyle)style withSize:(CGSize)size;

@end
