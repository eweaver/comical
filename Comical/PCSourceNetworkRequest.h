//
//  PCSourceNetworkRequest.h
//  Comical
//
//  Created by Eric Weaver on 5/28/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCSource+Parse.h"
#import "PCSourceItem.h"

@interface PCSourceNetworkRequest : NSObject

@property (strong, nonatomic) NSString *nextUrl;
@property (assign, nonatomic) BOOL requestInProgress;

- (id)initWithMaxDepth:(NSInteger)maxDepth;
- (id)initWithFinalUri:(NSString *)finalUri;

- (void) fetchBaseUri:(PCSource *)source withUrl:(NSString *)url onItemComplete:(void (^)(PCSourceItem *sourceItem, NSError *error))onItemComplete onAllComplete:(void (^)(void))onAllComplete;

@end
