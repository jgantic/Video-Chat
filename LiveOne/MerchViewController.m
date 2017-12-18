//
//  MerchViewController.m
//  LiveOne
//
//  Created by Александр Мазалецкий on 10.03.17.
//  Copyright © 2017 Remi Development. All rights reserved.
//

#import "MerchViewController.h"
#import "MerchProductsViewController.h"
#import "BetView.h"

@interface MerchViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MerchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    images = [[NSMutableArray alloc]initWithObjects: @"row0",@"row1",@"row2",
              @"row3",@"row4", @"row5", @"row6", @"row7", @"row8", @"row9", @"row10", @"row11", nil
              ];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setcolorClear11:) name:@"setColorClear11" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setcolorClear12:) name:@"setColorClear12" object:nil];
    
    
    NSLog(@"--width--%f", [UIScreen mainScreen].bounds.size.width);
    if ([UIScreen mainScreen].bounds.size.width<=414) {
        _isPortrait  = YES;
    } else {
        _isPortrait  = NO;
    }
}



- (void) setcolorClear11:(NSNotification*) sender {
    _isPortrait = YES;
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
}


- (void) setcolorClear12:(NSNotification*) sender {
    _isPortrait = NO;;
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_isPortrait) {
        self.view.backgroundColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor clearColor];
    } else {
        self.view.backgroundColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor clearColor];
    }
    [self.tableView reloadData];
    self.tableView.hidden = NO;
}


-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row==0) {
        if (self.tableView.bounds.size.width == 375.0) {
            return 215.0;
        } else if (self.tableView.bounds.size.width<330.0) {
            return 195.0;
        } else if (self.tableView.bounds.size.width<375.0) {
            return 205.0;
        } else {
            return 235.0;
        }
    } else {
        if (self.tableView.bounds.size.width == 375.0) {
            return 115.0;
        } else if (self.tableView.bounds.size.width<330.0) {
            return 95.0;
        } else if (self.tableView.bounds.size.width<375.0) {
            return 105.0;
        } else {
            return 125.0;
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
  
    MerchProductsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"merchProductsViewController"];
    controller.isPortrait = _isPortrait;
    
    self.tableView.hidden = YES;
    self.view.backgroundColor = [UIColor clearColor];
    [self.navigationController pushViewController:controller animated:YES];
    
    
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
