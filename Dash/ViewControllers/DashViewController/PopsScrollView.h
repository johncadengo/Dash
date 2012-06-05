//
//  PopsScrollView.h
//  Dash
//
//  Created by John Cadengo on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlaceSquareView;
@class PopsScrollView;

@protocol PopsScrollViewDelegate <NSObject>

- (PlaceSquareView *)popsScrollView:(PopsScrollView *)popsScrollView cellAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface PopsScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *availableCells;
@property (nonatomic, strong) NSMutableArray *visibleCells;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, weak) id <PopsScrollViewDelegate> popDelegate;

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate;
- (CGRect)frameForCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)updateVisibleCells;
- (void)reloadData;
- (PlaceSquareView *)dequeueReuseableCellAtIndexPath:(NSIndexPath *)indexPath;

@end
