//
//  PCActionBar.h
//  Comical
//
//  Created by Eric Weaver on 6/1/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCActionBarDelegate.h"

@interface PCActionBar : NSObject

- (UIToolbar *) createTabBar:(id)delegate withBounds:(CGRect)bounds;

@end
