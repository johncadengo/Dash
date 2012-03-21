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

enum {
    kCategoriesDescriptionShortLength = 22,
    kCategoriesDescriptionLongLength = 32,
};


- (NSString*)categoriesDescriptionShort
{
    return [self categoriesDescriptionWithLimit:kCategoriesDescriptionShortLength];
}

- (NSString*)categoriesDescriptionLong
{
    return [self categoriesDescriptionWithLimit:kCategoriesDescriptionLongLength];    
}

- (NSString*)categoriesDescriptionWithLimit:(NSInteger)limit
{
    NSMutableString *categoryInfo = [[NSMutableString alloc] init];
    NSArray *categoriesArray = [self.categories allObjects];
    Category *lastCategory = [categoriesArray lastObject];
    
    for (Category *category in categoriesArray) {
        NSString *toAdd;
        if (category == lastCategory) {
            toAdd = [NSString stringWithFormat:@"%@", category.name];
        }
        else {
            toAdd = [NSString stringWithFormat:@"%@, ", category.name];    
        }
        
        // Add the next category
        [categoryInfo appendString:toAdd];
        
        // Check if the new string is too long
        if ([categoryInfo length] > limit) {
            // If it is.. Let's remove what we just added
            [categoryInfo replaceOccurrencesOfString:toAdd withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [categoryInfo length])];
            
            // And we may need to remove the trailing comma
            if ([categoryInfo length] > 0) {
                [categoryInfo replaceOccurrencesOfString:@", " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [categoryInfo length])];
            }
        }
    }
    
    return [categoryInfo capitalizedString];
}

@end
