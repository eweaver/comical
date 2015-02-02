//
//  PCComicView.m
//  Comical
//
//  Created by Eric Weaver on 5/28/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "PCComicView.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+animatedGIF.h"
#import "PCConstants.h"
#import "PCActionBar.h"

@interface PCComicView ()

@property (strong, nonatomic) PCSourceItem *sourceItem;
@property (assign, nonatomic) CGRect bounds;
@property (strong, nonatomic) id actionBarDelegate;

@end

@implementation PCComicView

- (void) useSourceItem:(PCSourceItem *)sourceItem withBounds:(CGRect)bounds withDelegate:(id)delegate {
    self.sourceItem = sourceItem;
    self.bounds = bounds;
    self.actionBarDelegate = delegate;
}

- (UIView *) getCompactView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 20, COMICAL_COLLAPSED_CELL_HEIGHT)];
    
    UILabel *comicDetails = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, view.frame.size.width, view.frame.size.height)];
    comicDetails.text = [NSString stringWithFormat:@"%@ - %@", self.sourceItem.source.name, self.sourceItem.title];
    [view addSubview:comicDetails];
    
    return view;
}

- (UIView *) getStandardView {
    NSInteger height = (COMICAL_STANDARD_CELL_HEIGHT - 10);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 20, height)];
    view.frame = CGRectOffset(view.frame, 10, 10);
    view.layer.borderWidth = 0.66f;
    view.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.66].CGColor;
    view.backgroundColor = [UIColor whiteColor];
    
    // Bg Image
    UIImageView *viewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.bounds.size.width - 20, height - 20)];
    viewImage.image = self.sourceItem.image;
    viewImage.contentMode = UIViewContentModeScaleAspectFit;
    
    if ([[self.sourceItem.imageUrl pathExtension] isEqualToString:@"gif"]) {
        //[self loadGif:self.sourceItem.imageUrl withView:viewImage];
        [viewImage setImageWithURL:[NSURL URLWithString:self.sourceItem.imageUrl]];
    } else {
        [viewImage setImageWithURL:[NSURL URLWithString:self.sourceItem.imageUrl]];
    }
    
    [view addSubview:viewImage];
    
    
    // Top Box
    UIView *topBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 20, 30)];
    topBox.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
    
    UILabel *topBoxTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, view.frame.size.width - 16, 20)];
    topBoxTitle.numberOfLines = 1;
    topBoxTitle.text = [NSString stringWithFormat:@"%@ - %@", self.sourceItem.title, self.sourceItem.source.name];
    topBoxTitle.font = [UIFont fontWithName:@"Helvetica-Light" size:13.0f];
    topBoxTitle.textColor = [UIColor whiteColor];
    [topBox addSubview:topBoxTitle];
    
    [view addSubview:topBox];

    return view;
}

- (UIView *) getEnhancedView {
    NSInteger height = (COMICAL_EXPANDED_CELL_HEIGHT - 10);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 20, height)];
    view.frame = CGRectOffset(view.frame, 10, 10);
    view.layer.borderWidth = 0.66f;
    view.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.66].CGColor;
    view.backgroundColor = [UIColor whiteColor];
    
    // Bg Image
    UIImageView *viewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, self.bounds.size.width - 20, height - 114)];
    viewImage.image = self.sourceItem.image;
    viewImage.contentMode = UIViewContentModeScaleAspectFit;
    
    if ([[self.sourceItem.imageUrl pathExtension] isEqualToString:@"gif"]) {
        //[self loadGif:self.sourceItem.imageUrl withView:viewImage];
        [viewImage setImageWithURL:[NSURL URLWithString:self.sourceItem.imageUrl]];
    } else {
        [viewImage setImageWithURL:[NSURL URLWithString:self.sourceItem.imageUrl]];
    }
    
    [view addSubview:viewImage];
    
    // Top Box
    UIView *topBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 20, 50)];
    topBox.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    
    UILabel *topBoxSource = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, view.frame.size.width - 16, 22)];
    topBoxSource.numberOfLines = 1;
    topBoxSource.text = self.sourceItem.title;
    topBoxSource.font = [UIFont fontWithName:@"Helvetica-Light" size:18.0f];
    topBoxSource.textColor = [UIColor whiteColor];
    topBoxSource.textAlignment = NSTextAlignmentCenter;
    [topBox addSubview:topBoxSource];
    
    UILabel *topBoxTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 22, view.frame.size.width - 16, 22)];
    topBoxTitle.numberOfLines = 1;
    topBoxTitle.adjustsFontSizeToFitWidth = YES;
    topBoxTitle.text = self.sourceItem.source.name;
    topBoxTitle.font = [UIFont fontWithName:@"Helvetica-Light" size:13.0f];
    topBoxTitle.textColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    topBoxTitle.textAlignment = NSTextAlignmentCenter;
    [topBox addSubview:topBoxTitle];
    
    [view addSubview:topBox];
    
    // Bottom Box
    UIView *bottomBox = [[UIView alloc] initWithFrame:CGRectMake(0, height - 64, self.bounds.size.width - 20, 64)];
    bottomBox.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    
    UILabel *bottomBoxText = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, view.frame.size.width - 16, 20)];
    bottomBoxText.numberOfLines = 1;
    bottomBoxText.text = self.sourceItem.altText;
    bottomBoxText.font = [UIFont fontWithName:@"Helvetica-Light" size:11.0f];
    bottomBoxText.textColor = [UIColor whiteColor];
    [bottomBox addSubview:bottomBoxText];
    
    UIView *options = [[UIView alloc] initWithFrame:CGRectMake(0, 20, bottomBox.frame.size.width, 44)];
    PCActionBar *actionBar = [[PCActionBar alloc] init];
    UIToolbar *actionBarToolbar = [actionBar createTabBar:self.actionBarDelegate withBounds:CGRectMake(0, 0, options.frame.size.width, 44)];
    [options addSubview:actionBarToolbar];
    [bottomBox addSubview:options];
    
    [view addSubview:bottomBox];
    
    return view;
}

