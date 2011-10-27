//
//  Photo.h
//  Dash
//
//  Created by John Cadengo on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Action.h"

@class FlagPhoto;

@interface Photo : Action

@property (nonatomic, retain) NSString * localpath;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *flags;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addFlagsObject:(FlagPhoto *)value;
- (void)removeFlagsObject:(FlagPhoto *)value;
- (void)addFlags:(NSSet *)values;
- (void)removeFlags:(NSSet *)values;
@end
