//
//  PCActionBarDelegate.h
//  Comical
//
//  Created by Eric Weaver on 6/1/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PCActionBarDelegate <NSObject>

- (void) actionBrowser:(id)sender;
- (void) actionShare:(id)sender;

@end
