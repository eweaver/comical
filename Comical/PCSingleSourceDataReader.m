//
//  PCSingleSourceDataReader.m
//  Comical
//
//  Created by Eric Weaver on 6/1/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "PCSingleSourceDataReader.h"
#import "PCBaseDataReader.h"
#import "PCSource+Parse.h"
#import "PCSourceItem.h"
#import "PCSourceNetworkRequest.h"

@interface PCSingleSourceDataReader ()

@property (strong, nonatomic) NSString *sourceId;
@property (strong, nonatomic) PCSource *source;
@property (strong, nonatomic) NSMutableArray *sourceItems;
@property (strong, nonatomic) PCSourceNetworkRequest *sourceRequestHandler;
@property (assign, nonatomic) NSInteger maxDepth;
@property (assign, nonatomic) BOOL isLoadingData;

@end

@implementation PCSingleSourceDataReader

- (id) initWithSource:(NSString *)sourceId {
    self = [super init];
    if(self) {
        _sourceId = sourceId;
        _sourceItems = [[NSMutableArray alloc] init];
        _maxDepth = 5;
        _isLoadingData = YES;
        _sourceRequestHandler = [[PCSourceNetworkRequest alloc] initWithMaxDepth:_maxDepth];
    }
    
    return self;
}

- (void) loadSources:(NSArray *)enabledSources onComplete:(void (^)(BOOL succeeded, NSError *error))onComplete {
    [PCSource fetchSource:self.sourceId onComplete:^(PCSource *source, NSError *error) {
        if(error) {
            onComplete(NO, error);
        } else {
            self.source = source;
            onComplete(YES, nil);
        }
    }];
}

- (void) fetchSourceItems:(void (^)(BOOL succeeded, NSError *error))onComplete {
     self.isLoadingData = YES;

    [self fetchSource:self.source withUrl:self.source.baseUri onComplete:^(PCSourceItem *sourceItem, NSError *error) {
        if(error) {
            onComplete(NO, error);
        } else {
            [self.sourceItems addObject:sourceItem];
            onComplete(YES, nil);
        }
    }];
}

- (void) fetchSourceItemsBatch:(void (^)(BOOL succeeded, NSError *error))onComplete {
    if(self.isLoadingData == YES) {
        return;
    }
    
    self.isLoadingData = YES;
    
    [self fetchSource:self.source withUrl:self.sourceRequestHandler.nextUrl onComplete:^(PCSourceItem *sourceItem, NSError *error) {
        if(error) {
            onComplete(NO, error);
        } else {
            [self.sourceItems addObject:sourceItem];
            onComplete(YES, nil);
        }
    }];
}

- (BOOL) canLoadMore {
    return ! self.isLoadingData;
}

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
    [self.sourceRequestHandler fetchBaseUri:source withUrl:url onItemComplete:^(PCSourceItem *sourceItem, NSError *error) {
        onComplete(sourceItem, error);
    } onAllComplete:^{
        self.isLoadingData = NO;
    }];
}

@end
