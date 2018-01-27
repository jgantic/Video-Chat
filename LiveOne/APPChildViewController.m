//
//  APPChildViewController.m
//  PageApp
//
//  Created by Rafael Garcia Leiva on 10/06/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "APPChildViewController.h"

#import <AFNetworking.h>

@interface APPChildViewController ()

@end

@implementation APPChildViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    
    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.screenNumber.text = [NSString stringWithFormat:@"Screen #%ld", (long)self.index];
    if (self.index == 0) {
      self.image.hidden = YES;
      _image.image = [UIImage imageNamed:@"statistics"];
      self.statView.hidden = NO;

      AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
      NSString *url = @"http://api.sportradar.us/nfl-ot2/games/c8dc876a-099e-4e95-93dc-0eb143c6954f/statistics.json?api_key=4hu6cgvabrce6c9sv9dabpsm";
      [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){

          NSDictionary *result = responseObject;
          NSArray *homePlayers = result[@"statistics"][@"home"][@"passing"][@"players"];
          if (homePlayers.count > 0) {
            NSDictionary *player = homePlayers[0];
            self.nameLabel.text = player[@"name"];
            self.ratingLabel.text = [NSString stringWithFormat:@"Rating = %li", [player[@"rating"] integerValue]];
            self.yardsLabel.text = [NSString stringWithFormat:@"Yards = %li", [player[@"yards"] integerValue]];
            self.completionsLabel.text = [NSString stringWithFormat:@"Completions = %li", [player[@"completions"] integerValue]];
            self.cmpPctLabel.text = [NSString stringWithFormat:@"Completions = %@%%", player[@"cmp_pct"]];
            self.touchdownsLabel.text = [NSString stringWithFormat:@"Touchdowns = %li", [player[@"touchdowns"] integerValue]];
          }

        });
      } failure: ^(NSURLSessionDataTask *task, NSError *error) {
      }];

    } else {
      self.image.hidden = NO;
      _image.image = [UIImage imageNamed:@"statistics2"];
      self.statView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
