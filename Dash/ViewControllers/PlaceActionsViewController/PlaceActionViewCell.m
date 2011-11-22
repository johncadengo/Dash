//
//  PlaceViewCell.m
//  Dash
//
//  Created by John Cadengo on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceActionViewCell.h"
#import "Place.h"
#import "PlaceAction.h"

@implementation PlaceActionViewCell

@synthesize delegate = _delegate;
@synthesize name = _name;
@synthesize address = _address;
@synthesize cellType = _cellType;

#pragma mark - Some UI Constants

static CGFloat kWindowWidth = 320.0f;
static CGFloat kPadding = 5.0f;

static CGFloat kMaxAddressHeight = 1000.0f;

static UILineBreakMode kNameLineBreak = UILineBreakModeHeadTruncation;
static UILineBreakMode kAddressLineBreak = UILineBreakModeWordWrap;

#pragma mark - Class methods for determining the size of UI elements

+ (CGFloat)heightForPlaceAction:(PlaceAction *)placeAction withCellType:(PlaceActionViewCellType)cellType
{
    // TODO: Get the actual name and timestamp for calculating size.
    
    CGSize nameSize = [self textSizeForName:@"hi"];
    CGSize addressSize = [self textSizeForAddress:@"hey"];
    
    CGFloat height = kPadding + nameSize.height + kPadding + addressSize.height + kPadding;
    //CGSize totalSize = CGSizeMake(kWindowWidth, height);
    
    return height;
}

+ (UIFont *)nameFont
{
    return [UIFont boldSystemFontOfSize:16];
}

+ (UIFont *)addressFont
{
    return [UIFont systemFontOfSize:14];
}

+ (CGSize)textSizeForName:(NSString *)name
{
    // TODO: Account for the little icons
    CGFloat maxWidth = kWindowWidth - (2 * kPadding);
    CGSize textSize = [name sizeWithFont:[self nameFont] 
                                forWidth:maxWidth 
                           lineBreakMode:kNameLineBreak];
    
    return textSize;
}

+ (CGSize)textSizeForAddress:(NSString *)address
{
    // TODO: Account for the little icons
    CGFloat maxWidth = kWindowWidth - (2 * kPadding);
    CGSize maxSize = CGSizeMake(maxWidth, kMaxAddressHeight);
    CGSize textSize = [address sizeWithFont:[self addressFont] 
                          constrainedToSize:maxSize
                              lineBreakMode:kAddressLineBreak];
    
    return textSize;
}

#pragma mark - Initialization

/** By default we initialize with a list type place cell.
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier cellType:PlaceActionViewCellTypeList];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(PlaceActionViewCellType) cellType
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setCellType:cellType];
    }
    
    return self;
}

- (void)setCellType:(PlaceActionViewCellType)newCellType
{
    _cellType = newCellType;
    
    switch (_cellType) {
        case PlaceActionViewCellTypeList:
            
            break;
        case PlaceActionViewCellTypeSquare:
            
            break;
        default:
            NSAssert(NO, @"Trying to set PlaceViewCellType that doens't exist %d", _cellType);
            break;
    }
    
    
}

- (void)setWithPlaceAction:(PlaceAction *)placeAction
{
    Place *place = [placeAction place];
    self.name = [place name];
    self.address = [place address];
    
    [self setNeedsDisplay];
}

- (void)buttonWasTapped:(UIButton *)button {
	
	if ([self.delegate respondsToSelector:@selector(cellBackButtonWasTapped:)]){
		[self.delegate cellBackButtonWasTapped:self];
	}
}

- (void)backViewWillAppear {
	
    
    
}

- (void)backViewDidDisappear {
	// Remove any subviews from the backView.
	
	for (UIView * subview in self.backView.subviews){
		[subview removeFromSuperview];
	}
}

- (void)drawContentView:(CGRect)rect {
	
	UIColor * textColour = (self.selected || self.highlighted) ? [UIColor whiteColor] : [UIColor blackColor];	
	[textColour set];
	CGSize nameSize = [[self class] textSizeForName:self.name];
	[self.name drawInRect:CGRectMake(kPadding, kPadding,
                                     nameSize.width, nameSize.height)
                 withFont:[[self class] nameFont]
            lineBreakMode:kNameLineBreak];
    
    textColour = [UIColor grayColor];
    [textColour set];
    
    CGSize addressSize = [[self class] textSizeForAddress:self.address];
    CGRect addressRect = CGRectMake(kPadding, nameSize.height + kPadding,
                                    addressSize.width, addressSize.height);
    [self.address drawInRect:addressRect 
                    withFont:[[self class] addressFont] 
               lineBreakMode:kAddressLineBreak];
    
    // If it is a feed item action cell then we draw a detail view indicator on the right side
    if (self.cellType == PlaceActionViewCellTypeList) {
        UIFont *font = [[self class] nameFont];
        NSString *arrow = [NSString stringWithFormat:@">"];
        CGSize arrowSize = [arrow sizeWithFont:font];
        CGPoint point = CGPointMake(kWindowWidth -  (4 * kPadding), 
                                    (rect.size.height / 2.0f) - (arrowSize.height / 2.0f));
        [arrow drawAtPoint:point withFont:font];
    }
}

- (void)drawBackView:(CGRect)rect {
	
	[[UIImage imageNamed:@"meshpattern.png"] drawAsPatternInRect:rect];    
    NSString *backViewText = [NSString stringWithFormat:@"buddy"];
    
    UIColor * textColour = (self.selected || self.highlighted) ? [UIColor whiteColor] : [UIColor blackColor];	
	[textColour set];
	
	UIFont * textFont = [UIFont boldSystemFontOfSize:16];
	
	CGSize textSize = [backViewText sizeWithFont:textFont constrainedToSize:rect.size];
	[backViewText drawInRect:CGRectMake((rect.size.width / 2) - (textSize.width / 2), 
                                        (rect.size.height / 2) - (textSize.height / 2),
                                        textSize.width, textSize.height)
                    withFont:textFont];
}

@end
