//
//  IKTableViewController.h
//  LiveOne
//
//  Created by Александр on 04.09.15.
//  Copyright (c) 2015 Remi Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
