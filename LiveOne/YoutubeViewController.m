//
//  YoutubeViewController.m
//  LiveOne
//
//  Created by Александр on 17.09.15.
//  Copyright © 2015 Remi Development. All rights reserved.
//

#import "YoutubeViewController.h"
#import "UIViewController+MaryPopin.h"
#import <XCDYouTubeKit/XCDYouTubeKit.h>
@import CoreMedia;

@interface YoutubeViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic, strong) XCDYouTubeVideoPlayerViewController *videoPlayerViewController;
@end

@implementation YoutubeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.frame = CGRectMake(78, 40, self.view.frame.size.width-145, self.view.frame.size.height-80);
    
    self.closeButton.frame = CGRectMake(self.view.frame.size.width-self.closeButton.frame.size.width-10,  self.closeButton.frame.origin.y, self.closeButton.frame.size.width, self.closeButton.frame.size.height);
    
   
    if (_url==nil) {
        _playerVideo.avPlayer.volume = 1.0;
        _playerVideo.view.frame = _contentView.bounds;

        [_contentView addSubview:_playerVideo.view];
    } else {
        _videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:_url];
        
        _videoPlayerViewController.preferredVideoQualities = @[@(XCDYouTubeVideoQualitySmall240)];
        
        [_videoPlayerViewController presentInView:self.contentView];
        
        [_videoPlayerViewController.moviePlayer play];
    }
    
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self setModalPresentationStyle:UIModalPresentationCustom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonPressed:(id)sender {
    [_videoPlayerViewController.moviePlayer stop];
    [self.presentingPopinViewController dismissCurrentPopinControllerAnimated:YES completion:^{
        
        if (_url==nil) {
            _playerVideo.view.frame = _cell.view.bounds;
            _playerVideo.avPlayer.volume = 0.0;
            _playerVideo.playerControlsEnabled = NO;
            _playerVideo.view.playerControlsAutoHideTime = @0;
            [_cell.view addSubview:_playerVideo.view];
            [_tapView.superview insertSubview:_tapView aboveSubview:_playerVideo.view];
        }
        
        [_player playContent];
    }];
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
