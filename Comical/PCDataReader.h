//
//  PCDataReader.h
//  Comical
//
//  Created by Eric Weaver on 5/27/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCSourceItem.h"
#import "PCSource.h"

@protocol PCDataReader

- (void) loadSources:(NSArray *)enabledSources onComplete:(void (^)(BOOL succeeded, NSError *error))onComplete;
- (void) fetchSourceItems:(void (^)(BOOL succeeded, NSError *error))onComplete; // Init from beginning
- (void) fetchSourceItemsBatch:(void (^)(BOOL succeeded, NSError *error))onComplete; // Next batch

- (BOOL) canLoadMore;

- (NSArray *) getSourceItems;
- (PCSourceItem *) getSourceItemAtIndex:(NSInteger)index;
- (NSInteger) getSourceItemsCount;

@end
