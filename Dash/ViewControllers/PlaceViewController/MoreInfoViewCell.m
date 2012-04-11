//
//  MoreInfoViewCell.m
//  Dash
//
//  Created by John Cadengo on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MoreInfoViewCell.h"
#import "Constants.h"

@implementation MoreInfoViewCell

@synthesize mapButton = _mapButton;
@synthesize callButton = _callButton;
@synthesize addressLabel = _addressLabel;
@synthesize addressTitle = _addressTitle;
@synthesize phoneLabel = _phoneLabel;
@synthesize phoneTitle = _phoneTitle;
@synthesize hoursLabel = _hoursLabel;
@synthesize hoursTitle = _hoursTitle;


#pragma mark - UI Constants

//static CGFloat kWindowWidth = 320.0f;
//static CGFloat kPadding = 5.0f;

#pragma mark - Class methods

+ (CGFloat)height
{
    return 200.0f;
}

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mapButton.frame = CGRectMake(10.0f, 50.0f, 70.0f, 40.0f);
        [self.mapButton setImage:[UIImage imageNamed:@"MapButton.png"] forState:UIControlStateNormal];
        [self addSubview:self.mapButton];
        
        self.callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.callButton.frame = CGRectMake(10.0f, 100.0f, 70.0f, 40.0f);
        [self.callButton setImage:[UIImage imageNamed:@"CallButton.png"] forState:UIControlStateNormal];
        [self addSubview:self.callButton];
        
        self.addressTitle = kMoreInfoAddress;
        self.phoneTitle = kMoreInfoPhone;
        self.hoursTitle = kMoreInfoHours;
    }
    
    return self;
}

#pragma mark - 


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // Draw the background
    [[UIImage imageNamed:@"MoreInformationButtonOpen.png"] drawAtPoint:CGPointZero]; 
    
    // Draw the titles
    UIFont *titleFont = [UIFont fontWithName:kHelveticaNeueBold size:10.0f];
    [UIColorFromRGB(kMoreInfoTextColor) set];
    [self.addressTitle drawAtPoint:CGPointMake(90.0f, 40.0f) withFont:titleFont];
    [self.phoneTitle drawAtPoint:CGPointMake(90.0f, 100.0f) withFont:titleFont];
    [self.hoursTitle drawAtPoint:CGPointMake(90.0f, 140.0f) withFont:titleFont];
    
    
}

@end
