//
//  PCLiveStreamDataReader.m
//  Comical
//
//  Created by Eric Weaver on 5/27/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "PCLiveStreamDataReader.h"
#import "PCSource+Parse.h"
#import "PCSourceItem.h"
#import "PCSourceNetworkRequest.h"

@interface PCLiveStreamDataReader ()

@property (strong, nonatomic) NSArray *sources;
@property (strong, nonatomic) NSMutableArray *sourceItems;
@property (strong, nonatomic) NSMutableDictionary *sourceRequestHandlers;
@property (assign, nonatomic) NSInteger maxDepth;
@property (assign, nonatomic) BOOL isLoadingData;
@property (assign, nonatomic) __block NSInteger numAllComplete;

@end

@implementation PCLiveStreamDataReader

- (id) init {
    self = [super init];
    if(self) {
        _sourceItems = [[NSMutableArray alloc] init];
        _maxDepth = 1;
        _isLoadingData = YES;
        _numAllComplete = 0;
    }
    
    return self;
}

- (void) loadSources:(NSArray *)enabledSources onComplete:(void (^)(BOOL succeeded, NSError *error))onComplete {
    [PCSource fetchAll:^(NSArray *sources, NSError *error) {
        if(!error) {
            NSMutableArray *tmpSources = [[NSMutableArray alloc] initWithCapacity:enabledSources.count];
            for(NSDictionary *sourceData in enabledSources) {
                for(PCSource *source in sources) {
                    if([[sourceData objectForKey:@"objectId"] isEqualToString:source.objectId]) {
                        [tmpSources addObject:source];
                        break;
                    }
                }
            }
            
            self.sources = [NSArray arrayWithArray:tmpSources];
            if(self.sources.count > 10) {
                self.maxDepth = 1;
            } else {
                self.maxDepth = (NSInteger) (8 / self.sources.count) + 1;
            }
            
            self.sourceRequestHandlers = [[NSMutableDictionary alloc] initWithCapacity:self.sources.count];
            for (NSInteger index = 0; index < self.sources.count; ++index) {
                PCSource *source = [self.sources objectAtIndex:index];
                [self.sourceRequestHandlers setObject:[[PCSourceNetworkRequest alloc] initWithMaxDepth:self.maxDepth] forKey:source.objectId];
            }
 
            onComplete(YES, nil);
        } else {
            onComplete(NO, error);
        }
    }];
}

- (void) fetchSourceItems:(void (^)(BOOL succeeded, NSError *error))onComplete {
    if(self.sources.count < 1) {
        onComplete(NO, nil);
    }
    
    self.isLoadingData = YES;
    
    for (NSInteger index = 0; index < self.sources.count; ++index) {
        PCSource *source = [self.sources objectAtIndex:index];
        [self fetchSource:source withUrl:source.baseUri onComplete:^(PCSourceItem *sourceItem, NSError *error) {
            if(error) {
                onComplete(NO, error);
            } else {
                if(sourceItem) {
                  [self.sourceItems addObject:sourceItem];
                }
                //[[self.sourceRequestHandlers objectForKey:sourceItem.source.objectId] setNextUrl:sourceItem.next];
                onComplete(YES, nil);
            }
        }];
    }
}

- (void) fetchSourceItemsBatch:(void (^)(BOOL succeeded, NSError *error))onComplete {
    if(self.sources.count < 1) {
        onComplete(NO, nil);
    }
    
    if(self.isLoadingData == YES) {
        return;
    }
    
    self.isLoadingData = YES;
    
    for (NSInteger index = 0; index < self.sources.count; ++index) {
        PCSource *source = [self.sources objectAtIndex:index];
        PCSourceNetworkRequest *sourceRequest = [self.sourceRequestHandlers objectForKey:source.objectId];
        
        [self fetchSource:source withUrl:sourceRequest.nextUrl onComplete:^(PCSourceItem *sourceItem, NSError *error) {
            if(error) {
                onComplete(NO, error);
            } else {
                if(sourceItem) {
                    [self.sourceItems addObject:sourceItem];
                }
                //[[self.sourceRequestHandlers objectForKey:sourceItem.source.objectId] setNextUrl:sourceItem.next];
                onComplete(YES, nil);
            }
        }];
    }
}

# pragma mark control

- (BOOL) canLoadMore {
    return ! self.isLoadingData;
}

# pragma mark getters

- (NSArray *) getSourceItems {
    return self.sourceItems;
}

- (PCSourceItem *) getSourceItemAtIndex:(NSInteger)index {
    return [self.sourceItems objectAtIndex:index];
}

- (NSInteger) getSourceItemsCount {
    return self.sourceItems.count;
}

#pragma mark private

- (void) fetchSource:(PCSource *)source withUrl:(NSString *)url onComplete:(void (^)(PCSourceItem *sourceItem, NSError *error))onComplete {
    PCSourceNetworkRequest *sourceRequest = [self.sourceRequestHandlers objectForKey:source.objectId];
    
    [sourceRequest fetchBaseUri:source withUrl:url onItemComplete:^(PCSourceItem *sourceItem, NSError *error) {
        onComplete(sourceItem, error);
    } onAllComplete:^{
        ++self.numAllComplete;
        if(self.numAllComplete == self.sources.count) {
            self.isLoadingData = NO;
            self.numAllComplete = 0;
            onComplete(nil, nil);
        }
    }];
}

@end
