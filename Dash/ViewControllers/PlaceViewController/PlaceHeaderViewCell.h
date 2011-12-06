//
//  PlaceViewCell.h
//  Dash
//
//  Created by John Cadengo on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

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
@property (nonatomic, strong) NSString *blurb;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) JCImageGalleryViewController *imageGalleryViewController;

+ (CGFloat)heightForPlace:(Place *)place withCellType:(PlaceViewCellType)cellType;
+ (UIFont *)nameFont;
+ (UIFont *)blurbFont;
+ (CGSize)textSizeForName:(NSString *)name;
+ (CGSize)textSizeForBlurb:(NSString *)blurb;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(PlaceViewCellType)cellType;

- (void)setWithPlace:(Place *)place;

@end
