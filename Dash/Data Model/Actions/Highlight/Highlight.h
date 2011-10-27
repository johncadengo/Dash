//
//  Highlight.h
//  Dash
//
//  Created by John Cadengo on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PlaceAction.h"

@class HighlightPhoto;

@interface Highlight : PlaceAction

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Highlight (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(HighlightPhoto *)value;
- (void)removePhotosObject:(HighlightPhoto *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;
@end
