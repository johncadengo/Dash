//
//  ListModeCell.h
//  Dash
//
//  Created by John Cadengo on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kFriendsListMode,
    kNearbyListMode
} ListMode;

@class ListModeCell;

@protocol ListModeCellDelegate <NSObject>
- (void)setListMode:(ListMode)listMode;
@end

@interface ListModeCell : UITableViewCell

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, weak) id <ListModeCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier selectedSegmentIndex:(ListMode)index;
- (void)updateListMode:(id)sender;
- (void)setListMode:(ListMode)newListMode;

@end
