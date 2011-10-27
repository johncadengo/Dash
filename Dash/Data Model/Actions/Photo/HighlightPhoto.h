//
//  HighlightPhoto.h
//  Dash
//
//  Created by John Cadengo on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Photo.h"

@class Highlight;

@interface HighlightPhoto : Photo

@property (nonatomic, retain) Highlight *highlight;

@end
