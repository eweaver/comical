//
//  PCComicSource+Parse.h
//  Comical
//
//  Created by Eric Weaver on 5/27/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "PCSource.h"
#import <Parse/Parse.h>

@interface PCSource (Parse)

- (id) init:(PFObject *)sourceObject;

+ (void) fetchSource:(NSString *)objectId onComplete:(void (^)(PCSource *source, NSError *error))onComplete;
+ (void) fetchAll:(void (^)(NSArray *sources, NSError *error))onComplete;

+ (NSArray *) fetchAllForInstallationSync:(BOOL)enabled;
+ (void) fetchNewForInstallation:(void (^)(BOOL succeeded, NSError *error))onComplete;
+ (void) fetchAllForInstallation:(void (^)(NSArray *sources, NSError *error))onComplete;
+ (void) fetchAllForInstallation:(BOOL)enabled onComplete:(void (^)(NSArray *sources, NSError *error))onComplete;

+ (void) updateLastUri:(NSString *)sourceId lastUri:(NSString *)lastUri;

+ (void) toggleSource:(NSString *)sourceId isEnabled:(BOOL)enabled onComplete:(void (^)(NSArray *sources, NSError *error))onComplete;

@end
