//
//  PCComicItem.h
//  Comical
//
//  Created by Eric Weaver on 5/27/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "PCItem.h"
#import "PCSource.h"

@interface PCSourceItem : NSObject <PCItem>

// Types, enum these later
// 1. Raw web source -- no particular formatting
// 2. Tumblr
// 3. Raw web source -- strict numerical numbering

@property (strong, nonatomic) NSString *itemUrl;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *altText;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *imageUrl;

// TODO: imageSet will contain a dictionary of imageUrl -> image mappings for multi image posts
@property (strong, nonatomic) NSDictionary *imageSet;
@property (strong, nonatomic) NSString *next;
@property (strong, nonatomic) NSString *previous;
@property (strong, nonatomic) PCSource *source;

@end
