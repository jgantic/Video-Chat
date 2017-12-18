//
//  MerchSuccessViewController.m
//  LiveOne
//
//  Created by Александр Мазалецкий on 17.03.17.
//  Copyright © 2017 Remi Development. All rights reserved.
//

#import "MerchSuccessViewController.h"
#import "BetView.h"

@interface MerchSuccessViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MerchSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    images = [[NSMutableArray alloc]initWithObjects: @"continue", nil
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
        return 330.0;
    } else if (self.tableView.bounds.size.width<330.0) {
        return 250.0;
    } else if (self.tableView.bounds.size.width<375.0) {
        return 330.0;
    } else {
        return 350.0;
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
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController  popViewControllerAnimated:YES];
}


@end
