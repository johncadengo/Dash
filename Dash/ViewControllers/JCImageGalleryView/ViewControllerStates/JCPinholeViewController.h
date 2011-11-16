//
//  JCPinholeViewController.h
//  Dash
//
//  Created by John Cadengo on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCViewController.h"

@interface JCPinholeViewController : JCViewController <JCImageGalleryViewState>

/** Let's keep track of our imageview frames so we can know if they were touched
 */
@property (nonatomic, strong) NSMutableArray *imageViewFrames;

+ (CGFloat)xForImageIndex:(NSInteger)index;
+ (CGFloat)yForImageIndex:(NSInteger)index;
+ (CGPoint)originForImageIndex:(NSInteger)index;
+ (CGSize)contentSizeForNumImages:(NSInteger)numImages;
+ (NSInteger)pageForOffset:(NSInteger)offset;
+ (NSInteger)pageForOrigin:(CGPoint)origin;
+ (CGPoint)originForPage:(NSInteger)page;




- (void)layoutImageViews:(NSMutableArray *)imageViews inFrame:(CGRect)frame;

- (void)prepareLayoutWithImageViews:(NSMutableArray *)imageViews offset:(NSInteger)offset;

- (void)setContentView;
- (void)setContentOffset:(NSInteger)offset;

@end
