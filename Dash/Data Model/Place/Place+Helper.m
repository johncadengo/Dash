//
//  Place+Place_Helper.m
//  Dash
//
//  Created by John Cadengo on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Place+Helper.h"
#import "Category.h"
#import "DashAPI.h"
#import "Constants.h"

@implementation Place (Helper)

enum {
    kCategoriesDescriptionShortLength = 22,
    kCategoriesDescriptionLongLength = 28,
};

+ (NSDictionary *)categoriesDictionary
{
    static dispatch_once_t pred;
    static NSDictionary *categoriesDictionary = nil;
    dispatch_once(&pred, ^{
        categoriesDictionary = [NSDictionary dictionaryWithKeysAndObjects:
                                [NSNumber numberWithInt:kCategoryAmerican],@"American",
                                [NSNumber numberWithInt:kCategoryAsianNoodles],@"AsianNoodles",
                                [NSNumber numberWithInt:kCategoryBbq],@"Bbq",
                                [NSNumber numberWithInt:kCategoryBlender],@"Blender",
                                [NSNumber numberWithInt:kCategoryBurger],@"Burger",
                                [NSNumber numberWithInt:kCategoryButcher],@"Butcher",
                                [NSNumber numberWithInt:kCategoryChef],@"Chef",
                                [NSNumber numberWithInt:kCategoryChicken],@"Chicken",
                                [NSNumber numberWithInt:kCategoryCocktail],@"Cocktail",
                                [NSNumber numberWithInt:kCategoryDonut],@"Donut",
                                [NSNumber numberWithInt:kCategoryHotSauce],@"HotSauce",
                                [NSNumber numberWithInt:kCategoryKettle],@"Kettle",
                                [NSNumber numberWithInt:kCategoryOlives],@"Olives",
                                [NSNumber numberWithInt:kCategoryPizza],@"Pizza",
                                [NSNumber numberWithInt:kCategoryPlates],@"Plates",
                                [NSNumber numberWithInt:kCategorySalad],@"Salad",
                                [NSNumber numberWithInt:kCategorySandwich],@"Sandwich",
                                [NSNumber numberWithInt:kCategoryShamrock],@"Shamrock",
                                [NSNumber numberWithInt:kCategorySoup],@"Soup",
                                [NSNumber numberWithInt:kCategorySpanishChicken],@"SpanishChicken",
                                [NSNumber numberWithInt:kCategoryTaco],@"Taco",
                                [NSNumber numberWithInt:kCategoryWine],@"Wine",nil];
    });
    return categoriesDictionary;
}

