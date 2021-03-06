//
//  PlaceSquareViewCell.h
//  Dash
//
//  Created by John Cadengo on 12/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlaceSquareViewDelegate <NSObject>

- (void)pushPlaceAtIndex:(NSInteger)index;

@end

@class Place;

@interface PlaceSquareView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *categories;
@property (nonatomic, strong) NSString *distancePrice;
@property (nonatomic, strong) NSString *blurb;
@property (nonatomic, strong) NSString *numRatings;
@property (nonatomic, strong) NSMutableArray *badges;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIImage *stars;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSInteger index;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, weak) id <PlaceSquareViewDelegate> delegate;

// TODO: Trophies, images, badges. How will we store them?
// As distinct UIImages, each one, downloaded from server, stored and cached on phone?
// Or as predetermined images that are bundled with the product?
// Or as some hybrid of the two options above?

// Class methods for determining size and layout of cell
+ (CGSize)size;
+ (UIFont *)nameFont;
+ (UIFont *)categoriesFont;
+ (UIFont *)distancePriceFont;
+ (UIFont *)blurbFont;

+ (CGFloat)nameLeading:(NSString *)name;
+ (CGFloat)categoriesLeading;
+ (CGFloat)distancePriceLeading;

+ (CGSize)sizeForCategories:(NSString *)categories;
+ (CGSize)sizeForDistancePrice:(NSString *)distancePrice;
+ (CGSize)sizeForBlurb:(NSString *)blurb;

+ (NSInteger)numberOfLinesForName:(NSString *)name;
+ (CGSize)sizeForName:(NSString *)name;
+ (CGSize)adjustedSizeForName:(NSString *)name;

+ (CGColorRef)black;
   
- (id)initWithFrame:(CGRect)frame;
- (void)setWithPlace:(Place *)place context:(NSManagedObjectContext *)context;
- (void)reset;

- (void)handleTap:(UIGestureRecognizer *)tap;

/** Such a hack... Draw the text twice. 
 *  One cropping the top half, the other cropping the bottom half.
 *  Then squish them together to get desired leading effect.
 */
- (void)customLeadingDrawing:(NSString *)text withSize:(CGSize)nameSize leading:(CGFloat)leading;

@end
