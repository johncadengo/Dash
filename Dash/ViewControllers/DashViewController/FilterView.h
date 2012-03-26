//
//  FilterView.h
//  Dash
//
//  Created by John Cadengo on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterView : UIView


- (void)drawHorizontalLineStartingAt:(CGPoint)origin withLength:(CGFloat)length;
- (void)drawHeader:(NSString *)text at:(CGPoint)origin;

@end
