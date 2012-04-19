//
//  CustomSegment.h
//  Dash
//
//  Created by John Cadengo on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSegmentView : UIView

@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, getter=isLeftSelected) BOOL leftSelected;

@end
