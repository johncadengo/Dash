//
//  PlaceViewCell.h
//  Dash
//
//  Created by John Cadengo on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceViewController.h"

typedef enum {
    PlaceViewCellTypeHeader = 0,
    PlaceViewCellTypeSquare = 1
} PlaceViewCellType;

@class Place;

// TODO: Make JCImageGallery a single embed view.
// TODO: Include transition state in the state of a JCViewController. Brilliant!
@class JCImageGalleryViewController;

@interface PlaceHeaderViewCell : UITableViewCell

@property (nonatomic) PlaceViewCellType cellType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *categories;
@property (nonatomic, strong) NSString *distancePrice;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) JCImageGalleryViewController *imageGalleryViewController;
@property (nonatomic) PlaceThemeColor themeColor;

/** Should only call after the view loads. Cascades appropriate changes to view properties as necessary.
 */
- (void)setThemeColor:(PlaceThemeColor) newColor;

+ (CGFloat)heightForPlace:(Place *)place withCellType:(PlaceViewCellType)cellType;

+ (UIFont *)nameFont;
+ (UIFont *)categoriesFont;
+ (UIFont *)distancePriceFont;

+ (CGSize)sizeForCategories:(NSString *)categories;
+ (CGSize)sizeForDistancePrice:(NSString *)distancePrice;

+ (NSInteger)numberOfLinesForName:(NSString *)name;
+ (CGSize)sizeForName:(NSString *)name;
+ (CGSize)adjustedSizeForName:(NSString *)name;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(PlaceViewCellType)cellType;

- (NSNumber *)calculateDistanceFromPlace:(Place *)place;
- (void)setWithPlace:(Place *)place context:(NSManagedObjectContext *)context;

- (void)customLeadingDrawing:(NSString *)text withSize:(CGSize)nameSize leading:(CGFloat)leading;

@end
