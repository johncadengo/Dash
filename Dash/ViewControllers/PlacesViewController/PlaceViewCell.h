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
    PlaceViewCellTypeList = 0,
    PlaceViewCellTypeSquare = 1
} PlaceViewCellType;

@class PlaceViewCell;
@class Place;

@protocol PlaceViewCellDelegate <NSObject>
- (void)cellBackButtonWasTapped:(PlaceViewCell *)cell;
@end

@interface PlaceViewCell : TISwipeableTableViewCell

@property (nonatomic, weak) id <PlaceViewCellDelegate> delegate;

// Model
@property (nonatomic) PlaceViewCellType cellType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;

// TODO: Some sort of way to indicate which icons will appear
// and what icons to show: photograph, footprints, medal.
//@property (nonatomic, strong) 

// Methods

+ (CGSize)sizeForPlace:(Place *)place withCellType:(PlaceViewCellType)cellType;
+ (UIFont *)nameFont;
+ (UIFont *)addressFont;
+ (CGSize)textSizeForName:(NSString *)name;
+ (CGSize)textSizeForAddress:(NSString *)address;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(PlaceViewCellType) cellType;

- (void)setCellType:(PlaceViewCellType)newCellType;
- (void)setWithPlace:(Place *)place;

@end