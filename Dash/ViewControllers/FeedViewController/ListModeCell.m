//
//  ListModeCell.m
//  Dash
//
//  Created by John Cadengo on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ListModeCell.h"
#import "Constants.h"

@implementation ListModeCell

@synthesize segmentedControl;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier selectedSegmentIndex:(ListMode)index
{
    // TODO: Put these variables in constants
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // This cell should not be selectable.
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *items = [NSArray arrayWithObjects: kListModeOne, kListModeTwo, nil];
        CGRect rect = CGRectMake(70.0, 10.0, 180.0, 25.0);
        
        self.segmentedControl = [[UISegmentedControl alloc] initWithItems: items];
        self.segmentedControl.frame = rect;
        self.segmentedControl.selectedSegmentIndex = index;
        [self.segmentedControl addTarget:self
                                  action:@selector(updateListMode:)
                        forControlEvents:UIControlEventValueChanged];
        
        [self.contentView addSubview: self.segmentedControl];
        [self setFrame: rect];
    }
    return self;
}

- (void)updateListMode:(id)sender
{
    UISegmentedControl * control = (UISegmentedControl *)sender;
    ListMode newListMode = [control selectedSegmentIndex];
    [self setListMode:newListMode];
}

- (void)setListMode:(ListMode)newListMode
{
    [self.segmentedControl setSelectedSegmentIndex: newListMode];
    [self.delegate setListMode:newListMode];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
