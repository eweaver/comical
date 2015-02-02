//
//  PCDataReaderOrganizeTableViewCell.m
//  Comical
//
//  Created by Eric Weaver on 6/3/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "PCDataReaderOrganizeTableViewCell.h"

@interface PCDataReaderOrganizeTableViewCell ()

@property (strong, nonatomic) UIImageView *labelIcon;

@end

@implementation PCDataReaderOrganizeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        if (self) {
            self.backgroundColor = [UIColor clearColor];
            _labelIcon = [[UIImageView alloc] initWithFrame:CGRectMake(4, 13, 32, 32)];
            _labelIcon.tintColor = [UIColor whiteColor];
            UIImage *tagImage = [UIImage imageNamed:@"tb_tag.png"];
            _labelIcon.image = [tagImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [self addSubview:_labelIcon];
            
            _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 4, self.frame.size.width - 128, 50)];
            _nameLabel.textColor = [UIColor whiteColor];
            _nameLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:17.0f];
            [self addSubview:_nameLabel];
            
            _enableSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(250, 14, 80, 32)];
            [self addSubview:_enableSwitch];
        }
        return self;
    }
    return self;
}

- (void)awakeFromNib
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
