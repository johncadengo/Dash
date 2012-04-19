//
//  ProfileHeaderCell.m
//  Dash
//
//  Created by John Cadengo on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileHeaderCell.h"
#import "Person.h"
#import "Person+Helper.h"
#import "Stats.h"
#import "Stats+Helper.h"
#import "UIImage+ProportionalFill.h"
#import "Constants.h"

@implementation ProfileHeaderCell

@synthesize icon = _icon;
@synthesize name = _name;
@synthesize infoBubble = _infoBubble;
@synthesize numFavorites = _numFavorites;
@synthesize numFollowers = _numFollowers;
@synthesize numFollowing = _numFollowing;

static CGFloat const kPadding = 5.0f;
static CGFloat const kPicWidth = 50.0f;

#pragma mark - 
+ (UIFont *)nameFont
{
    return [UIFont fontWithName:kPlutoBold size:14.0f];
}

+ (CGFloat) height
{
    return 70.0f;
}

#pragma mark - 

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Set the infoBubble
        self.infoBubble = [UIImage imageNamed:@"InformationBubble.png"];
        
        // Clear background
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Set

- (void)setWithPerson:(Person *)person
{
    // TODO: Get real photo
    self.icon = [[UIImage imageNamed:@"defaultProfile.jpg"] imageCroppedToFitSize:CGSizeMake(kPicWidth, kPicWidth)];
    
    self.name = @"Laura Byun";
    self.numFavorites = @"1";
    self.numFollowers = @"1";
    self.numFollowing = @"1";
    
    [self setNeedsDisplay];
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // Draw the icon
    [self.icon drawAtPoint:CGPointMake(kPadding, kPadding)];
    
    // Draw the name
    [UIColorFromRGB(kProfileHeaderNameFontColor) set];
    [self.name drawAtPoint:CGPointMake(kPadding + kPicWidth + kPadding, kPadding) withFont:[[self class] nameFont]];
    
    // Draw the info bubble
    [self.infoBubble drawAtPoint:CGPointMake(kPadding + kPicWidth + kPadding, kPadding + 14.0f + kPadding)];
    
    
}

@end
