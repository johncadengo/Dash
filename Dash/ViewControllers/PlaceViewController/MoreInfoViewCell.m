//
//  MoreInfoViewCell.m
//  Dash
//
//  Created by John Cadengo on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MoreInfoViewCell.h"
#import "Constants.h"
#import "Place.h"
#import "Place+Helper.h"

@implementation MoreInfoViewCell

@synthesize mapButton = _mapButton;
@synthesize callButton = _callButton;
@synthesize addressLabel = _addressLabel;
@synthesize phoneLabel = _phoneLabel;
@synthesize hoursLabel = _hoursLabel;


#pragma mark - UI Constants

static CGFloat kWindowWidth = 320.0f;
static CGFloat kTopPadding = 10.0f;
static CGFloat kLeftPadding = 20.0f;
static CGFloat kLabelWidth = 240.0f;
static CGFloat kLabelHeight = 50.0f;
static CGFloat kHeight = 178.5f;

#pragma mark - Class methods

+ (CGFloat)height
{
    return kHeight;
}

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"InformationBubble"]]];
        
        // Buttons
        self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mapButton.frame = CGRectMake(0.0f, 0.0f, kWindowWidth, kLabelHeight);
        //[self.mapButton setImage:[UIImage imageNamed:@"MapButton.png"] forState:UIControlStateNormal];
        //[self.mapButton addTarget:self action:@selector(map:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mapButton];
        
        self.callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.callButton.frame = CGRectMake(0.0f, kLabelHeight, kWindowWidth, kLabelHeight);
        //[self.callButton setImage:[UIImage imageNamed:@"CallButton.png"] forState:UIControlStateNormal];
        [self.callButton addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.callButton];
        
        // Labels
        UIFont *labelFont = [UIFont systemFontOfSize:14.0f];
        UIColor *labelColor = UIColorFromRGB(kMoreInfoTextColor);
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftPadding, kTopPadding, kLabelWidth, kLabelHeight)];
        self.addressLabel.numberOfLines = 0;
        self.addressLabel.textColor = labelColor;
        self.addressLabel.font = labelFont;
        self.addressLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.addressLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.addressLabel];
        
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftPadding, (2 * kTopPadding) + kLabelHeight, kLabelWidth, kLabelHeight)];
        self.phoneLabel.numberOfLines = 1;
        self.phoneLabel.textColor = labelColor;
        self.phoneLabel.font = labelFont;
        self.phoneLabel.lineBreakMode = UILineBreakModeTailTruncation;
        self.phoneLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.phoneLabel];
        
        self.hoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftPadding, (3 * kTopPadding) + (2 * kLabelHeight), kLabelWidth, kLabelHeight)];
        self.hoursLabel.numberOfLines = 0;
        self.hoursLabel.textColor = labelColor;
        self.hoursLabel.font = labelFont;
        self.hoursLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.hoursLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.hoursLabel];
    }
    
    return self;
}

#pragma mark -

- (void)setWithPlace:(Place *)place
{
    self.addressLabel.text = place.address;
    //[self.addressLabel sizeToFit];
    
    self.phoneLabel.text = place.phone;
    
    self.hoursLabel.text = [NSString stringWithFormat: @"%@", @"Hours Unavailable"];
    //[self.hoursLabel sizeToFit];
}

#pragma mark -

- (void)call:(id)sender
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.phoneLabel.text]]];
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
    }
}

@end
