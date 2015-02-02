//
//  PCViewModeTableViewCell.m
//  Comical
//
//  Created by Eric Weaver on 6/1/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "PCViewModeTableViewCell.h"

@interface PCViewModeTableViewCell ()

@property (strong, nonatomic) UIImageView *labelIcon;

@end

@implementation PCViewModeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _labelIcon = [[UIImageView alloc] initWithFrame:CGRectMake(4, 13, 32, 32)];
        _labelIcon.tintColor = [UIColor whiteColor];
        UIImage *tagImage = [UIImage imageNamed:@"tb_tag.png"];
        _labelIcon.image = [tagImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self addSubview:_labelIcon];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 4, self.frame.size.width - 48, 50)];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:17.0f];
        [self addSubview:_nameLabel];
    }
    return self;

}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
