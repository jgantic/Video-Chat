//
//  MainViewController.h
//  LiveOne
//
//  Created by Александр on 06.08.15.
//  Copyright (c) 2015 Remi Development. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "UIViewController+AddChild.h"
#import "Views.h"
#import "DCPathButton.h"
#import "VKVideoPlayer.h"
#import "SMWheelControl.h"
#import "UIAdView.h"
#import "AdSideViewController.h"
#import "VideoSideViewController.h"
#import "SurveySideViewController.h"
#import "MenuButton.h"

@interface MainViewController : UIViewController <SMWheelControlDelegate, SMWheelControlDataSource, UIGestureRecognizerDelegate, VKVideoPlayerDelegate, DCPathButtonDelegate, AdSideViewControllerDelegate, VideoSideViewControllerDelegate, SurveySideViewControllerDelegate, MenuButtonProtocol>

@property (strong, nonatomic) UITwitterView *twitterView;
@property (strong, nonatomic) UIInstagramView *instagramView;
@property (strong, nonatomic) UIView *chatView;
@property (strong, nonatomic) UIView *tourView;
@property (strong, nonatomic) UIView *merchView;
@property (strong, nonatomic) UIView *merchTableView;
@property (strong, nonatomic) UIView *mapView;
@property (strong, nonatomic) UIView *ticketView;
@property (strong, nonatomic) UIBioView *bioView;
@property (strong, nonatomic) UIAdView *viewAds;
@property (strong, nonatomic) UIView *overlay;
@property (strong, nonatomic) UIView *buttonsView;
@property (nonatomic, strong) VKVideoPlayer* player;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIView *videoCallView;
@property (nonatomic, strong) UIView *storeView;

@end
