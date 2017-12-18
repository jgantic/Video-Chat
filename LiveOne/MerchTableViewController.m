//
//  MetchTableViewController.m
//  LiveOne
//
//  Created by Александр on 23.08.15.
//  Copyright (c) 2015 Remi Development. All rights reserved.
//

#import "MerchTableViewController.h"
#import "UIMerchTableViewCell.h"
#import "UIViewController+MaryPopin.h"
#import "YoutubeViewController.h"
#import "WebViewController.h"

@interface MerchTableViewController ()

@end

@implementation MerchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView setSeparatorColor:[UIColor redColor]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 240.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //
    
    
    //if (!cell)
    //{
    [tableView registerNib:[UINib nibWithNibName:@"UIMerchTableViewCell" bundle:nil] forCellReuseIdentifier:@"merchTableViewCell"];
    UIMerchTableViewCell *cell = (UIMerchTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"merchTableViewCell"];
    //}
    // Configure the cell...
    
    if (indexPath.row==0) {
        cell.storeImage.image = [UIImage imageNamed:@"store1"];
    }
    
    
    if (indexPath.row==1) {
        cell.storeImage.image = [UIImage imageNamed:@"store2"];
    }
    
    if (indexPath.row==2) {
        cell.storeImage.image = [UIImage imageNamed:@"store3"];
    }
    
    
    [cell.butButton addTarget:self action:@selector(clickBuy:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}


- (void) clickBuy:(id) sender {
    [_player pauseContent];
    
    WebViewController *mediaViewController = [self.storyboard  instantiateViewControllerWithIdentifier:@"webViewController"];
    
    
    [mediaViewController setUrl:[NSURL URLWithString:@"http://www.nflshop.com"]];
    
    
    [mediaViewController setPopinTransitionStyle:BKTPopinTransitionStyleCrossDissolve];
    

    //Add options
    [mediaViewController setPopinOptions:BKTPopinDefault];
    
    
    [mediaViewController setPopinAlignment:BKTPopinAlignementOptionCentered];
    
    
    
    //Create a blur parameters object to configure background blur
    BKTBlurParameters *blurParameters = [BKTBlurParameters new];
    blurParameters.alpha = 1.0f;
    blurParameters.radius = 8.0f;
    blurParameters.saturationDeltaFactor = 1.8f;
    blurParameters.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [mediaViewController setBlurParameters:blurParameters];
    
    //Add option for a blurry background
    [mediaViewController  setPopinOptions:[mediaViewController popinOptions]|BKTPopinBlurryDimmingView];
    
    mediaViewController.player = _player;
    
    [self.navigationController presentPopinController:mediaViewController animated:YES completion:^{
        
    }];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
