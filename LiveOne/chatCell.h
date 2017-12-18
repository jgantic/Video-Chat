//
//  chatCell.h
//  chatDemo
//
//  Created by David Mendels on 4/14/12.
//  Copyright (c) 2012 Cognoscens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chatCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *voteStar;

@property (weak, nonatomic) IBOutlet UIButton *voteplus;
@property (weak, nonatomic) IBOutlet UIButton *voteminus;
@property (weak, nonatomic) IBOutlet UILabel *votevalue;
@property (weak, nonatomic) IBOutlet UIView *valuesBlock;
@property (weak, nonatomic) IBOutlet UIView *viewFavorites;
@property (weak, nonatomic) IBOutlet UILabel *favoriteValue;
@property (weak, nonatomic) IBOutlet UIButton *starButton;

@property (nonatomic,weak) IBOutlet UILabel *userLabel;
@property (nonatomic,weak) IBOutlet UITextView *textString;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;

@end
