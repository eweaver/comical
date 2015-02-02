//
//  PCSourceNetworkRequest.m
//  Comical
//
//  Created by Eric Weaver on 5/28/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "PCSourceNetworkRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "PCConstants.h"

@interface PCSourceNetworkRequest ()

@property (assign, nonatomic) NSInteger maxDepth;
@property (strong, nonatomic) NSString *finalUri;
@property (strong, nonatomic) NSString *updatedFinalUri;

@end

@implementation PCSourceNetworkRequest

- (id)initWithMaxDepth:(NSInteger)maxDepth {
    self = [super init];
    
    if(self) {
        _maxDepth = maxDepth;
        _requestInProgress = NO;
    }
    
    return self;
}

- (id)initWithFinalUri:(NSString *)finalUri {
    self = [super init];
    
    if(self) {
        _finalUri = finalUri;
        _requestInProgress = NO;
    }
    
    return self;
}

- (void) fetchBaseUri:(PCSource *)source withUrl:(NSString *)url onItemComplete:(void (^)(PCSourceItem *sourceItem, NSError *error))onItemComplete onAllComplete:(void (^)(void))onAllComplete {
    _requestInProgress = YES;
    if(self.maxDepth) {
        [self startFetch:0 withSource:source withUrl:url onItemComplete:onItemComplete onAllComplete:onAllComplete];
    } else {
        [self startFetch:source withUrl:url onItemComplete:onItemComplete onAllComplete:onAllComplete];
    }
}

#pragma mark private

- (void) startFetch:(NSInteger)depth withSource:(PCSource *)source withUrl:(NSString *)url onItemComplete:(void (^)(PCSourceItem *sourceItem, NSError *error))onItemComplete onAllComplete:(void (^)(void))onAllComplete {
    __block NSInteger currentDepth = depth;
    [self dispatchFetch:source withUrl:url onItemComplete:^(PCSourceItem *sourceItem, NSError *error) {
        if(error) {
            onItemComplete(nil, error);
        } else {
            if(! self.updatedFinalUri && sourceItem.imageUrl) {
                self.updatedFinalUri = sourceItem.imageUrl;
                [PCSource updateLastUri:source.objectId lastUri:sourceItem.imageUrl];
            }
            
            if([sourceItem.imageUrl isEqual:self.finalUri]) {
                _requestInProgress = NO;
                onAllComplete();
                return;
            }
            
            ++currentDepth;
            onItemComplete(sourceItem, nil);
        }
        
        if(currentDepth < self.maxDepth && sourceItem.next) {
            self.nextUrl = sourceItem.next;
            [self startFetch:currentDepth withSource:source withUrl:sourceItem.next onItemComplete:onItemComplete onAllComplete:onAllComplete];
        } else {
            if(sourceItem.next) {
                self.nextUrl = sourceItem.next;
            }
            _requestInProgress = NO;
            onAllComplete();
        }
    }];
}

- (void) startFetch:(PCSource *)source withUrl:(NSString *)url onItemComplete:(void (^)(PCSourceItem *sourceItem, NSError *error))onItemComplete onAllComplete:(void (^)(void))onAllComplete {
    [self dispatchFetch:source withUrl:url onItemComplete:^(PCSourceItem *sourceItem, NSError *error) {
        if(error) {
            onItemComplete(nil, error);
        } else {
            if(! self.updatedFinalUri && sourceItem.imageUrl) {
                self.updatedFinalUri = sourceItem.imageUrl;
                [PCSource updateLastUri:source.objectId lastUri:sourceItem.imageUrl];
            }
            
            if([sourceItem.imageUrl isEqual:self.finalUri]) {
                _requestInProgress = NO;
                onAllComplete();
                return;
            }
            
            onItemComplete(sourceItem, nil);
        }
        
        if(![sourceItem.next isEqual:self.finalUri]) {
            self.nextUrl = sourceItem.next;
            [self startFetch:source withUrl:sourceItem.next onItemComplete:onItemComplete onAllComplete:onAllComplete];
        } else {
            if(sourceItem.next) {
                self.nextUrl = sourceItem.next;
            }
            _requestInProgress = NO;
            onAllComplete();
        }
    }];
}

- (void) dispatchFetch:(PCSource *)source withUrl:(NSString *)url onItemComplete:(void (^)(PCSourceItem *sourceItem, NSError *error))onItemComplete {
    switch([source.type integerValue]) {
        // Raw HTML
        case 1:
        case 3:
            {
                NSURL *URL = [NSURL URLWithString:url];
                NSURLRequest *request = [NSURLRequest requestWithURL:URL];
                AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    PCSourceItem *sourceItem = [self parseResponse:[source.type integerValue] withSource:source withUrl:url withResponse:responseObject];
                    if(sourceItem == nil) {
                        NSDictionary *errorDictionary = @{ @"error": @"Source has no additional items."};
                        NSError *error = [[NSError alloc] initWithDomain:@"com.firststep.comical.OutOfContentError" code:1 userInfo:errorDictionary];
                        onItemComplete(nil, error);
                    } else {
                        onItemComplete(sourceItem, nil);
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    onItemComplete(nil, error);
                }];
                [op start];

            }
            break;
        // Tumblr
        case 2:
            {
                NSString *tumblrUrl;
                if ([url rangeOfString:COMICAL_TUMBLR_API_KEY].location == NSNotFound) {
                    tumblrUrl = [NSString stringWithFormat:COMICAL_TUMBLR_POST_FORMAT, url, COMICAL_TUMBLR_API_KEY, 0];
                } else {
                    tumblrUrl = url;
                }

                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                [manager GET:tumblrUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    PCSourceItem *sourceItem = [self parseResponse:[source.type integerValue] withSource:source withUrl:tumblrUrl withResponse:responseObject];
                    if(sourceItem == nil) {
                        NSDictionary *errorDictionary = @{ @"error": @"Source has no additional items."};
                        NSError *error = [[NSError alloc] initWithDomain:@"com.firststep.comical.OutOfContentError" code:1 userInfo:errorDictionary];
                        onItemComplete(nil, error);
                    } else {
                        onItemComplete(sourceItem, nil);
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    onItemComplete(nil, error);
                }];
            }
            break;
    }
    
    }

- (PCSourceItem *)parseResponse:(NSInteger)type withSource:(PCSource *)source withUrl:(NSString *)url withResponse:(id)responseObject {
    PCSourceItem *sourceItem = nil;
    switch(type) {
        case 1:
            {
                NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                sourceItem = [[PCSourceItem alloc] init:source withUrl:url withHtml:string];
            }
            break;
        case 2:
            {
                NSArray *posts = [[responseObject objectForKey:@"response"] objectForKey:@"posts"];
                if(posts.count >= 1) {
                    NSDictionary *post = posts[0];
                    sourceItem = [[PCSourceItem alloc] init:source withUrl:url withTumblrJson:post];
                }
            }
            break;
        case 3:
            {
                NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                sourceItem = [[PCSourceItem alloc] initNumericalSource:source withUrl:url withHtml:string];
            }
            break;
    }
    
    return sourceItem;
}

@end
