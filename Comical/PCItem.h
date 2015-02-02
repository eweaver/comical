//
//  PCItem.h
//  Comical
//
//  Created by Eric Weaver on 5/27/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCSource.h"

@protocol PCItem

- (id) init:(PCSource *)source withUrl:(NSString *)url withHtml:(NSString *)sourceHtml;
- (id) initNumericalSource:(PCSource *)source withUrl:(NSString *)url withHtml:(NSString *)sourceHtml;
- (id) init:(PCSource *)source withUrl:(NSString *)url withTumblrJson:(NSDictionary *)json;

@end
