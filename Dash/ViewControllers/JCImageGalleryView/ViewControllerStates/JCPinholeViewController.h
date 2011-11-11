//
//  JCPinholeViewController.h
//  Dash
//
//  Created by John Cadengo on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCViewController.h"

@interface JCPinholeViewController : JCViewController

/** Let's keep track of our imageview frames so we can know if they were touched
 */
@property (nonatomic, strong) NSMutableArray *imageViewFrames;

/** From: http://stackoverflow.com/questions/3552108/finding-closest-object-to-cgpoint/3556025#3556025
 */
- (CGFloat)distanceBetweenRect:(CGRect)rect andPoint:(CGPoint)point;

@end
