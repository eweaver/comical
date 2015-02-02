//
//  PCSource.h
//  Comical
//
//  Created by Eric Weaver on 5/27/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCSource : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *baseUri;
@property (strong, nonatomic) NSString *lastUri;
@property (strong, nonatomic) NSString *itemFormat;
@property (assign, nonatomic) BOOL isCollection;
@property (strong, nonatomic) NSNumber *type;
@property (assign, nonatomic) BOOL useWebView;
@property (strong, nonatomic) NSString *regexPrevious;
@property (strong, nonatomic) NSString *regexNext;
@property (strong, nonatomic) NSString *regexImage;
@property (strong, nonatomic) NSString *regexTitle;
@property (strong, nonatomic) NSString *regexAlt;
@property (strong, nonatomic) NSDate *updatedAt;

@end
