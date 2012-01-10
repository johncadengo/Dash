//
//  Place+Place_Helper.m
//  Dash
//
//  Created by John Cadengo on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Place+Helper.h"
#import "Category.h"

@implementation Place (Helper)

- (NSString*)categoriesDescription
{
    NSMutableString *categoryInfo = [[NSMutableString alloc] init];
    NSArray *categoriesArray = [self.categories allObjects];
    Category *lastCategory = [categoriesArray lastObject];
    
    for (Category *category in categoriesArray) {
        if (category == lastCategory) {
            [categoryInfo appendFormat:@"%@", category.name];
        }
        else {
            [categoryInfo appendFormat:@"%@ / ", category.name];            
        }
    }
    
    return categoryInfo;
}

@end
