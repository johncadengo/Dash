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

@synthesize availableCells = _availableCells;
@synthesize visibleCells = _visibleCells;
@synthesize currentPage = _currentPage;
@synthesize popDelegate = _popDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Recycling pool
        self.availableCells = [[NSMutableArray alloc] initWithCapacity:16];
        self.visibleCells = [[NSMutableArray alloc] initWithCapacity:12];
        
        self.scrollEnabled = YES;
        self.pagingEnabled = YES;
        self.delegate = self;
        self.contentSize = CGSizeMake(6 * PlaceSquareView.size.width, 2 * PlaceSquareView.size.height);
        self.currentPage = 1;
        
        // Populate initial views
        PlaceSquareView *cell;
        NSIndexPath *indexPath;
        for (int i = 0; i < 6; i++) {
            for (int j = 0; j < 2; j++) {
                indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                cell = [[PlaceSquareView alloc] initWithFrame:CGRectZero];
                [self.availableCells addObject:cell];
            }
        }
        
        self.popDelegate = delegate;
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
    
    NSInteger firstAvailableSection = (self.currentPage + 1) * 2;
    CGFloat x = (indexPath.section - firstAvailableSection) * width;
    CGFloat y = indexPath.row * height;
    
    return CGRectMake(x, y, width, height);
}

- (PlaceSquareView *)dequeueReuseableCellAtIndexPath:(NSIndexPath *)indexPath
{
    PlaceSquareView *cell = nil;

    if (self.availableCells.count) {
        cell = [self.availableCells dequeue];
        [self addSubview:cell];
    }
    
    return cell;
}

- (void)updateVisibleCells
{
    // Put our visible cells back into the pool
    for (PlaceSquareView *cell in self.visibleCells) {
        [self.availableCells addObject:cell];
        [cell removeFromSuperview];
    }
    [self.visibleCells removeAllObjects];
    
    // Go through and ask our delegate for the cells
    PlaceSquareView *cell;
    NSIndexPath *indexPath;
    for (int i = 0; i < 6; i++) {
        for (int j = 0; j < 2; j++) {
            indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            cell = [self.popDelegate popsScrollView:self cellAtIndexPath:indexPath];
            [self.visibleCells addObject:cell];
            [cell setFrame:[self frameForCellAtIndexPath:indexPath]];
            [self addSubview:cell];
        }
    }
}

- (void)reloadData
{
    [self updateVisibleCells];
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Adjust page
    //self.currentPage = floorf(scrollView.contentOffset.x / PlaceSquareView.size.width);
    //[self updateVisibleCells];
}

@end
