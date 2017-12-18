//
//  MerchProductsViewController.h
//  LiveOne
//
//  Created by Александр Мазалецкий on 10.03.17.
//  Copyright © 2017 Remi Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchProductsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *images;
}


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) BOOL isPortrait;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
