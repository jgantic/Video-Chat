//
//  TourTableViewController.m
//  LiveOne
//
//  Created by Александр on 23.08.15.
//  Copyright (c) 2015 Remi Development. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TourTableViewController.h"
#import "UITourTableViewCell.h"
#import "headerTourTableViewCell.h"
#import "adTableViewCell.h"
#import "IKMediaViewController.h"
#import "YoutubeViewController.h"
#import "UIViewController+MaryPopin.h"

@interface TourTableViewController ()

@end

@implementation TourTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    titles = [[NSMutableArray alloc]initWithObjects: @"Chicago, USA ",@"Miami, USA", @"New York, USA ", @"Dallas, USA", @"Pittsburgh, USA", @"Green Bay, USA", @"Detroit, USA", @"Philadelphia, USA", @"Indianapolis, USA", nil
             ];
    
    subTitles = [[NSMutableArray alloc]initWithObjects: @"Sun, 12PM • Soldier Field", @"Sun, 12PM • Hard Rock Stadium", @"Sun, 12PM • Metlife Stadium", @"Sun, 12PM •AT&T Stadium", @"Sun, 12PM • Heinz Field", @"Sun, 12PM • Lambeau Field", @"Sun, 12PM • Ford Field", @"Sun, 12PM • Lincoln Financial Field", @"Sun, 12PM • Lucas Oil Stadium", nil
             ];
    
    dateTitles = [[NSMutableArray alloc]initWithObjects: @"8",@"15", @"22", @"29", @"6", @"13", @"20", @"27", @"13", nil
                 ];
   
    
    monthTitles = [[NSMutableArray alloc]initWithObjects: @"SEP",@"SEP", @"SEP", @"SEP", @"OCT", @"OCT", @"OCT", @"OCT", @"NOV", nil
                   ];
     [self.tableView setSeparatorColor:[UIColor grayColor]];
    
    _headerString = @"Near you";
    
}



-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = _headerString;
            break;
    }
    return sectionName;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section==1) && (indexPath.row==4)) {
        return 120.f;
    } else {
        return 80.f;
    }
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    [tableView registerNib:[UINib nibWithNibName:@"headerTourTableViewCell" bundle:nil] forCellReuseIdentifier:@"headerTourTableViewCell"];
    headerTourTableViewCell *cell = (headerTourTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"headerTourTableViewCell"];
    
    if (section==0) {
        cell.title.text = @"Near you";
    } else {
        cell.title.text = @"Upcoming";
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    } else {
        return [titles count]-1;
    }
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if ((indexPath.section==1) && (indexPath.row==4)) {
        
        adTableViewCell *cell = (adTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"adTableViewCell"];
        
        
        [tableView registerNib:[UINib nibWithNibName:@"adTableViewCell" bundle:nil] forCellReuseIdentifier:@"adTableViewCell"];
        cell = (adTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"adTableViewCell"];
        return cell;
        
    } else {
        UITourTableViewCell *cell = (UITourTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"tourTableViewCell"];
    

        [tableView registerNib:[UINib nibWithNibName:@"UITourTableViewCell" bundle:nil] forCellReuseIdentifier:@"tourTableViewCell"];
        cell = (UITourTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"tourTableViewCell"];
    
    
        // Configure the cell...
    
        if ((indexPath.row==0) && (indexPath.section==1)) {
            UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
            top.backgroundColor = [UIColor colorWithRed:163.0/255.0 green:2.0/255.0 blue:20.0/255.0 alpha:1.0];
        
            [cell.contentView addSubview:top];
        
            UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-1, self.view.frame.size.width, 1)];
            bottom.backgroundColor = [UIColor colorWithRed:163.0/255.0 green:2.0/255.0 blue:20.0/255.0 alpha:1.0];
        
            [cell.contentView addSubview:bottom];
        
            [cell.title setFont:[UIFont boldSystemFontOfSize:12.0f]];
            cell.title.text = [titles objectAtIndex:indexPath.row];
            cell.subTitle.text = [subTitles objectAtIndex:indexPath.row];
            cell.dateLabel.text = [dateTitles objectAtIndex:indexPath.row];
            cell.monthLabel.text = [monthTitles objectAtIndex:indexPath.row];
        } else {
            cell.title.text = [titles objectAtIndex:indexPath.row];
            cell.dateLabel.text = [dateTitles objectAtIndex:indexPath.row];
            cell.subTitle.text = [subTitles objectAtIndex:indexPath.row];
            cell.monthLabel.text = [monthTitles objectAtIndex:indexPath.row];
        }
        return cell;
    }
}


- (void)tableView:(UITableView * _Nonnull)tableView
didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
    
    
    if ((indexPath.row==4) && (indexPath.section==1)) {
        [_player pauseContent];
    
        YoutubeViewController *mediaViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"youtubeViewController"];

    
        mediaViewController.url = @"3cxixDgHUYw";
        
        
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
}


@end
