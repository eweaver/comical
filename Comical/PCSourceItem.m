//
//  PCComicItem.m
//  Comical
//
//  Created by Eric Weaver on 5/27/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "PCSourceItem.h"
#import "PCSource.h"
#import "GTMNSString+HTML.h"
#import "PCConstants.h"

@interface PCSourceItem ()

@property (strong, nonatomic) NSString *sourceHtml;

@end

@implementation PCSourceItem

// Raw HTML
- (id) init:(PCSource *)source withUrl:(NSString *)url withHtml:(NSString *)sourceHtml {
    self = [super init];
    if(self) {
        _source = source;
        _sourceHtml = sourceHtml;
        
        _itemUrl = url;
        _title = [PCSourceItem getMatchingString:sourceHtml withRegex:source.regexTitle];
        if(! [_title isEqualToString:@""] && _title != NULL) {
            _title = [PCSourceItem formatStringForDisplay:_title];
        }
        
        if(source.regexAlt) {
            _altText = [PCSourceItem getMatchingString:sourceHtml withRegex:source.regexAlt];
            if(! [_altText isEqualToString:@""] && _altText != NULL) {
                _altText = [PCSourceItem formatStringForDisplay:_altText];
            }
        } else {
            _altText = @"";
        }
        _next = [PCSourceItem getMatchingString:sourceHtml withRegex:source.regexNext];
        _next = [NSString stringWithFormat:source.itemFormat, _next];
        _previous = [PCSourceItem getMatchingString:sourceHtml withRegex:source.regexPrevious];
        _previous = [NSString stringWithFormat:source.itemFormat, _previous];
        _imageUrl = [PCSourceItem getMatchingString:sourceHtml withRegex:source.regexImage];
        _image = [UIImage imageNamed:@"default_image.jpg"];
    }
    
    return self;
}

- (id) initNumericalSource:(PCSource *)source withUrl:(NSString *)url withHtml:(NSString *)sourceHtml {
    self = [super init];
    if(self) {
        _source = source;
        _sourceHtml = sourceHtml;
        
        _itemUrl = url;
        _title = [PCSourceItem formatStringForDisplay:[PCSourceItem getMatchingString:sourceHtml withRegex:source.regexTitle]];
        if(source.regexAlt) {
            _altText = [PCSourceItem formatStringForDisplay:[PCSourceItem getMatchingString:sourceHtml withRegex:source.regexAlt]];
        } else {
            _altText = @"";
        }
        
        NSString *imageId = [PCSourceItem getMatchingString:sourceHtml withRegex:source.regexImage];
        if(imageId) {
            _imageUrl = [NSString stringWithFormat:[NSString stringWithFormat:@"%@.png", source.itemFormat], imageId];
            _image = [UIImage imageNamed:@"default_image.jpg"];
        
            NSInteger imageIdInteger = [imageId integerValue];
            NSNumber *next = [NSNumber numberWithInteger:(imageIdInteger - 1)];
            NSNumber *previous = [NSNumber numberWithInteger:(imageIdInteger + 1)];

            
            _next = [NSString stringWithFormat:source.itemFormat, next];
            _previous = [NSString stringWithFormat:source.itemFormat, previous];
        }
    }
    
    return self;

}

// Tumblr
- (id) init:(PCSource *)source withUrl:(NSString *)url withTumblrJson:(NSDictionary *)json {
    self = [super init];
    if(self) {
        _source = source;
        _itemUrl = url;
        _image = [UIImage imageNamed:@"default_image.jpg"];
        
        if ([[json objectForKey:@"type"] isEqual: @"photo"]) {
            NSArray *photoInfo = [json objectForKey:@"photos"];
            _imageUrl = [[photoInfo[0] objectForKey:@"original_size"]objectForKey:@"url"];
            if(source.regexTitle) {
                _title = [PCSourceItem getMatchingString:[json objectForKey:@"caption"] withRegex:source.regexTitle];
                if([_title isEqualToString:@""]) {
                    _title = [json objectForKey:@"slug"];
                }
            }
        } else if ([[json objectForKey:@"type"] isEqual: @"text"]) {
            _imageUrl = [PCSourceItem getMatchingString:[json objectForKey:@"body"] withRegex:source.regexImage];
            _title = [json objectForKey:@"slug"];
        } else {
            _imageUrl = nil;
        }
        
        // Next post
        NSString *currentOffset = [PCSourceItem getMatchingString:url withRegex:source.regexNext];
        if (currentOffset != nil) {
            NSInteger nextOffset = [currentOffset integerValue] + 1;
            NSString *nextUrl = [NSString stringWithFormat:COMICAL_TUMBLR_POST_FORMAT, source.baseUri, COMICAL_TUMBLR_API_KEY, nextOffset];
            _next = nextUrl;
        } else {
            _next = nil;
        }
        
        // Previous post
        if (currentOffset != nil) {
            NSInteger previousOffset = [currentOffset integerValue] - 1;
            
            if (previousOffset >= 0) {
                NSString *previousUrl = [NSString stringWithFormat:COMICAL_TUMBLR_POST_FORMAT, source.baseUri, COMICAL_TUMBLR_API_KEY, previousOffset];
                _previous = previousUrl;
            } else {
                _previous = nil;
            }
        } else {
            _previous = nil;
        }


        // ???
        _altText = [json objectForKey:@"caption"];
        if([_altText isEqualToString:@""] || _altText == NULL) {
            _altText = [json objectForKey:@"slug"];
        }
        
        if(! [_altText isEqualToString:@""] || _altText != NULL) {
            _altText = [PCSourceItem formatStringForDisplay:_altText];
            
            if([_title isEqualToString:@""] || _title == NULL) {
                _title = _altText;
            }
        }
        
        if([_title isEqualToString:@""] || _title == NULL) {
            _title = @"No Title";
        }
        
        _title = [PCSourceItem formatStringForDisplay:_title];
    }
    
    return self;
}

+ (NSString *) formatStringForDisplay:(NSString *)s {
    NSRange r;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    
    return [s gtm_stringByUnescapingFromHTML];
}

+ (NSString *)getMatchingString:(NSString *)subject withRegex:(NSString *)regexString {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:regexString
                                  options:0
                                  error:&error];
    
    NSString *matchedString = nil;
    
    @try {
        NSArray *matches = [regex matchesInString:subject options:0 range:NSMakeRange(0, [subject length])];
        if ([matches count] > 0) {
            NSRange range = [matches[0] rangeAtIndex:1];
            matchedString = [subject substringWithRange:range];
        }
    }
    @catch (NSException *e) {
    }
    @finally {
    }
    
    return matchedString;
}

@end
