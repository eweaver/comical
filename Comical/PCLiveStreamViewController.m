//
//  PCLiveStreamViewController.m
//  Comical
//
//  Created by Eric Weaver on 5/27/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "PCLiveStreamViewController.h"
#import "UIViewController+ComicalBase.h"
#import "PCBaseDataReader.h"
#import "PCLiveStreamDataReader.h"
#import "PCSingleSourceDataReader.h"
#import "PCStandardTableViewCell.h"
#import "PCSingleItemViewController.h"
#import "PCWhatsNewDataReader.h"
#import "PCSourceItem.h"
#import "PCComicView.h"
#import "PCConstants.h"
#import "PCSource+Parse.h"

@interface PCLiveStreamViewController ()

@property (strong, nonatomic) PCBaseDataReader *dataReader;
@property (assign, nonatomic) NSInteger viewMode;

@property (strong, nonatomic) UIView *noItemsDisplay;

@end

@implementation PCLiveStreamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _viewMode = 3;
        _dataReader = [[PCWhatsNewDataReader alloc] init];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        if(_viewMode == 1) {
            _tableView.rowHeight = COMICAL_COLLAPSED_CELL_HEIGHT;
        } else if(_viewMode == 2) {
            _tableView.rowHeight = COMICAL_STANDARD_CELL_HEIGHT;
        } else {
            _tableView.rowHeight = COMICAL_EXPANDED_CELL_HEIGHT;
        }
        
        [self.view addSubview:_tableView];
        
        _noItemsDisplay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _noItemsDisplay.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, (_noItemsDisplay.frame.size.height - 72)/ 2, _noItemsDisplay.frame.size.width, 72)];
        label.text = NSLocalizedString(@"No new items to view!  Try again later.", @"");
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30.0f];
        
        [_noItemsDisplay addSubview:label];
        _noItemsDisplay.hidden = YES;
        
        [self.view addSubview:_noItemsDisplay];
        [self.view bringSubviewToFront:_noItemsDisplay];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect newBounds;
    if(UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        newBounds = CGRectMake(0, 0, bounds.size.height, bounds.size.width);
    } else {
        newBounds = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
    }
    
    self.tableView.frame = newBounds;
    [self.tableView reloadData];
    [self.tableView setNeedsDisplayInRect:newBounds];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavbarTitle:@"What's New"];
    [self setNavbarItems];
    
    [self loadInit];
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGRect newBounds;
    
    if(UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
        CGRect bounds = [[UIScreen mainScreen] bounds];
        newBounds = CGRectMake(0, 0, bounds.size.height, bounds.size.width);
    } else {
        CGRect bounds = [[UIScreen mainScreen] bounds];
        newBounds = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
    }
    
    self.noItemsDisplay.frame = newBounds;
    UILabel *l = (UILabel *) self.noItemsDisplay.subviews[0];
    l.frame = newBounds;
    [l setNeedsDisplayInRect:newBounds];
    
    self.tableView.frame = newBounds;
    [self.tableView reloadData];
    [self.tableView setNeedsDisplayInRect:newBounds];

}

#pragma mark action bar
- (void) actionBrowser:(id)sender {
    PCSourceItem *sourceItem = [self getSourceItemFromButton:sender];
    
    // Tummblr
    if([sourceItem.source.type integerValue] == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", sourceItem.source.baseUri]]];
    }
    
    // Everything else
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sourceItem.itemUrl]];
    }
}

