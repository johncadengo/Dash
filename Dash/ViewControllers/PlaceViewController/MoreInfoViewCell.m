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
        // Buttons
        self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mapButton.frame = CGRectMake(15.0f, 50.0f, 70.0f, 40.0f);
        [self.mapButton setImage:[UIImage imageNamed:@"MapButton.png"] forState:UIControlStateNormal];
        //[self.mapButton addTarget:self action:@selector(map:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mapButton];
        
        self.callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.callButton.frame = CGRectMake(15.0f, 100.0f, 70.0f, 40.0f);
        [self.callButton setImage:[UIImage imageNamed:@"CallButton.png"] forState:UIControlStateNormal];
        [self.callButton addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.callButton];
        
        // Titles
        self.addressTitle = kMoreInfoAddress;
        self.phoneTitle = kMoreInfoPhone;
        self.hoursTitle = kMoreInfoHours;
        
        // Labels
        UIFont *labelFont = [UIFont fontWithName:kHelveticaNeueBold size:14.0f];
        UIColor *labelColor = UIColorFromRGB(kMoreInfoTextColor);
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 50.0f, 165.0f, 42.0f)];
        self.addressLabel.numberOfLines = 0;
        self.addressLabel.textColor = labelColor;
        self.addressLabel.font = labelFont;
        self.addressLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.addressLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.addressLabel];
        
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 110.0f, 165.0f, 20.0f)];
        self.phoneLabel.numberOfLines = 1;
        self.phoneLabel.textColor = labelColor;
        self.phoneLabel.font = labelFont;
        self.phoneLabel.lineBreakMode = UILineBreakModeTailTruncation;
        self.phoneLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.phoneLabel];
        
        self.hoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 150.0f, 165.0f, 42.0f)];
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
    [self.addressLabel sizeToFit];
    
    self.phoneLabel.text = place.phone;
    
    self.hoursLabel.text = [NSString stringWithFormat: @"%@", @"Open"];
    [self.hoursLabel sizeToFit];
}

#pragma mark -

- (void)call:(id)sender
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.phoneLabel.text]]];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
}

-(NSString *) URLEncodeString:(NSString *) str
{
    
    NSMutableString *tempStr = [NSMutableString stringWithString:str];
    [tempStr replaceOccurrencesOfString:@" " withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempStr length])];
    
    
    return [[NSString stringWithFormat:@"%@",tempStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)map:(id)sender
{
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self URLEncodeString:[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", self.addressLabel.text]]]];
    

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
    [self.addressTitle drawAtPoint:CGPointMake(100.0f, 40.0f) withFont:titleFont];
    [self.phoneTitle drawAtPoint:CGPointMake(100.0f, 100.0f) withFont:titleFont];
    [self.hoursTitle drawAtPoint:CGPointMake(100.0f, 140.0f) withFont:titleFont];
    
    
}

@end
