//
//  PCOrganizeViewController.m
//  Comical
//
//  Created by Eric Weaver on 6/3/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "PCOrganizeViewController.h"
#import "UIViewController+ComicalBase.h"
#import "PCDataReaderOrganizeTableViewCell.h"
#import "PCSource+Parse.h"

@interface PCOrganizeViewController ()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataReaders;

@end

@implementation PCOrganizeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavbarTitle:@"Organize"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadDataReaders];
}

- (void) loadDataReaders {
    [PCSource fetchAllForInstallation:^(NSArray *sources, NSError *error) {
        if(error) {
            NSLog(@"WHOOPS");
        } else {
            NSMutableArray *allReaders = [[NSMutableArray alloc] initWithCapacity:sources.count];
            
            // Live Stream
            //NSDictionary *liveStream = @{@"sourceId":@"", @"name":@"Live Stream"};
            //[allReaders addObject:liveStream];
            
            for(NSDictionary *sourceData in sources) {
                [allReaders addObject:sourceData];
            }
            
            self.dataReaders = [[NSMutableArray alloc] initWithArray:allReaders];
            [self.tableView reloadData];
            [self.tableView setNeedsLayout];
        }
    }];
}

#pragma update settings
- (void) setState:(id)sender {
    // TODO: Move to PCSource
    UISwitch *toggle = (UISwitch *)sender;
    UITableViewCell *cell = (UITableViewCell *) toggle.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *currentData = [self.dataReaders objectAtIndex:indexPath.row];
    NSDictionary *newData = @{@"objectId": [currentData objectForKey:@"objectId"], @"name":[currentData objectForKey:@"name"], @"enabled":[NSNumber numberWithBool:toggle.on], @"lastUri":[currentData objectForKey:@"lastUri"]};
    [self.dataReaders setObject:newData atIndexedSubscript:indexPath.row];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.dataReaders forKey:@"sources"];
    [defaults synchronize];
}

#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataReaders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PCDataReaderOrganizeTableViewCell *cell;
        
    cell = (PCDataReaderOrganizeTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"DataReaderOrganizeCell"];
        
    if(cell == nil) {
        cell = [[PCDataReaderOrganizeTableViewCell alloc] init];
    }
        
    NSDictionary *dataReaderInfo = [self.dataReaders objectAtIndex:indexPath.row];
    cell.nameLabel.text = [dataReaderInfo objectForKey:@"name"];
    cell.enableSwitch.on = [[dataReaderInfo objectForKey:@"enabled"] boolValue];
    [cell.enableSwitch addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
