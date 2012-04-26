//
//  Highlight.h
//  Dash
//
//  Created by John Cadengo on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Like, Person, Place;

@interface Highlight : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSNumber * likecount;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) Place *place;
@property (nonatomic, retain) Person *author;
@property (nonatomic, retain) NSSet *likes;
@end

@interface Highlight (CoreDataGeneratedAccessors)

- (void)addLikesObject:(Like *)value;
- (void)removeLikesObject:(Like *)value;
- (void)addLikes:(NSSet *)values;
- (void)removeLikes:(NSSet *)values;

@end
