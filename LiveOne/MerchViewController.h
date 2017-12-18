//
//  MerchViewController.h
//  LiveOne
//
//  Created by Александр Мазалецкий on 10.03.17.
//  Copyright © 2017 Remi Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *images;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL isPortrait;
@end
