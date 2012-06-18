//
//  NewsItem+Helper.h
//  Dash
//
//  Created by John Cadengo on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewsItem.h"

@interface NewsItem (Helper)

- (NSString *)relativeTimestamp;
- (NSComparisonResult)compare:(NewsItem *)other;

@end
