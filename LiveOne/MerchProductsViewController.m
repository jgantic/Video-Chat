//
//  MerchProductsViewController.m
//  LiveOne
//
//  Created by Александр Мазалецкий on 10.03.17.
//  Copyright © 2017 Remi Development. All rights reserved.
//

#import "MerchProductsViewController.h"
#import "BetView.h"
#import "MerchProductsDetailViewController.h"
@interface MerchProductsViewController ()

@end

@implementation MerchProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    images = [[NSMutableArray alloc]initWithObjects: @"prod1",@"prod2",@"prod3",
              @"prod4",@"prod5", @"prod6", nil
              ];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setcolorClear21:) name:@"setColorClear21" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setcolorClear22:) name:@"setColorClear22" object:nil];
    
    if ([UIScreen mainScreen].bounds.size.width<=414) {
        _isPortrait  = YES;
    } else {
        _isPortrait  = NO;
    }
}


- (void) setcolorClear21:(NSNotification*) sender {
    _isPortrait = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView reloadData];
}


- (void) setcolorClear22:(NSNotification*) sender {
    _isPortrait = NO;
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView reloadData];
}



- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_isPortrait) {
       self.tableView.backgroundColor = [UIColor clearColor];
    } else {
        self.tableView.backgroundColor = [UIColor clearColor];
    }
    
    [self.tableView reloadData];

    self.tableView.hidden = NO;
}


-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.tableView.bounds.size.width == 375.0) {
        return 245.0;
    } else if (self.tableView.bounds.size.width<330.0) {
        return 205.0;
    } else if (self.tableView.bounds.size.width<375.0) {
        return 205.0;
    } else {
        return 245.0;
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
    //merchProductsDetailViewController
    MerchProductsDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"merchProductsDetailViewController"];
 
    self.tableView.hidden = YES;
    _backButton.hidden = YES;
    _titleLabel.hidden = YES;
    self.view.backgroundColor = [UIColor clearColor];
    [self.navigationController pushViewController:controller animated:YES];
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