- (UIView *) getFullView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.bounds.size.width, self.bounds.size.height - 64)];
    
    // Image ScrollView
    CGRect scrollViewBounds = CGRectMake(0, 50, view.frame.size.width, view.frame.size.height - 158);
    UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:scrollViewBounds];
    imageScrollView.autoresizingMask = UIViewAutoresizingNone;
    
    UIImageView *viewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageScrollView.frame.size.width, imageScrollView.frame.size.height)];
    viewImage.image = self.sourceItem.image;
    viewImage.contentMode = UIViewContentModeScaleAspectFit;
    
    if ([[self.sourceItem.imageUrl pathExtension] isEqualToString:@"gif"]) {
        [self loadGif:self.sourceItem.imageUrl withView:viewImage];
        //[viewImage setImageWithURL:[NSURL URLWithString:self.sourceItem.imageUrl]];
    } else {
        [viewImage setImageWithURL:[NSURL URLWithString:self.sourceItem.imageUrl]];
    }
    
    [imageScrollView addSubview:viewImage];
    [view addSubview:imageScrollView];
    
    // Top Box
    UIView *topBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 50)];
    topBox.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    
    UILabel *topBoxSource = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, view.frame.size.width - 16, 42)];
    topBoxSource.numberOfLines = 3;
    topBoxSource.adjustsFontSizeToFitWidth = YES;
    topBoxSource.textAlignment = NSTextAlignmentCenter;
    topBoxSource.text = self.sourceItem.title;
    topBoxSource.font = [UIFont fontWithName:@"Helvetica-Light" size:18.0f];
    topBoxSource.textColor = [UIColor whiteColor];
    [topBox addSubview:topBoxSource];
    
    [view addSubview:topBox];
    
    // Bottom Box
    UIView *bottomBox = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 110, view.frame.size.width, 110)];
    bottomBox.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    
    UILabel *bottomBoxText = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, view.frame.size.width - 20, 46)];
    bottomBoxText.numberOfLines = 6;
    bottomBoxText.adjustsFontSizeToFitWidth = YES;
    bottomBoxText.text = self.sourceItem.altText;
    bottomBoxText.font = [UIFont fontWithName:@"Helvetica-Light" size:14.0f];
    bottomBoxText.textColor = [UIColor whiteColor];
    [bottomBox addSubview:bottomBoxText];
    
    UIView *options = [[UIView alloc] initWithFrame:CGRectMake(0, 66, bottomBox.frame.size.width, 44)];
    PCActionBar *actionBar = [[PCActionBar alloc] init];
    UIToolbar *actionBarToolbar = [actionBar createTabBar:self.actionBarDelegate withBounds:CGRectMake(0, 0, options.frame.size.width, 44)];
    [options addSubview:actionBarToolbar];
    [bottomBox addSubview:options];
    
    [view addSubview:bottomBox];
    
    return view;

}

- (UIView *) getFullViewLandscape {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 54, self.bounds.size.width, self.bounds.size.height - 54)];
    
    // Image ScrollView
    CGRect scrollViewBounds = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:scrollViewBounds];
    
    UIImageView *viewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageScrollView.frame.size.width, imageScrollView.frame.size.height)];
    viewImage.image = self.sourceItem.image;
    viewImage.contentMode = UIViewContentModeScaleAspectFit;
    
    if ([[self.sourceItem.imageUrl pathExtension] isEqualToString:@"gif"]) {
        [self loadGif:self.sourceItem.imageUrl withView:viewImage];
        //[viewImage setImageWithURL:[NSURL URLWithString:self.sourceItem.imageUrl]];
    } else {
        [viewImage setImageWithURL:[NSURL URLWithString:self.sourceItem.imageUrl]];
    }
    
    [imageScrollView addSubview:viewImage];
    [view addSubview:imageScrollView];
    
    return view;

}

#pragma mark private
- (void) loadGif:(NSString *)imageUrl withView:(UIImageView *)imageView {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        UIImage *image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.sourceItem.imageUrl]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image;
        });
    });
}

@end
