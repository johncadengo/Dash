//
//  MoreInfoViewCell.m
//  Dash
//
//  Created by John Cadengo on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MoreInfoViewCell.h"

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
        
    }
    
    return self;
}

#pragma mark - 


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [[UIImage imageNamed:@"MoreInformationButtonOpen.png"] drawAtPoint:CGPointZero]; 
    
}

@end
