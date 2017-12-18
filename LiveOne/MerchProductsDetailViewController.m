//
//  MerchProductsDetailViewController.m
//  LiveOne
//
//  Created by Александр Мазалецкий on 17.03.17.
//  Copyright © 2017 Remi Development. All rights reserved.
//

#import "MerchProductsDetailViewController.h"
#import "BetView.h"
#import "MerchSuccessViewController.h"

@interface MerchProductsDetailViewController ()

@end

@implementation MerchProductsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    images = [[NSMutableArray alloc]initWithObjects: @"detail1",@"detail2", nil
              ];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.tableView.bounds.size.width == 375.0) {
        return 430.0;
    } else if (self.tableView.bounds.size.width<330.0) {
        return 350.0;
    } else if (self.tableView.bounds.size.width<375.0) {
        return 380.0;
    } else {
        return 490.0;
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
    
    if (_isPortrait == YES) {
        cell.contentView.backgroundColor = [UIColor clearColor];
    } else {
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MerchSuccessViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"merchProductsSuccessViewController"];
    
    self.tableView.hidden = YES;
    _backButton.hidden = YES;
    _titleLabel.hidden = YES;
    self.view.backgroundColor = [UIColor clearColor];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController  popViewControllerAnimated:YES];
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
