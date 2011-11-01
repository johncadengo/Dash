//
//  Footprint.m
//  Dash
//
//  Created by John Cadengo on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Footprint.h"
#import "Photo.h"
#import "PersonPhoto.h"
#import "Person.h"
#import "Person+Helper.h"
#import "Action.h"
#import "NSDateHelper.h"

// Private
@interface Footprint ()

@property (nonatomic, strong) Person *author;
@property (nonatomic, strong) Photo *photo;
@property (nonatomic, strong) Action *action;

- (NSURL *)URLWithPhoto:(Photo *)photo;
- (NSString *)blurbFromAction:(Action *)action;
- (NSString *)longagoFromAction:(Action *)action;

@end

@implementation Footprint

// Synthesize private ivars
@synthesize author = _author;
@synthesize photo = _photo;
@synthesize action = _action;

// Public ivars
@synthesize photoURL = _photoURL;
@synthesize blurb = _blurb;
@synthesize longago = _longago;

/** Don't use init. It will be useless without an Action.
 */
- (id)init 
{
    return [self initWithAction:nil];
}

- (id)initWithAction:(Action*) action
{
    self = [super init];
    
    if (self) {
        // We need an Action!
        if (action) {
            self.author = [action author];
            self.photo = [self.author profilepic];
            self.action = action;
            self.photoURL = [self URLWithPhoto: self.photo];
            self.blurb = [self blurbFromAction: self.action];
            self.longago = [self longagoFromAction: self.action];
        }
        else {
            return nil;
        }
    }
    
    return self;
}

#pragma - Helper methods for initWithAction
/** Gets the URL from the Photo object, but also needs to consider caching one day.
 */
- (NSURL *)URLWithPhoto:(Photo *)photo
{
    return [NSURL URLWithString:@"http://thegospelcoalition.org/images/nav/small/icon_blog_TGC.png"];
}

/** Eventually needs to branch out depending on the type of Action: Highlight, Comment, etc.
    TODO: Branch depending on what kind of Action is taking places. For now, stub.
 */
- (NSString *)blurbFromAction:(Action *)action
{
    return [NSString stringWithFormat: @"Laura Byun likes lemonade with mint tea leaves."];
}

/** Returns the name of the author of the string
 */
- (NSString *)longagoFromAction:(Action *)action
{
    return [NSString stringWithFormat: @"2 days ago"];
}

@end
