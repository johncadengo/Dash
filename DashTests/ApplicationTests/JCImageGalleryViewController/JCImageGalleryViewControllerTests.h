//
//  JCImageGalleryViewControllerTests.h
//  Dash
//
//  Created by John Cadengo on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

//  Application unit tests contain unit test code that must be injected into an application to run correctly.
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import "DashTests.h"

@class JCImageGalleryViewController;
@class JCViewController;
@class JCPinholeViewController;
@class JCGalleryViewController;
@class JCSpotlightViewController;

@interface JCImageGalleryViewControllerTests : DashTests

@property (nonatomic, strong) JCImageGalleryViewController *imageGalleryViewController;
@property (nonatomic, strong) JCViewController *currentViewController;
@property (nonatomic, strong) JCPinholeViewController *pinholeViewController;
@property (nonatomic, strong) JCGalleryViewController *galleryViewController;
@property (nonatomic, strong) JCSpotlightViewController *spotlightViewController;

- (BOOL)checkRectNotZero:(CGRect)rect;

@end
