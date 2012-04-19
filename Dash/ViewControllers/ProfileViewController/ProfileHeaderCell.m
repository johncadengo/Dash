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

@implementation ProfileHeaderCell

@synthesize icon = _icon;
@synthesize name = _name;
@synthesize infoBubble = _infoBubble;
@synthesize numFavorites = _numFavorites;
@synthesize numFollowers = _numFollowers;
@synthesize numFollowing = _numFollowing;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Set the default icon, 
        self.icon = [UIImage imageNamed:@"defaultProfile.jpg"];
        
        // and the infoBubble
        self.infoBubble = [UIImage imageNamed:@"InformationBubble.png"];
    }
    return self;
}

#pragma mark - Set

- (void)setWithPerson:(Person *)person
{

}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect
{
    
}

@end
