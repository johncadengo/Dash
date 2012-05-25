//
//  Place+Place_Helper.h
//  Dash
//
//  Created by John Cadengo on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Place.h"
#import "PlaceViewController.h"

// White is for the four squares page, and grey is for the restaurant profile
typedef enum {
    kStarsColorWhite = 0,
    kStarsColorGrey = 1
} kStarsColor;

@interface Place (Helper)

+ (NSDictionary *)categoriesDictionary;
+ (NSDictionary *)flattenCategoriesDictionary;

- (NSString *)categoriesDescriptionShort;
- (NSString *)categoriesDescriptionLong;
- (NSString *)categoriesDescriptionWithLimit:(NSInteger)limit;

- (BOOL)recommendedByMe;
- (BOOL)savedByMe;

/** For Main Screen. Large, white.
 */
- (UIImage *)categoryIconLarge;

/** For search results (and favorites, etc.). Small, black.
 */
- (UIImage *)categoryIconSmall;

/** For place profile page. Colored.
 */
- (UIImage *)categoryIconForThemeColor:(PlaceThemeColor)themeColor;

/** Generates the base file name (i.e. "Taco.png") 
 *  for constructing the actual file name (i.e. "Main_Taco.png")
 */
- (NSString *)categoryIconBaseFilename;

/** Returns the stars filename depending on what color we want.
 */
- (NSString *)filenameForStarsColor:(kStarsColor)color;

/** Number of ratings formatted to be human readable, i.e. <50, 50+, 100+, 200+, and so on.
 */
- (NSString *)numRatingsDescription;

@end
