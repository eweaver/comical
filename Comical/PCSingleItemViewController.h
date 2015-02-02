//
//  PCSingleItemViewController.h
//  Comical
//
//  Created by Eric Weaver on 5/31/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCSourceItem.h"

@interface PCSingleItemViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) PCSourceItem *sourceItem;

@end
