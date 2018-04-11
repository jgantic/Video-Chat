//
//  StoreViewController.h
//  SZZL
//
//  Created by Vasily Krainov on 07/04/2018.
//  Copyright © 2018 Remi Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIView *overlayView;

@end
