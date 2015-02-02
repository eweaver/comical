//
//  PCFragmentView.h
//  Comical
//
//  Created by Eric Weaver on 5/28/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCSourceItem.h"

@protocol PCFragmentView <NSObject>

- (void) useSourceItem:(PCSourceItem *)sourceItem withBounds:(CGRect)bounds withDelegate:(id)delegate;
- (UIView *) getCompactView;
- (UIView *) getStandardView;
- (UIView *) getEnhancedView;
- (UIView *) getFullView;
- (UIView *) getFullViewLandscape;

@end
