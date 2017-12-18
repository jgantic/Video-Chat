//
//  IKTableViewController.m
//  LiveOne
//
//  Created by Александр on 04.09.15.
//  Copyright (c) 2015 Remi Development. All rights reserved.
//

#import "IKTableViewController.h"
//#import "InstagramKit.h"
//#import "InstagramMedia.h"
#import "Constants.h"
#import "ikTableCellTableViewCell.h"
#import "IKMediaViewController.h"
#import "UIViewController+AddChild.h"
#import "MZFormSheetController.h"
#import "UIViewController+MaryPopin.h"


@interface IKTableViewController ()
@property (nonatomic, strong) NSMutableArray *mediaArray;
@property (nonatomic) CGFloat offset;
//@property (nonatomic, strong) InstagramPaginationInfo *currentPaginationInfo;
//@property (nonatomic, weak) InstagramEngine *instagramEngine;
@property (nonatomic, strong) NSArray *instaImages;
@property (nonatomic, strong) NSArray *instaTitles;
@end


#define kNumberOfCellsInARow 3
#define kFetchItemsCount 9

@implementation IKTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    self.mediaArray = [[NSMutableArray alloc] init];
    self.offset = 0.0f;
    //self.instagramEngine = [InstagramEngine sharedEngine];
    self.instaImages = @[@"insta1.jpg", @"insta2.jpg", @"insta3.jpg", @"insta4.jpg", @"insta5.jpg"];
    self.instaTitles = @[@"The @Packers show no sign of slowing down.", @"The ball's been getting away from Odell Beckham Jr. today.", @"Everything is coming up Packers.", @"Randall Cobb making folks look silly tonight.", @"Giants defense digging DEEP. And it leads to a TD"];
    [self loadMedia];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    // Do any additional setup after loading the view.
}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMedia
{
    //self.currentPaginationInfo = nil;
    [self setTitle:@"Popular Media"];
    //[self.navigationItem.leftBarButtonItem setTitle:@"Log in"];
    //[self.navigationItem.rightBarButtonItem setEnabled:YES];
    [self.mediaArray removeAllObjects];
    [self.tableView reloadData];
    [self requestPopularMedia];
}

- (void)requestPopularMedia
{
    
    /*[self.instagramEngine getMediaForUser:@"20282699" count:kFetchItemsCount maxId:self.currentPaginationInfo.nextMaxId withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        
        self.currentPaginationInfo = paginationInfo;
        
        [self.mediaArray addObjectsFromArray:media];
        [self.tableView reloadData];
        
        
        
    }
    failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Request Self Feed Failed");
    }];*/
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.instaImages count];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ikTableCellTableViewCell *cell = (ikTableCellTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"ikTableViewCell1"];
    

    
    [tableView registerNib:[UINib nibWithNibName:@"ikTableCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"ikTableViewCell1"];
    
    cell = (ikTableCellTableViewCell*) [self.tableView dequeueReusableCellWithIdentifier:@"ikTableViewCell1"];
    
    
    NSString *image = [_instaImages objectAtIndex:indexPath.row];
    NSString *title = [_instaTitles objectAtIndex:indexPath.row];
    
    
    [cell.image setImage:[UIImage imageNamed:image]];
    [cell.label setText:title];
    
    //InstagramMedia *media = self.mediaArray[indexPath.row];
    
    
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // retrive image on global queue
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:media.thumbnailURL]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ikTableCellTableViewCell * cell = (ikTableCellTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            // assign cell image on main thread
            [cell.image setImage:img];
        });
    });*/
    
    //[cell.label setText:media.caption.text];
    
    return cell;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IKMediaViewController *mediaViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IKMediaViewController"];
   
    
    [mediaViewController setPopinTransitionStyle:BKTPopinTransitionStyleCrossDissolve];
    
    //Add options
    [mediaViewController setPopinOptions:BKTPopinDefault];
    
    NSString *image = [_instaImages objectAtIndex:indexPath.row];
    NSString *title = [_instaTitles objectAtIndex:indexPath.row];
    
    [mediaViewController setImage:image];
    
    [mediaViewController setTitle:title];
    
    [mediaViewController setPopinAlignment:BKTPopinAlignementOptionCentered];
    
    //Create a blur parameters object to configure background blur
    BKTBlurParameters *blurParameters = [BKTBlurParameters new];
    blurParameters.alpha = 1.0f;
    blurParameters.radius = 30.0f;
    blurParameters.saturationDeltaFactor = 1.8f;
    //blurParameters.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [mediaViewController setBlurParameters:blurParameters];
    
    //Add option for a blurry background
    [mediaViewController  setPopinOptions:[mediaViewController popinOptions]|BKTPopinBlurryDimmingView];
    
    
    [self.navigationController presentPopinController:mediaViewController animated:YES completion:^{
        NSLog(@"Popin presented !");
    }];
    
    //[self.navigationController pushViewController:mediaViewController animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
    // Calculate where the collection view should be at the right-hand end item
    /*float contentOffsetWhenFullyScrolledRight = self.tableView.frame.size.width * ([self.mediaArray count] -1);
    
    if (scrollview.contentOffset.x == contentOffsetWhenFullyScrolledRight) {
        
        
    } else if (scrollview.contentOffset.x == 0)  {
        
        // user is scrolling to the left from the first item to the fake 'item N'.
        // reposition offset to show the 'real' item N at the right end end of the collection view
        
        if ((self.offset==0.0f) || (self.offset<scrollview.contentOffset.y)) {
            self.offset = scrollview.contentOffset.y;
            [self requestPopularMedia];
        }
    }*/
}

@end
