//
//  LocationTests.h
//  Dash
//
//  Created by John Cadengo on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import "DashTests.h"

@class Location;

@interface LocationTests : DashTests

@property (nonatomic, strong) PlaceLocation *thompsonApt;
@property (nonatomic, strong) PlaceLocation *macDougal;

/** Checks that the cascading values were calculated properly.
 */
- (void) checkCascadingCalculations:(Location *)location;

@end
