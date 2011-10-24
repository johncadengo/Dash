//
//  DashAPI.h
//  Dash
//
//  Created by John Cadengo on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSONDecoder;

@interface DashAPI : NSObject

@property (nonatomic, strong) JSONDecoder *JSON;

@end
