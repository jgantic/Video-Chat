//
//  ViewController.m
//  LiveOne
//
//  Created by Александр on 06.08.15.
//  Copyright (c) 2015 Remi Development. All rights reserved.
//

#import "TwitterViewController.h"
#import <TwitterKit/TwitterKit.h>
#import "WebViewController.h"
#import "UIViewController+MaryPopin.h"

@interface TwitterViewController ()

@end

@implementation TwitterViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TWTRTweetView appearance].theme = TWTRTweetViewThemeDark;
    
    
    [TWTRTweetView appearance].backgroundColor = [UIColor clearColor];
    
    // Setting colors directly
    [TWTRTweetView appearance].primaryTextColor = [UIColor whiteColor];
   
    [[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
        if (guestSession) {
            TWTRAPIClient *APIClient = [[Twitter sharedInstance] APIClient];
            
           
            TWTRUserTimelineDataSource *userTimelineDataSource = [[TWTRUserTimelineDataSource alloc] initWithScreenName:@"NFLonCBS" APIClient:APIClient];
            
            self.dataSource = userTimelineDataSource;
            
            
            self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
            self.view.opaque = NO;
            self.showTweetActions = YES;
            self.tableView.delegate = self;
            
            self.tableView.backgroundColor = [UIColor  clearColor];
            self.tableView.backgroundView.backgroundColor = [UIColor  clearColor];
        

        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
    TWTRTweetTableViewCell *tableCell = (TWTRTweetTableViewCell*) cell;

    tableCell.backgroundColor = [UIColor clearColor];
 
}


-(void) tweetView:(TWTRTweetView *)tweetView didTapURL:(NSURL *)url {
    
    UIStoryboard *mainStoryboard;
    
    mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
  
    [_player pauseContent];
    
    WebViewController *mediaViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"webViewController"];
    
    
    [mediaViewController setUrl:url];
    
    
    [mediaViewController setPopinTransitionStyle:BKTPopinTransitionStyleCrossDissolve];
    
    
    //Add options
    [mediaViewController setPopinOptions:BKTPopinDefault];
    
    
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
    
    mediaViewController.player = _player;
    
    [self.navigationController presentPopinController:mediaViewController animated:YES completion:^{
        
    }];
    

}




- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
      self.tableView.backgroundColor = [UIColor  clearColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
