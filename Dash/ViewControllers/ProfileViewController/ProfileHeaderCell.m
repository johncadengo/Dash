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

static CGFloat const kPadding = 10.0f;
static CGFloat const kPicWidth = 50.0f;

#pragma mark - 
+ (UIFont *)nameFont
{
    return [UIFont fontWithName:kPlutoBold size:13.0f];
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
        
        self.icon = [[EGOImageView alloc] initWithPlaceholderImage:[[UIImage imageNamed:@"defaultProfile.jpg"] imageCroppedToFitSize:CGSizeMake(kPicWidth, kPicWidth)] delegate:self];
        self.icon.frame = CGRectMake(kPadding, kPadding, kPicWidth, kPicWidth);
        [self addSubview:self.icon];
    }
    return self;
}

#pragma mark - Set

- (void)setWithPerson:(Person *)person
{
    [self.icon setImageURL:person.photoURL];
    
    self.name = person.name;
    self.numFavorites = @"1";
    self.numFollowers = @"1";
    self.numFollowing = @"1";
    
    [self setNeedsDisplay];
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // Draw the name
    [UIColorFromRGB(kProfileHeaderNameFontColor) set];
    [self.name drawAtPoint:CGPointMake(kPadding + kPicWidth + kPadding + 2.0f, kPadding) withFont:[[self class] nameFont]];
    
    // Draw the info bubble
    [self.infoBubble drawAtPoint:CGPointMake(kPadding + kPicWidth + 5.0f, 13.0f + kPadding)];
    
    
}

@end
