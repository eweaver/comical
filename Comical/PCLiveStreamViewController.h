//
//  PCLiveStreamViewController.h
//  Comical
//
//  Created by Eric Weaver on 5/27/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCActionBarDelegate.h"

@interface PCLiveStreamViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PCActionBarDelegate>

@property (strong, nonatomic) UITableView *tableView;

- (void) setDisplayMode:(NSInteger)modeId;
- (void) setSingleSourceDataReader:(NSString *)sourceId title:(NSString *)title;
- (void) setWhatsNewDataReader;
- (void) setLiveStreamDataReader;

@end
