//
//  PlaceViewCell.h
//  Dash
//
//  Created by John Cadengo on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TISwipeableTableView.h"

typedef enum {
    PlaceActionViewCellTypeList = 0,
    PlaceActionViewCellTypeSquare = 1
} PlaceActionViewCellType;

@class PlaceActionViewCell;
@class PlaceAction;

@protocol PlaceActionViewCellDelegate <NSObject>
- (void)cellBackButtonWasTapped:(PlaceActionViewCell *)cell;
@end

@interface PlaceActionViewCell : TISwipeableTableViewCell

@property (nonatomic, weak) id <PlaceActionViewCellDelegate> delegate;

// Model
@property (nonatomic) PlaceActionViewCellType cellType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;

// TODO: Some sort of way to indicate which icons will appear
// and what icons to show: photograph, footprints, medal.
//@property (nonatomic, strong) 

// Methods

+ (CGFloat)heightForPlaceAction:(PlaceAction *)placeAction withCellType:(PlaceActionViewCellType)cellType;
+ (UIFont *)nameFont;
+ (UIFont *)addressFont;
+ (CGSize)textSizeForName:(NSString *)name;
+ (CGSize)textSizeForAddress:(NSString *)address;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(PlaceActionViewCellType) cellType;

- (void)setWithPlaceAction:(PlaceAction *)placeAction;

@end