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
#import "Hours.h"
#import "Hours+Helper.h"

@implementation MoreInfoViewCell

@synthesize mapButton = _mapButton;
@synthesize callButton = _callButton;
@synthesize hoursButton = _hoursButton;
@synthesize addressLabel = _addressLabel;
@synthesize phoneLabel = _phoneLabel;
@synthesize hoursLabel = _hoursLabel;


#pragma mark - UI Constants

static CGFloat kWindowWidth = 320.0f;
static CGFloat kTopPadding = 8.0f;
static CGFloat kLeftPadding = 20.0f;
static CGFloat kLabelWidth = 220.0f;
static CGFloat kLabelHeight = 55.0f;
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
        self.mapButton.frame = CGRectMake(0.0f, kTopPadding, kWindowWidth, kLabelHeight);
        //[self.mapButton setImage:[UIImage imageNamed:@"MapButton.png"] forState:UIControlStateNormal];
        //[self.mapButton addTarget:self action:@selector(map:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mapButton];
        
        self.callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.callButton.frame = CGRectMake(0.0f, kTopPadding + kLabelHeight, kWindowWidth, kLabelHeight);
        //[self.callButton setImage:[UIImage imageNamed:@"CallButton.png"] forState:UIControlStateNormal];
        [self.callButton addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.callButton];
        
        self.hoursButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.hoursButton.frame = CGRectMake(0.0f, kTopPadding + (2 * kLabelHeight), kWindowWidth, kLabelHeight);
        //[self.hoursButton addTarget:self action:@selector(showHours:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.hoursButton];
        
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
        
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftPadding, kTopPadding + kLabelHeight, kLabelWidth, kLabelHeight)];
        self.phoneLabel.numberOfLines = 1;
        self.phoneLabel.textColor = labelColor;
        self.phoneLabel.font = labelFont;
        self.phoneLabel.lineBreakMode = UILineBreakModeTailTruncation;
        self.phoneLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.phoneLabel];
        
        self.hoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftPadding, kTopPadding + (2 * kLabelHeight), kLabelWidth, kLabelHeight)];
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
    self.addressLabel.text = [NSString stringWithFormat: @"%@", place.address];
    //[self.addressLabel sizeToFit];
    
    self.phoneLabel.text = place.phone;
    
    NSMutableString *hoursString = [[NSMutableString alloc] initWithCapacity:64];
    
    NSArray *sortedArray = [[place.hours allObjects] sortedArrayUsingSelector:@selector(compare:)];
    
    for (Hours *hours in sortedArray) {
        if (hours.openNow && [hoursString length] == 0) {
            [hoursString appendFormat:@"Currently Open"];}
    }
    
    if ([place.hours count] == 0) {
        [hoursString appendFormat:@"Hours Unavailable"];
    }
    else if ([hoursString length] == 0) {
        [hoursString appendFormat:@"Currently Closed"];
    }
    
    self.hoursLabel.text = [hoursString description];
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
