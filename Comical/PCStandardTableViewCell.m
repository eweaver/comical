//
//  PCStandardTableViewCell.m
//  Comical
//
//  Created by Eric Weaver on 5/30/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "PCStandardTableViewCell.h"
#import "PCConstants.h"

@implementation PCStandardTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSInteger height = (COMICAL_EXPANDED_CELL_HEIGHT - 20);
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 20, height)];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
