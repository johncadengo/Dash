//
//  PopsScrollView.m
//  Dash
//
//  Created by John Cadengo on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PopsScrollView.h"
#import "PlaceSquareView.h"

// From: http://stackoverflow.com/questions/817469/how-do-i-make-and-use-a-queue-in-objective-c
@interface NSMutableArray (QueueAdditions)
- (id) dequeue;
- (void) enqueue:(id)obj;
@end

@implementation NSMutableArray (QueueAdditions)
// Queues are first-in-first-out, so we remove objects from the head
- (id) dequeue {
    // if ([self count] == 0) return nil; // to avoid raising exception (Quinn)
    id headObject = [self objectAtIndex:0];
    if (headObject != nil) {
        //[[headObject retain] autorelease]; // so it isn't dealloc'ed on remove
        [self removeObjectAtIndex:0];
    }
    return headObject;
}

// Add to the tail of the queue (no one likes it when people cut in line!)
- (void) enqueue:(id)anObject {
    [self addObject:anObject];
    //this method automatically adds to the end of the array
}
@end

@implementation PopsScrollView

@synthesize quadrantImages = _quadrantImages;
@synthesize availableCells = _availableCells;
@synthesize visibleCells = _visibleCells;
@synthesize currentPage = _currentPage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Set up the quadrantImages
        UIImage *firstImage = [UIImage imageNamed:@"DashGreenBox.png"]; 
        UIImage *secondImage = [UIImage imageNamed:@"DashOrangeBox.png"]; 
        UIImage *thirdImage = [UIImage imageNamed:@"DashRedBox.png"]; 
        UIImage *fourthImage = [UIImage imageNamed:@"DashTealBox.png"];
        self.quadrantImages = [[NSArray alloc] initWithObjects:
                               firstImage, secondImage, thirdImage, fourthImage, nil];
        
        // Recycling pool
        self.availableCells = [[NSMutableArray alloc] initWithCapacity:16];
        self.visibleCells = [[NSMutableArray alloc] initWithCapacity:8];
        
        self.scrollEnabled = YES;
        self.pagingEnabled = YES;
        self.delegate = self;
        self.contentSize = CGSizeMake(6 * PlaceSquareView.size.width, 2 * PlaceSquareView.size.height);
        self.currentPage = 1;
        
        // Populate empty initial views
        for (int i = 0; i < 6; i++) {
            for (int j = 0; j < 2; j++) {
                [self dequeueReuseableCellAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            }
        }
        [self updateVisibleCells];
    }
    return self;
}

/** Calculate the frame based on the index path
 *  Section is the column and row is the row
 *  So its an 2xn matrix, where n is the # of pages
 *  And each page has four square views on it
 */
- (CGRect)frameForCellAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = PlaceSquareView.size.width;
    CGFloat height = PlaceSquareView.size.height;
    
    NSInteger firstAvailableSection = self.currentPage * 2;
    CGFloat x = (indexPath.section - firstAvailableSection) * width;
    CGFloat y = indexPath.row * height;
    
    return CGRectMake(x, y, width, height);
}

- (UIImage *)imageForCellAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image;
    NSInteger sectionParity = indexPath.section % 2;

    if (sectionParity == 0) {
        // This means we're on the left half of the screen, i.e. second or third image, i.e. index 1 and 2
        if (indexPath.row == 0) {
            image = [self.quadrantImages objectAtIndex:1];
        }
        else {
            image = [self.quadrantImages objectAtIndex:2];
        }
    }
    else {
        // Right half of screen
        if (indexPath.row == 0) {
            image = [self.quadrantImages objectAtIndex:0];
        }
        else {
            image = [self.quadrantImages objectAtIndex:3];
        }
    }

    return image;
}

- (BOOL)cellVisibleAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = [self frameForCellAtIndexPath:indexPath];
    return CGRectContainsRect(self.frame, frame);
}

- (PlaceSquareView *)dequeueReuseableCellAtIndexPath:(NSIndexPath *)indexPath
{
    PlaceSquareView *cell;
    
    // If we don't have enough, make more
    if (!self.availableCells.count) {
        cell = [[PlaceSquareView alloc] initWithFrame:[self frameForCellAtIndexPath:indexPath] backgroundImage:[self imageForCellAtIndexPath:indexPath]];
        [self.availableCells addObject:cell];
    }
    else {
        cell = [self.availableCells dequeue];
        [cell setBackgroundImage:[self imageForCellAtIndexPath:indexPath]];
    }
    
    [self addSubview:cell];
    
    return cell;
}

- (void)updateVisibleCells
{
    NSMutableArray *allCells = [[NSMutableArray alloc] initWithCapacity:32];
    [allCells addObjectsFromArray:self.availableCells];
    [allCells addObjectsFromArray:self.visibleCells];
    [self.availableCells removeAllObjects];
    [self.visibleCells removeAllObjects];
    
    for (PlaceSquareView *cell in allCells) {
        if (CGRectContainsRect(self.frame, cell.frame)) {
            [self.visibleCells addObject:cell];
        }
        else {
            [self.availableCells addObject:cell];
        }
    }
    
    [allCells removeAllObjects];
}

- (void)reloadData
{
    //[self updateVisibleCells];
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Adjust page
    self.currentPage = floorf(scrollView.contentOffset.x / PlaceSquareView.size.width);
    [self updateVisibleCells];
}

@end
