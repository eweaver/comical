//
//  PCSingleItemViewController.m
//  Comical
//
//  Created by Eric Weaver on 5/31/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "PCSingleItemViewController.h"
#import "UIViewController+ComicalBase.h"
#import "PCComicView.h"

@interface PCSingleItemViewController ()

@property (strong, nonatomic) UIView *itemView;
@property (strong, nonatomic) UIScrollView *imageScrollView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation PCSingleItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    }

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect newBounds;
    if(UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        newBounds = CGRectMake(0, 52, bounds.size.height, bounds.size.width);
    } else {
        newBounds = CGRectMake(0, 64, bounds.size.width, bounds.size.height);
    }
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self setNavbarTitle:self.sourceItem.source.name];
    PCComicView *comicView = [[PCComicView alloc] init];
    [comicView useSourceItem:self.sourceItem withBounds:newBounds withDelegate:self];
    if(UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        self.itemView = [comicView getFullViewLandscape];
    } else {
        self.itemView = [comicView getFullView];
    }
    [self.view addSubview:self.itemView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.imageView = [self findImageView:newBounds];
    //CGRect imageViewBounds = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    //self.imageView.frame = imageViewBounds;
    self.imageView.center = CGPointMake(self.imageScrollView.frame.size.width / 2, self.imageScrollView.frame.size.height / 2);
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGRect newBounds;
    
    if(UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
        CGRect bounds = [[UIScreen mainScreen] bounds];
        newBounds = CGRectMake(0, 52, bounds.size.height, bounds.size.width);
        [self.itemView removeFromSuperview];
        PCComicView *comicView = [[PCComicView alloc] init];
        [comicView useSourceItem:self.sourceItem withBounds:newBounds withDelegate:self];
        self.itemView = [comicView getFullViewLandscape];
        self.itemView.frame = newBounds;
        [self.itemView setNeedsDisplayInRect:newBounds];
        [self.view addSubview:self.itemView];

    } else {
        CGRect bounds = [[UIScreen mainScreen] bounds];
        newBounds = CGRectMake(0, 64, bounds.size.width, bounds.size.height);
        [self.itemView removeFromSuperview];
        PCComicView *comicView = [[PCComicView alloc] init];
        [comicView useSourceItem:self.sourceItem withBounds:newBounds withDelegate:self];
        self.itemView = [comicView getFullView];
        self.itemView.frame = newBounds;
        [self.itemView setNeedsDisplayInRect:newBounds];
        [self.view addSubview:self.itemView];
    }
    
    self.imageView = [self findImageView:newBounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //CGRect imageViewBounds = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    //self.imageView.frame = imageViewBounds;
    self.imageView.center = CGPointMake(self.imageScrollView.frame.size.width / 2, self.imageScrollView.frame.size.height / 2);
}

- (UIImageView *)findImageView:(CGRect)bounds {
    for(UIView *view in [self.itemView subviews]) {
        if([view isKindOfClass:[UIScrollView class]]) {
            self.imageScrollView = (UIScrollView *) view;
            break;
        }
    }
    
    if(self.imageScrollView) {
        self.imageScrollView.delegate = self;
        self.imageScrollView.minimumZoomScale = 1.0;
        self.imageScrollView.maximumZoomScale = 2.0;
        self.imageScrollView.contentSize = CGSizeMake(self.imageScrollView.frame.size.width, self.imageScrollView.frame.size.height);
        UIImageView *imageView = [self.imageScrollView subviews][0];
        
        return imageView;
    } else {
        return nil;
    }
}

#pragma mark action bar
- (void) actionBrowser:(id)sender {
    // Tummblr
    if([self.sourceItem.source.type integerValue] == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", self.sourceItem.source.baseUri]]];
    }
    
    // Everything else
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.sourceItem.itemUrl]];
    }
}

- (void) actionShare:(id)sender {
    NSString *sourceUrl;
    
    // Tummblr
    if([self.sourceItem.source.type integerValue] == 2) {
        sourceUrl = [NSString stringWithFormat:@"http://%@", self.sourceItem.source.baseUri];
    }
    
    // Everything else
    else {
        sourceUrl = self.sourceItem.itemUrl;
    }
    
    NSArray *activityItems = @[self.sourceItem.image, self.sourceItem.title, [NSURL URLWithString:sourceUrl]];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}


#pragma mark scroll view

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
