//
//  APPChildViewController.h
//  PageApp
//
//  Created by Rafael Garcia Leiva on 10/06/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPChildViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UIView *statView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *yardsLabel;
@property (weak, nonatomic) IBOutlet UILabel *completionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *cmpPctLabel;
@property (weak, nonatomic) IBOutlet UILabel *touchdownsLabel;

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UILabel *screenNumber;

@end
