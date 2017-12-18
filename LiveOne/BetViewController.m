//
//  BetViewController.m
//  LiveOne
//
//  Created by Александр Мазалецкий on 23.01.17.
//  Copyright © 2017 Remi Development. All rights reserved.
//

#import "BetViewController.h"
#import "UIViewController+AddChild.h"
#import "BetView.h"

@interface BetViewController ()

@end

@implementation BetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    images = [[NSMutableArray alloc]initWithObjects: @"bet0",@"bet1",@"bet2",
     @"bet3",@"bet4", @"bet5", @"bet6", @"bet7", @"bet8", @"bet9", @"bet10", @"bet11", nil
     ];
}



- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideBackButton" object:nil];
    self.tableView.hidden = NO;
}


-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row==0) {
        if (self.tableView.bounds.size.width == 375.0) {
            return 60.0;
        } else if (self.tableView.bounds.size.width<330.0) {
            return 50.0;
        } else if (self.tableView.bounds.size.width<375.0) {
            return 60.0;
        } else {
            return 60.0;
        }
    } else {
        if (self.tableView.bounds.size.width == 375.0) {
            return 94.0;
        } else if (self.tableView.bounds.size.width<330.0) {
            return 76.0;
        } else if (self.tableView.bounds.size.width<375.0) {
            return 84.0;
        } else {
            return 104.0;
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [images count];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BetView *cell = (BetView*) [tableView dequeueReusableCellWithIdentifier:@"betView"];
    
    [tableView registerNib:[UINib nibWithNibName:@"BetView" bundle:nil] forCellReuseIdentifier:@"betView"];
    cell = (BetView*) [tableView dequeueReusableCellWithIdentifier:@"betView"];
    cell.contentImage.image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *game = [self.storyboard instantiateViewControllerWithIdentifier:@"gameViewController"];
    
    self.tableView.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showBackButton" object:nil];
    
    [self.navigationController pushViewController:game animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
