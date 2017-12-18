//
//  UITourTableViewCell.h
//  LiveOne
//
//  Created by Александр on 23.08.15.
//  Copyright (c) 2015 Remi Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITourTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *viewCalendar;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@end
