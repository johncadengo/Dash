//
//  PlaceSquareViewCell.h
//  Dash
//
//  Created by John Cadengo on 12/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Place;

@interface PlaceSquareViewCell : UIView

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *blurb;
@property (nonatomic, strong) NSMutableArray *badges;
@property (nonatomic, strong) UIImage *icon;

// TODO: Trophies, images, badges. How will we store them?
// As distinct UIImages, each one, downloaded from server, stored and cached on phone?
// Or as predetermined images that are bundled with the product?
// Or as some hybrid of the two options above?


- (void)setWithPlace:(Place *)place;

@end
