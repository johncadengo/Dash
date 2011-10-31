//
//  Footprint.m
//  Dash
//
//  Created by John Cadengo on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Footprint.h"
#import "Photo.h"
#import "Person.h"
#import "Person+Helper.h"
#import "Action.h"

// Private properties
@interface Footprint ()

@property (nonatomic, strong) Photo *photo;
@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) Action *action;

@end

@implementation Footprint

// Private ivars
@synthesize photo = _photo;
@synthesize person = _person;
@synthesize action = _action;

// Public ivars
@synthesize photourl = _photourl;
@synthesize blurb = _blurb;
@synthesize longago = _longago;
@synthesize author = _author;

- (id)init 
{
    self = [super init];
    
    if (self) {
        self.photourl = [[NSURL alloc] init];
        self.blurb = [[NSString alloc] init];
        self.longago = [[NSString alloc] init];
    }
    
    return self;
}

- (id)initWithAction:(Action*) action
{
    self = [self init];
    
    if (self) {
        return self;
    }
    
    return self;
}

@end
