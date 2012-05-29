//
//  PlaceViewCell.h
//  Dash
//
//  Created by John Cadengo on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RecommendedPlaceViewCellTypeFirst = 0,
    RecommendedPlaceViewCellTypeMiddle = 1,
    RecommendedPlaceViewCellTypeLast = 2,
    RecommendedPlaceViewCellTypeOnly = 3,
} RecommendedPlaceViewCellType;

@class Place;

@interface RecommendedPlaceViewCell : UITableViewCell

// Model
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic) RecommendedPlaceViewCellType type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *distancePrice;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIImage *icon;

// Methods
+ (CGFloat)heightForType:(RecommendedPlaceViewCellType)type;
+ (UIFont *)titleFont;
+ (UIFont *)subtitleFont;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(RecommendedPlaceViewCellType) cellType;

- (NSNumber *)calculateDistanceFromPlace:(Place *)place;
- (void)setWithPlace:(Place *)place context:(NSManagedObjectContext *)context;

- (void)drawHorizontalLineStartingAt:(CGPoint)origin withLength:(CGFloat)length;

@end