+ (NSDictionary *)flattenCategoriesDictionary
{
    static dispatch_once_t pred;
    static NSDictionary *flatCategoriesDictionary = nil;
    dispatch_once(&pred, ^{
        flatCategoriesDictionary = [NSDictionary dictionaryWithKeysAndObjects:
                                    @"american", [NSNumber numberWithInt:kCategoryAmerican],
                                    @"asian", [NSNumber numberWithInt:kCategoryAsianNoodles],
                                    @"asian fusion", [NSNumber numberWithInt:kCategoryAsianNoodles],
                                    @"chinese", [NSNumber numberWithInt:kCategoryAsianNoodles],
                                    @"pan-asian", [NSNumber numberWithInt:kCategoryAsianNoodles],
                                    @"noodle shop", [NSNumber numberWithInt:kCategoryAsianNoodles],
                                    @"ramen", [NSNumber numberWithInt:kCategoryAsianNoodles],
                                    @"thai", [NSNumber numberWithInt:kCategoryAsianNoodles],
                                    @"bbq", [NSNumber numberWithInt:kCategoryBbq],
                                    @"teppan grill", [NSNumber numberWithInt:kCategoryBbq],
                                    @"filipino", [NSNumber numberWithInt:kCategoryBbq],
                                    @"laotian", [NSNumber numberWithInt:kCategoryBbq],
                                    @"malaysian", [NSNumber numberWithInt:kCategoryBbq],
                                    @"singaporean", [NSNumber numberWithInt:kCategoryBbq],
                                    @"indonesian", [NSNumber numberWithInt:kCategoryBbq],
                                    @"sri lankan", [NSNumber numberWithInt:kCategoryBbq],
                                    @"himalayan", [NSNumber numberWithInt:kCategoryBbq],
                                    @"burmese", [NSNumber numberWithInt:kCategoryBbq],
                                    @"mongolian", [NSNumber numberWithInt:kCategoryBbq],
                                    @"smoothies", [NSNumber numberWithInt:kCategoryBlender],
                                    @"juice/smoothie", [NSNumber numberWithInt:kCategoryBlender],
                                    @"burger", [NSNumber numberWithInt:kCategoryBurger],
                                    @"meat shop", [NSNumber numberWithInt:kCategoryButcher],
                                    @"french", [NSNumber numberWithInt:kCategoryChef],
                                    @"creperie", [NSNumber numberWithInt:kCategoryChef],
                                    @"cheese shop", [NSNumber numberWithInt:kCategoryChef],
                                    @"southern", [NSNumber numberWithInt:kCategoryChicken],
                                    @"chicken", [NSNumber numberWithInt:kCategoryChicken],
                                    @"fried chicken", [NSNumber numberWithInt:kCategoryChicken],
                                    @"soul food", [NSNumber numberWithInt:kCategoryChicken],
                                    @"dance club", [NSNumber numberWithInt:kCategoryCocktail],
                                    @"lounge", [NSNumber numberWithInt:kCategoryCocktail],
                                    @"night club", [NSNumber numberWithInt:kCategoryCocktail],
                                    @"hookah bar", [NSNumber numberWithInt:kCategoryCocktail],
                                    @"jazz club", [NSNumber numberWithInt:kCategoryCocktail],
                                    @"piano bar", [NSNumber numberWithInt:kCategoryCocktail],
                                    @"live music", [NSNumber numberWithInt:kCategoryCocktail],
                                    @"karoke", [NSNumber numberWithInt:kCategoryCocktail],
                                    @"donuts", [NSNumber numberWithInt:kCategoryDonut],
                                    @"venezuelan", [NSNumber numberWithInt:kCategoryHotSauce],
                                    @"nicaraguan", [NSNumber numberWithInt:kCategoryHotSauce],
                                    @"salvadorian", [NSNumber numberWithInt:kCategoryHotSauce],
                                    @"uruguayan", [NSNumber numberWithInt:kCategoryHotSauce],
                                    @"guyanese", [NSNumber numberWithInt:kCategoryHotSauce],
                                    @"latin american", [NSNumber numberWithInt:kCategoryHotSauce],
                                    @"caribbean", [NSNumber numberWithInt:kCategoryHotSauce],
                                    @"cajun", [NSNumber numberWithInt:kCategoryHotSauce],
                                    @"cuban", [NSNumber numberWithInt:kCategoryHotSauce],
                                    @"hawaiian", [NSNumber numberWithInt:kCategoryHotSauce],
                                    @"haitian", [NSNumber numberWithInt:kCategoryHotSauce],
                                    @"dominican", [NSNumber numberWithInt:kCategoryHotSauce],
                                    @"guatemalan", [NSNumber numberWithInt:kCategoryHotSauce],
                                    @"guamanian", [NSNumber numberWithInt:kCategoryHotSauce],
                                    @"spanish", [NSNumber numberWithInt:kCategoryHotSauce],
                                    @"polynesian", [NSNumber numberWithInt:kCategoryHotSauce],
                                    @"trinidadian", [NSNumber numberWithInt:kCategoryHotSauce],
                                    @"south american", [NSNumber numberWithInt:kCategoryHotSauce],
                                    @"german", [NSNumber numberWithInt:kCategoryKettle],
                                    @"belgian", [NSNumber numberWithInt:kCategoryKettle],
                                    @"austrian", [NSNumber numberWithInt:kCategoryKettle],
                                    @"czech", [NSNumber numberWithInt:kCategoryKettle],
                                    @"polish", [NSNumber numberWithInt:kCategoryKettle],
                                    @"slovakian", [NSNumber numberWithInt:kCategoryKettle],
                                    @"scandinavian", [NSNumber numberWithInt:kCategoryKettle],
                                    @"dutch", [NSNumber numberWithInt:kCategoryKettle],
                                    @"hungarian", [NSNumber numberWithInt:kCategoryKettle],
                                    @"swedish", [NSNumber numberWithInt:kCategoryKettle],
                                    @"mediterranean", [NSNumber numberWithInt:kCategoryOlives],
                                    @"greek", [NSNumber numberWithInt:kCategoryOlives],
                                    @"pizza", [NSNumber numberWithInt:kCategoryPizza],
                                    @"buffet", [NSNumber numberWithInt:kCategoryPlates],
                                    @"food court", [NSNumber numberWithInt:kCategoryPlates],
                                    @"yakitori", [NSNumber numberWithInt:kCategoryPlates],
                                    @"tapas", [NSNumber numberWithInt:kCategoryPlates],
                                    @"tapas bars", [NSNumber numberWithInt:kCategoryPlates],
                                    @"basque", [NSNumber numberWithInt:kCategoryPlates],
                                    @"indian", [NSNumber numberWithInt:kCategoryPlates],
                                    @"bengali", [NSNumber numberWithInt:kCategoryPlates],
                                    @"pakistani", [NSNumber numberWithInt:kCategoryPlates],
                                    @"nepalese", [NSNumber numberWithInt:kCategoryPlates],
                                    @"tibetan", [NSNumber numberWithInt:kCategoryPlates],
                                    @"uyghur", [NSNumber numberWithInt:kCategoryPlates],
                                    @"salads", [NSNumber numberWithInt:kCategorySalad],
                                    @"vegan", [NSNumber numberWithInt:kCategorySalad],
                                    @"vegetarian", [NSNumber numberWithInt:kCategorySalad],
                                    @"macrobiotic", [NSNumber numberWithInt:kCategorySalad],
                                    @"organic", [NSNumber numberWithInt:kCategorySalad],
                                    @"health food", [NSNumber numberWithInt:kCategorySalad],
                                    @"gluten free", [NSNumber numberWithInt:kCategorySalad],
                                    @"deli", [NSNumber numberWithInt:kCategorySandwich],
                                    @"cheesesteaks", [NSNumber numberWithInt:kCategorySandwich],
                                    @"wraps", [NSNumber numberWithInt:kCategorySandwich],
                                    @"sandwiches", [NSNumber numberWithInt:kCategorySandwich],
                                    @"irish", [NSNumber numberWithInt:kCategoryShamrock],
                                    @"dim sum", [NSNumber numberWithInt:kCategorySoup],
                                    @"taiwanese", [NSNumber numberWithInt:kCategorySoup],
                                    @"rice bowls", [NSNumber numberWithInt:kCategorySoup],
                                    @"shabu shabu", [NSNumber numberWithInt:kCategorySoup],
                                    @"korean", [NSNumber numberWithInt:kCategorySoup],
                                    @"vietnamese", [NSNumber numberWithInt:kCategorySoup],
                                    @"costa rican", [NSNumber numberWithInt:kCategorySpanishChicken],
                                    @"peruvian", [NSNumber numberWithInt:kCategorySpanishChicken],
                                    @"puerto rican", [NSNumber numberWithInt:kCategorySpanishChicken],
                                    @"mexican", [NSNumber numberWithInt:kCategoryTaco],
                                    @"tex mex", [NSNumber numberWithInt:kCategoryTaco],
                                    @"taqueria", [NSNumber numberWithInt:kCategoryTaco],
                                    @"wine bar", [NSNumber numberWithInt:kCategoryWine],
                                    @"winery", [NSNumber numberWithInt:kCategoryWine],
                                    @"cocktail bar", [NSNumber numberWithInt:kCategoryWine],nil];
    });
    return flatCategoriesDictionary;
}


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

