//
//  PlaceSquareViewCell.h
//  Dash
//
//  Created by John Cadengo on 12/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Place;

@interface PlaceSquareView : UIView

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *blurb;
@property (nonatomic, strong) NSMutableArray *badges;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIImage *backgroundImage;

// TODO: Trophies, images, badges. How will we store them?
// As distinct UIImages, each one, downloaded from server, stored and cached on phone?
// Or as predetermined images that are bundled with the product?
// Or as some hybrid of the two options above?

// Class methods for determining size and layout of cell
+ (CGSize)size;
+ (UIFont *)nameFont;
+ (UIFont *)infoFont;
+ (UIFont *)blurbFont;
+ (CGSize)sizeForName:(NSString *)name;
+ (CGSize)sizeForInfo:(NSString *)info;
+ (CGSize)sizeForBlurb:(NSString *)blurb;
   
- (id)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage;
- (void)setWithPlace:(Place *)place;

@end
