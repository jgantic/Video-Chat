//
//  MapTableTableViewController.m
//  LiveOne
//
//  Created by Александр on 23.08.15.
//  Copyright (c) 2015 Remi Development. All rights reserved.
//
#import "UIMapTableViewCell.h"
#import "MapTableTableViewController.h"

@interface MapTableTableViewController ()

@end

@implementation MapTableTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
     [self.tableView setSeparatorColor:[UIColor grayColor]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    items = [[NSMutableArray alloc]initWithObjects: @"Chicago, USA",@"New York, USA",@"Miami, USA",
             @"Seattle, USA",@"Dallas, USA",@"Boston, USA",
             @"Detroit, USA",@"Chicago, USA",@"New York, USA",
             @"Washington, USA",nil
              ];
    
    times = [[NSMutableArray alloc]initWithObjects: @"25 m",@"50 m",@"60 m",
             @"70 m",@"80 m",@"90 m",
             @"25 m",@"50 m",@"60 m",
             @"655 m",nil
             ];
    
    images = [[NSMutableArray alloc]initWithObjects: @"crown.png",@"crown1.png",@"crown2.png",
              @"crown3.png",@"crown.png",@"crown1.png",@"crown2.png",
              @"crown3.png",@"crown1.png",@"crown2.png", nil
              ];
    
    
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

    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //
    
    
    //if (!cell)
    //{
        [tableView registerNib:[UINib nibWithNibName:@"UIMapTableViewCell" bundle:nil] forCellReuseIdentifier:@"mapTableViewCell"];
        UIMapTableViewCell *cell = (UIMapTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"mapTableViewCell"];
    //}
    
    cell.image.image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
    cell.title.text =  [items objectAtIndex:indexPath.row];
    cell.time.text =  [times objectAtIndex:indexPath.row];
    
    // Configure the cell...
    
    return cell;
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