- (BOOL)recommendedByMe
{
    return [[self.recommends objectsPassingTest:^BOOL(id obj,BOOL *stop){
        Person *author = (Person *)obj;
        Person *me = DashAPI.me;
        return ([me.fb_uid isEqualToString:author.fb_uid]) ? YES : NO;
    }] count];
}

- (BOOL)savedByMe
{
    return [[self.saves objectsPassingTest:^BOOL(id obj,BOOL *stop){
        Person *author = (Person *)obj;
        Person *me = DashAPI.me;
        return ([me.fb_uid isEqualToString:author.fb_uid]) ? YES : NO;
    }] count];
}

- (UIImage *)categoryIconLarge
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"Main_%@", 
                                [self categoryIconBaseFilename]]];
}

- (UIImage *)categoryIconSmall
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"Search_%@", 
                                [self categoryIconBaseFilename]]];    
}

- (UIImage *)categoryIconForThemeColor:(PlaceThemeColor)themeColor
{
    // TODO: Multiple colors. For now, just always orange.
    return [UIImage imageNamed:[NSString stringWithFormat:@"Profile_Orange_%@", 
                                [self categoryIconBaseFilename]]];    
}

- (NSString *)categoryIconBaseFilename
{
    NSArray *categories = [self.categories allObjects];
    Category *category;
    NSNumber *type;
    int i = 0;
    
    while (!type && i < categories.count) {
        category = [categories objectAtIndex:i];
        type = [[self.class flattenCategoriesDictionary] objectForKey:category.name];
        ++i;
    }
    
    NSString *filename;
    if (type) {
        filename = [[self.class categoriesDictionary] objectForKey:type];
    }
    else {
        filename = [[self.class categoriesDictionary] objectForKey:
                    [NSNumber numberWithInt:kCategoryAmerican]];
    }
    
    NSLog(@"%@", filename);
    return filename;
}

@end
