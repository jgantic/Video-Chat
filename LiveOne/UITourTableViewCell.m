//
//  UITourTableViewCell.m
//  LiveOne
//
//  Created by Александр on 23.08.15.
//  Copyright (c) 2015 Remi Development. All rights reserved.
//

#import "UITourTableViewCell.h"

@implementation UITourTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _viewCalendar.layer.cornerRadius = 4.0;
    _viewCalendar.layer.masksToBounds = YES;
    // Configure the view for the selected state
}

@end
