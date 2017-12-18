//
//  UIAdView.h
//  LiveOne
//
//  Created by Александр on 14.08.15.
//  Copyright (c) 2015 Remi Development. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIAdView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIImageView *adlogImage;
@property (weak, nonatomic) IBOutlet UILabel *presentedLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightAdLog;


@property (weak, nonatomic) IBOutlet UIImageView *logogroupImage;
@property (weak, nonatomic) IBOutlet UIButton *logoGroup;
@property (weak, nonatomic) IBOutlet UIButton *downButton;

@property (weak, nonatomic) IBOutlet UIButton *backButton;


@end
