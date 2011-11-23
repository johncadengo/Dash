//
//  MoreInfoViewCell.h
//  Dash
//
//  Created by John Cadengo on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TISwipeableTableView.h"

@class MoreInfoViewCell;

@protocol MoreInfoviewCellDelegate <NSObject>
- (void)cellBackButtonWasTapped:(MoreInfoViewCell *) cell;
@end

@interface MoreInfoViewCell : TISwipeableTableViewCell

@property (nonatomic, weak) id <MoreInfoviewCellDelegate> delegate;

+ (CGFloat)height;

@end