- (void) actionShare:(id)sender {
    PCSourceItem *sourceItem = [self getSourceItemFromButton:sender];
    
    NSString *sourceUrl;
    
    // Tummblr
    if([sourceItem.source.type integerValue] == 2) {
        sourceUrl = [NSString stringWithFormat:@"http://%@", sourceItem.source.baseUri];
    }
    
    // Everything else
    else {
        sourceUrl = sourceItem.itemUrl;
    }
    
    NSArray *activityItems = @[sourceItem.image, sourceItem.title, [NSURL URLWithString:sourceUrl]];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (PCSourceItem *)getSourceItemFromButton:(id)buttonId {
    UIBarButtonItem *button = (UIBarButtonItem *) buttonId;
    UIView *view = [button valueForKey:@"view"];
    PCStandardTableViewCell *cell = (PCStandardTableViewCell *) view.superview.superview.superview.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    PCSourceItem *sourceItem = (PCSourceItem *) [self.dataReader getSourceItemAtIndex:indexPath.row];
    
    UIView *cellView = (UIView *) view.superview.superview.superview.superview.superview.subviews[1];
    UIImageView *imageView = (UIImageView *) cellView.subviews[0];
    sourceItem.image = imageView.image;
    
    return sourceItem;

}

#pragma mark data reader load

- (void) loadInit {
    [self displayWaiting];
    [self.dataReader loadSources:[PCSource fetchAllForInstallationSync:YES] onComplete:^(BOOL succeeded, NSError *error) {
        [self.dataReader fetchSourceItems:^(BOOL succeeded, NSError *error) {
            [self hideWaiting];
            
            if([self.dataReader getSourceItemsCount] == 0) {
                self.noItemsDisplay.hidden = NO;
                [self.tableView reloadData];
                [self.tableView setNeedsLayout];
            } else if(succeeded == YES) {
                [self.tableView reloadData];
                [self.tableView setNeedsLayout];
            }
        }];
    }];
}

- (void) loadMore {
    if([self.dataReader canLoadMore] == NO) {
        return;
    }
    
    [self.dataReader fetchSourceItemsBatch:^(BOOL succeeded, NSError *error) {
        [self.tableView reloadData];
        [self.tableView setNeedsLayout];
    }];
}

#pragma mark view mode

- (void) setDisplayMode:(NSInteger)modeId {
    self.viewMode = modeId;
    if(self.viewMode == 1) {
        self.tableView.rowHeight = COMICAL_COLLAPSED_CELL_HEIGHT;
    } else if(self.viewMode == 2) {
        self.tableView.rowHeight = COMICAL_STANDARD_CELL_HEIGHT;
    } else {
        self.tableView.rowHeight = COMICAL_EXPANDED_CELL_HEIGHT;
    }
    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
    [self hideWaiting];
}

#pragma mark set data reader

- (void) setSingleSourceDataReader:(NSString *)sourceId title:(NSString *)title {
    self.noItemsDisplay.hidden = YES;
    self.dataReader = [[PCSingleSourceDataReader alloc] initWithSource:sourceId];
    [self loadInit];
    [self setNavbarTitle:title];
}

- (void) setWhatsNewDataReader {
    self.noItemsDisplay.hidden = YES;
    self.dataReader = [[PCWhatsNewDataReader alloc] init];
    [self loadInit];
    [self setNavbarTitle:@"What's New"];
}

- (void) setLiveStreamDataReader {
    self.noItemsDisplay.hidden = YES;
    self.dataReader = [[PCLiveStreamDataReader alloc] init];
    [self loadInit];
    [self setNavbarTitle:@"Live Stream"];
}

# pragma mark navigation
- (void) navigateToSingleItem:(PCSourceItem *)sourceItem {
    PCSingleItemViewController *vc = [[PCSingleItemViewController alloc] init];
    vc.sourceItem = sourceItem;
    [self.navigationController pushViewController:vc animated:YES];
}

# pragma mark UITablViewDelegate


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataReader getSourceItemsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PCSourceItem *sourceItem = [self.dataReader getSourceItemAtIndex:indexPath.row];
    PCComicView *comicView = [[PCComicView alloc] init];
    [comicView useSourceItem:sourceItem withBounds:self.view.bounds withDelegate:self];
    
    PCStandardTableViewCell *cell;
    
    // Collapsed
    if(self.viewMode == 1) {
        cell = (PCStandardTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"CollapsedCell"];
        
        if(cell == nil) {
            cell = [[PCStandardTableViewCell alloc] init];
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:[comicView getCompactView]];
    }
    
    // Standard
    else if (self.viewMode == 2) {
        cell = (PCStandardTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"StandardCell"];
        
        if(cell == nil) {
            cell = [[PCStandardTableViewCell alloc] init];
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:[comicView getStandardView]];
    }
    
    // Expanded
    else {
        cell = (PCStandardTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"ExpandedCell"];
        
        if(cell == nil) {
            cell = [[PCStandardTableViewCell alloc] init];
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:[comicView getEnhancedView]];
    }
    
    cell.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PCSourceItem *sourceItem = [self.dataReader getSourceItemAtIndex:indexPath.row];
    [self navigateToSingleItem:sourceItem];
}

#pragma mark scroll view

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    float cellOffset;
    if(self.viewMode == 1) {
        cellOffset = (float) COMICAL_COLLAPSED_CELL_HEIGHT;
    } else if(self.viewMode == 2) {
        cellOffset = (float) COMICAL_STANDARD_CELL_HEIGHT - 20;
    } else {
        cellOffset = (float) COMICAL_EXPANDED_CELL_HEIGHT - 20;
    }
    
    float contentLeft = ((self.tableView.contentOffset.y + 64) / (self.tableView.contentSize.height - cellOffset));
    if(contentLeft > 0.8) {
        [self loadMore];
    }
}


@end
