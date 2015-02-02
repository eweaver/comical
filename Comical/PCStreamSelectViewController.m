//
//  PCStreamSelectViewController.m
//  Comical
//
//  Created by Eric Weaver on 6/1/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "PCStreamSelectViewController.h"
#import "UIViewController+ComicalBase.h"
#import "PCSource+Parse.h"
#import "PCDataReadersTableViewCell.h"
#import "PCViewModeTableViewCell.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "UIViewController+MMDrawerController.h"
#import "PCLiveStreamViewController.h"

@interface PCStreamSelectViewController ()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataReaders;
@property (strong, nonatomic) NSArray *viewModes;

@end

@implementation PCStreamSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _viewModes = @[@{@"modeId":@1, @"name":@"Compact"}, @{@"modeId":@2, @"name":@"Standard"}, @{@"modeId":@3, @"name":@"Expanded"}];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 58;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
        
        [self.view addSubview:_tableView];
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [self loadDataReaders];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
}

- (void) loadDataReaders {
    [PCSource fetchAllForInstallation:YES onComplete:^(NSArray *sources, NSError *error) {
        if(error) {
            NSLog(@"WHOOPS");
        } else {
            NSMutableArray *allReaders = [[NSMutableArray alloc] initWithCapacity:(sources.count + 1)];
            
            // What's New
            NSDictionary *whatsNew = @{@"sourceId":@"", @"name":@"What's New"};
            [allReaders addObject:whatsNew];
            
            // Live Stream
            NSDictionary *liveStream = @{@"sourceId":@"", @"name":@"Live Stream"};
            [allReaders addObject:liveStream];
            
            //for(PCSource *source in sources) {
            for(NSDictionary *sourceData in sources) {
                //NSDictionary *sourceData = @{@"sourceId":source.objectId, @"name":source.name};
                [allReaders addObject:sourceData];
            }
            
            self.dataReaders = [[NSArray alloc] initWithArray:allReaders];
            [self.tableView reloadData];
            [self.tableView setNeedsLayout];
        }
    }];
}

# pragma mark UITablViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
    [view setBackgroundColor:[UIColor colorWithRed:46.0/255.0 green:128.0/255.0 blue:126.0/255.0 alpha:1]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 28)];
    [label setFont:[UIFont fontWithName: @"HelveticaNeue" size: 14.0f]];
    label.textColor = [UIColor whiteColor];
    NSString *string;
    
    if(section == 0) {
        string = @"View Modes";
    } else {
        string = @"Sources";
    }
   
    [label setText:string];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        return 58.0f;
    } else {
        return 58.0f;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return self.viewModes.count;
    } else {
        return self.dataReaders.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // View Modes
    if(indexPath.section == 0) {
        PCViewModeTableViewCell *cell;
        
        if(cell == nil) {
            cell = [[PCViewModeTableViewCell alloc] init];
        }
        
        NSDictionary *viewModeInfo = [self.viewModes objectAtIndex:indexPath.row];
        cell.nameLabel.text = [viewModeInfo objectForKey:@"name"];
        return cell;
    }
    
    // Data Readers
    else {
        PCDataReadersTableViewCell *cell;
    
        cell = (PCDataReadersTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"DataReaderCell"];
        
        if(cell == nil) {
            cell = [[PCDataReadersTableViewCell alloc] init];
        }
    
        NSDictionary *dataReaderInfo = [self.dataReaders objectAtIndex:indexPath.row];
        cell.nameLabel.text = [dataReaderInfo objectForKey:@"name"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UINavigationController *navController = (UINavigationController *) self.mm_drawerController.centerViewController;
    PCLiveStreamViewController *vc = (PCLiveStreamViewController *) navController.viewControllers[0];
    [vc displayWaiting];
    
    // View Modes
    if(indexPath.section == 0) {
        NSDictionary *viewModesInfo = [self.viewModes objectAtIndex:indexPath.row];
        [vc setDisplayMode:[[viewModesInfo objectForKey:@"modeId"] integerValue]];
    }
    
    // Data Readers
    else {
        // Special case -- Live Stream data reader
        if(indexPath.row == 0) {
            [vc setWhatsNewDataReader];
        }
        
        else if(indexPath.row == 1) {
            [vc setLiveStreamDataReader];
        }
    
        // Single data readers
        else {
            NSDictionary *dataReaderInfo = [self.dataReaders objectAtIndex:indexPath.row];
            [vc setSingleSourceDataReader:[dataReaderInfo objectForKey:@"objectId"] title:[dataReaderInfo objectForKey:@"name"]];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self toggleLeftDrawer];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
