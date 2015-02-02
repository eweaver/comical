//
//  PCComicSource+Parse.m
//  Comical
//
//  Created by Eric Weaver on 5/27/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "PCSource+Parse.h"

@implementation PCSource (Parse)

- (id) init:(PFObject *)sourceObject {
    self = [super init];
    
    if(self) {
        self.objectId = sourceObject.objectId;
        self.name = [sourceObject objectForKey:@"name"];
        self.baseUri = [sourceObject objectForKey:@"baseUri"];
        self.lastUri = [sourceObject objectForKey:@"lastUri"];
        self.itemFormat = [sourceObject objectForKey:@"itemFormat"];
        self.isCollection = [[sourceObject objectForKey:@"isCollection"] boolValue];
        self.type = [sourceObject objectForKey:@"type"];
        self.useWebView = [[sourceObject objectForKey:@"useWebView"] boolValue];
        self.regexPrevious = [sourceObject objectForKey:@"regexPrevious"];
        self.regexNext = [sourceObject objectForKey:@"regexNext"];
        self.regexImage = [sourceObject objectForKey:@"regexImage"];
        self.regexTitle = [sourceObject objectForKey:@"regexTitle"];
        self.regexAlt = [sourceObject objectForKey:@"regexAlt"];
        self.updatedAt = [sourceObject objectForKey:@"updatedAt"];
    }
    
    return self;
}

+ (void) fetchSource:(NSString *)objectId onComplete:(void (^)(PCSource *source, NSError *error))onComplete {
    PFQuery *query = [PFQuery queryWithClassName:@"Source"];
    [query getObjectInBackgroundWithId:objectId block:^(PFObject *object, NSError *error) {
        if(!error) {
            PCSource *source = [[PCSource alloc] init:object];
            onComplete(source, nil);
        } else {
            onComplete(nil, error);
        }
    }];
}

+ (void) fetchAll:(void (^)(NSArray *sources, NSError *error))onComplete {
    PFQuery *query = [PFQuery queryWithClassName:@"Source"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            NSMutableArray *sourceArray = [[NSMutableArray alloc] initWithCapacity:objects.count];
            
            for(PFObject *sourceObject in objects) {
                PCSource *source = [[PCSource alloc] init:sourceObject];
                [sourceArray addObject:source];
            }
            
            onComplete([NSArray arrayWithArray:sourceArray], nil);
        } else {
            onComplete(nil, error);
        }
    }];
}

+ (void) fetchNewForInstallation:(void (^)(BOOL succeeded, NSError *error))onComplete {
    [PCSource fetchAll:^(NSArray *sources, NSError *error) {
        if(!error) {
            [PCSource fetchAllForInstallation:^(NSArray *installSources, NSError *error) {
                if(!error) {
                    NSMutableArray *allAvailable = [[NSMutableArray alloc] initWithCapacity:sources.count];
                    NSMutableDictionary *sourceData = [[NSMutableDictionary alloc]  initWithCapacity:allAvailable.count];
                    for(PCSource *source in sources) {
                        [allAvailable addObject:source.objectId];
                        [sourceData setObject:source forKey:source.objectId];
                    }
                    
                    if(installSources.count > 0) {
                        NSMutableArray *installAvailable = [[NSMutableArray alloc] initWithCapacity:installSources.count];
                        for(NSDictionary *sourceInfo in installSources) {
                            [installAvailable addObject:[sourceInfo objectForKey:@"objectId"]];
                        }
                    
                        [allAvailable removeObjectsInArray:installAvailable];
                    }
                    
                    // New
                    if(allAvailable.count > 0) {
                        NSMutableArray *newInstallAvailable = [NSMutableArray arrayWithArray:installSources];
                        for(NSString *sourceId in allAvailable) {
                            PCSource *source = [sourceData objectForKey:sourceId];
                            NSDictionary *sourceDict = @{@"objectId":sourceId, @"name":source.name, @"enabled":@NO, @"lastUri":@""};
                            [newInstallAvailable addObject:sourceDict];
                        }
                        
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:newInstallAvailable forKey:@"sources"];
                        [defaults synchronize];
                    }
                    
                    onComplete(YES, nil);
                } else {
                    onComplete(NO, error);
                }
            }];
        } else {
            onComplete(NO, error);
        }
    }];
}

+ (NSArray *) fetchAllForInstallationSync:(BOOL)enabled {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"sources"] != nil) {
        NSMutableArray *onlyEnabled = [[NSMutableArray alloc] init];
        for(NSDictionary *sourceData in [defaults objectForKey:@"sources"]) {
            if([[sourceData objectForKey:@"enabled"] boolValue] == enabled) {
                [onlyEnabled addObject:sourceData];
            }
        }
        
        return [NSArray arrayWithArray:onlyEnabled];
    }
    
    return @[];
}

+ (void) fetchAllForInstallation:(void (^)(NSArray *sources, NSError *error))onComplete {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"sources"] != nil) {
        onComplete([defaults objectForKey:@"sources"], nil);
    } else {
        onComplete(@[], nil);
    }
    
}

+ (void) fetchAllForInstallation:(BOOL)enabled onComplete:(void (^)(NSArray *sources, NSError *error))onComplete {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"sources"] != nil) {
        NSMutableArray *onlyEnabled = [[NSMutableArray alloc] init];
        for(NSDictionary *sourceData in [defaults objectForKey:@"sources"]) {
            if([[sourceData objectForKey:@"enabled"] boolValue] == enabled) {
                [onlyEnabled addObject:sourceData];
            }
        }
        onComplete([NSArray arrayWithArray:onlyEnabled], nil);
    } else {
        onComplete(@[], nil);
    }
}

+ (void) updateLastUri:(NSString *)sourceId lastUri:(NSString *)lastUri {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"sources"] != nil) {
        NSMutableArray *sources = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"sources"]];
        NSMutableArray *newSources = [[NSMutableArray alloc] initWithCapacity:sources.count];
        for (NSInteger index = 0; index < sources.count; ++index) {
            NSMutableDictionary *sourceDict = [[NSMutableDictionary alloc] initWithDictionary:[sources objectAtIndex:index]];
            if([[sourceDict objectForKey:@"objectId"] isEqualToString:sourceId]) {
                [sourceDict setObject:lastUri forKey:@"lastUri"];
            }
            
            [newSources addObject:sourceDict];
        }
        
        [defaults setObject:newSources forKey:@"sources"];
        [defaults synchronize];
    }
}

+ (void) toggleSource:(NSString *)sourceId isEnabled:(BOOL)enabled onComplete:(void (^)(NSArray *sources, NSError *error))onComplete {
    
}

@end
