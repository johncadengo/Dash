//
//  MoreInfoViewCell.m
//  Dash
//
//  Created by John Cadengo on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MoreInfoViewCell.h"

@implementation MoreInfoViewCell

@synthesize open = _open;

#pragma mark - UI Constants

//static CGFloat kWindowWidth = 320.0f;
//static CGFloat kPadding = 5.0f;

#pragma mark - Class methods

+ (CGFloat)height
{
    return 42.0f;
}

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // By default, we are closed
        self.open = NO;
    }
    
    return self;
}

#pragma mark - Open/Close Logic

/** Override setter to actually open and close
 */
- (void)setOpen:(BOOL)open
{
    _open = open;
    NSLog(@"More Info Open: %d", open);
}

#pragma mark - 


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [[UIImage imageNamed:@"MoreInformationButton.png"] drawAtPoint:CGPointZero]; 
    
}

@end
