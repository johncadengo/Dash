//
//  ActionViewController.h
//  Dash
//
//  Created by John Cadengo on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionViewCell.h"

@class Action;

@interface ActionViewController : TISwipeableTableViewController <UITableViewDataSource, UITableViewDelegate, ActionVIewCellDelegate>

@property (nonatomic, strong) Action *action;

@end
