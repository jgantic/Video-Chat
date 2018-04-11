//
//  MainViewController.m
//  LiveOne
//
//  Created by Александр on 06.08.15.
//  Copyright (c) 2015 Remi Development. All rights reserved.
//

#import "UIView+DCAnimationKit.h"
#import "MainViewController.h"
#import "MapViewController.h"
#import "MapTableTableViewController.h"
#import "MerchTableViewController.h"
#import "TourTableViewController.h"
#import "TwitterViewController.h"
#import "IKCollectionViewController.h"
#import "VKVideoPlayer.h"
#import "VKVideoPlayerCaptionSRT.h"
#import "SMWheelControl.h"
#import "UIAdView.h"
#import "AMPopTip.h"
#import "JHChainableAnimations.h"
#import "UIImage+Alpha.h"
#import <XCDYouTubeKit/XCDYouTubeKit.h>
#import "DMChatRoomViewController.h"
#import "BetViewController.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import  "UIColor+Hex.h"
#import "OnboardingContentViewController.h"
#import "OnboardingViewController.h"
#import "DAKeyboardControl.h"
#import "APPViewController.h"
#import "MerchViewController.h"
#import "AnimationView.h"
#import "Extensions.h"
#import "UIImage+animatedGIF.h"
#import "MenuButton.h"
#import "AdTopBar.h"
#import "RegistrationViewController.h"
#import "StoreViewController.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@interface MainViewController ()
@property (nonatomic, strong) TwitterViewController *twitter;

@property (nonatomic, strong) UINavigationController *merchTable;
@property (nonatomic, strong) UIView *merchTableViewController;

@property (nonatomic, strong) UIView *twitterViewController;
@property (nonatomic, strong) UIView *instagramViewController;
@property (nonatomic, strong) UIView *tourViewController;
@property (nonatomic, strong) UIView *merchViewController;
@property (nonatomic, strong) UIView *mapViewController;
@property (nonatomic, strong) UIView *chatViewController;
@property (nonatomic, strong) UIView *ticketViewController;

@property (nonatomic, strong) UIActivityViewController *activity;
@property (nonatomic, strong) IKCollectionViewController *instagram;
@property (nonatomic, strong) UINavigationController *merch;
@property (nonatomic, strong) APPViewController *tour;
@property (nonatomic, strong) DMChatRoomViewController *chat;
@property (nonatomic, strong) MapViewController*mapController;
@property (nonatomic, strong) MapTableTableViewController *listController;
@property (nonatomic, strong) TourTableViewController *ticketController;



@property (nonatomic, strong) UIView *banner;
@property (nonatomic, strong) UIButton *buttonMap;
@property (nonatomic, strong) UIButton *buttonList;
@property (nonatomic) BOOL showMap;
@property (nonatomic) BOOL showList;
@property (nonatomic) BOOL isTwitter;
@property (nonatomic) BOOL isInstagram;
@property (nonatomic) BOOL isMerch;
@property (nonatomic) BOOL isTour;
@property (nonatomic) BOOL isChat;
@property (nonatomic) BOOL isMap;

@property (nonatomic, strong) DCPathButton *mainBtn;
@property (nonatomic) BOOL bloomYes;
@property (nonatomic) BOOL isPortrate;
@property (nonatomic, strong) NSString *currentLanguageCode;
@property (nonatomic, weak) SMWheelControl *wheel;
@property (nonatomic, strong) AMPopTip *popTip;
@property (nonatomic, strong) UIImageView *defaultImage;

@property (nonatomic) BOOL isShowSwx;
@property (nonatomic) BOOL isSuccessW;

@property (nonatomic, strong) MenuButton *menu;

@property (nonatomic, assign) NSInteger adType; // 0 - buy a burger, 1 - see movie trailer, 2 - shop, 3 - survey
@property (nonatomic, strong) AdSideViewController *adSideViewController;
@property (nonatomic, strong) VideoSideViewController *videoSideViewController;
@property (nonatomic, strong) SurveySideViewController *surveySideViewController;

@end

@implementation MainViewController
BOOL swirleWhite = YES;

NSTimeInterval adInterval;
NSTimeInterval adShowDuration;
NSTimeInterval adAnimationDuration;
CGFloat adMargin; // it is applied to top, bottom, left, right of the image and the label, and between the image and the label
UIColor *adBackgroundColor;
UIColor *adBorderColor;
CGFloat adBorderWidth;
NSMutableAttributedString *adText;
UIColor *adTextColor;
UIFont *adTextFont;
UIFont *adTextBoldFont;
NSString *adImage;

float bearing = 0.0;

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    
    self.view.keyboardTriggerOffset = 44.0;
    [self.view addKeyboardPanningWithFrameBasedActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        
    } constraintBasedActionHandler:nil];

    _isShowSwx = NO;
    _isSuccessW = NO;
    _bloomYes = NO;
    [[UITextField appearance] setTintColor:[UIColor orangeColor]];

   
    self.player = [[VKVideoPlayer alloc] init];
    self.player.muted = NO;
    self.player.delegate = self;
    
    self.player.avPlayer.rate = 0.0;
   
    self.player.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height/2);
    
    self.player.playerControlsEnabled = YES;
    self.player.view.playerControlsAutoHideTime = @2;
    [self.view addSubview:self.player.view];
    
    
    [self registerForKeyboardNotifications];
    
    
    
    //add player to controllers
    _chat.player = _player;
    _twitter.player = _player;
   

  // menu

  self.menu = [[MenuButton alloc] initWithParentView:self.view];
  self.menu.menuDelegate = self;
  [self.view addSubview:self.menu];

  UIButton *twitterMenu = [[UIButton alloc] init];
  [self.menu addMenuButton:twitterMenu];
  [twitterMenu addTarget:self action:@selector(twitterAction) forControlEvents:UIControlEventTouchUpInside];
  [twitterMenu setImage:[UIImage imageNamed:@"twitter-white.png"] forState:UIControlStateNormal];

  UIButton *chatMenu = [[UIButton alloc] init];
  [self.menu addMenuButton:chatMenu];
  [chatMenu addTarget:self action:@selector(chatAction) forControlEvents:UIControlEventTouchUpInside];
  [chatMenu setImage:[UIImage imageNamed:@"menu-chat.png"] forState:UIControlStateNormal];

  UIButton *regMenu = [[UIButton alloc] init];
  [self.menu addMenuButton:regMenu];
  [regMenu addTarget:self action:@selector(registrationAction) forControlEvents:UIControlEventTouchUpInside];
  [regMenu setImage:[UIImage imageNamed:@"menu-reg.png"] forState:UIControlStateNormal];

  UIButton *shopMenu = [[UIButton alloc] init];
  [self.menu addMenuButton:shopMenu];
  [shopMenu addTarget:self action:@selector(shopAction) forControlEvents:UIControlEventTouchUpInside];
  [shopMenu setImage:[UIImage imageNamed:@"menu-cart.png"] forState:UIControlStateNormal];

 
    //Add buttons to crowdsurfing
    UIImage *imageAlpha = [[UIImage imageNamed:@"Whhite_swirl"] imageWithAlpha];
    

    
    _mainBtn = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"Whhite_swirl"] highlightedImage:imageAlpha];
   
    DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-placebutton"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    DCPathItemButton *itemButton_4 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    DCPathItemButton *itemButton_5 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    DCPathItemButton *itemButton_6 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    DCPathItemButton *itemButton_7 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    DCPathItemButton *itemButton_8 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    DCPathItemButton *itemButton_9 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    DCPathItemButton *itemButton_10 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    DCPathItemButton *itemButton_11 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                            highlightedImage:[UIImage imageNamed:@"button"]
                                                             backgroundImage:[UIImage imageNamed:@"button"]
                                                  backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    DCPathItemButton *itemButton_12 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                            highlightedImage:[UIImage imageNamed:@"button"]
                                                             backgroundImage:[UIImage imageNamed:@"button"]
                                                  backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    
    
    
    
    _mainBtn.delegate = self;
    _mainBtn.dcButtonCenter = CGPointMake(self.view.bounds.size.width-45, self.view.bounds.size.height-38);
    _mainBtn.bloomRadius = 115.0f;

    _mainBtn.bloomAngel = 320.0f;
    
    _mainBtn.allowSounds = NO;
    _mainBtn.allowCenterButtonRotation = YES;
    
    [_mainBtn addPathItems:@[itemButton_1,
                                 itemButton_2,
                                 itemButton_3,
                                 itemButton_4,
                                 itemButton_5,
                                 itemButton_6,
                                 itemButton_7,
                                 itemButton_8,
                                 itemButton_9,
                                 itemButton_10,
                                 itemButton_11,
                                 itemButton_12,
                                 ]];
    [self playVideo];
    
    [AMPopTip appearance].font = [UIFont fontWithName:@"Avenir-Medium" size:14];
    [AMPopTip appearance].textColor = [UIColor whiteColor];
    [AMPopTip appearance].popoverColor = [UIColor clearColor];
    [AMPopTip appearance].borderWidth = 2.0f;
    [AMPopTip appearance].borderColor = [UIColor whiteColor];
    
    [AMPopTip appearance].layer.cornerRadius = 1.0;
    
    self.popTip = [AMPopTip popTip];
    self.popTip.edgeMargin = 5;
    self.popTip.offset = 2;
    self.popTip.edgeInsets = UIEdgeInsetsMake(5, 5, 0, 5);
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"GO CROWDSURFING!"];
    NSRange selectedRange = NSMakeRange(0, 8); 
    
    [string beginEditing];

    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,16)];
    
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"Helvetica" size:14.0]
                   range:NSMakeRange(0,16)];
    
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]
                   range:selectedRange];

    
    [string endEditing];
    
 
    
   
    //[self.popTip showAttributedText:string direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:self.mainBtn.frame];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [self deviceForDeviceOrientation:[UIDevice currentDevice].orientation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBackButton:) name:@"showBackButton" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideBackButton:) name:@"hideBackButton" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(anotherBackground:) name:@"anotherBackground" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnBackground:) name:@"returnBackground" object:nil];

	self.adType = -1;

}

- (void) returnBackground:(id) sender {
    _isSuccessW = NO;
    self.merchView.backgroundColor = [UIColor clearColor];
    
    for (UIView *view in self.merchView.subviews) {
        if (view.tag==1123) {
            view.hidden=NO;
        }
    }
}
- (void) anotherBackground:(id) sender {
    _isSuccessW = YES;
    if (_isPortrate==YES) {
        self.merchView.backgroundColor = [UIColor colorWithRed:109.0/255.0 green:182.0/255.0 blue:29.0/255.0 alpha:1.0];
        self.merchView.alpha = 1.0;
    }
    
    for (UIView *view in self.merchView.subviews) {
        if (view.tag==1123) {
            view.hidden=YES;
        }
    }
}

- (void) backButtonAction:(id) sender {
    
    NSLog(@"add new view");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backButtonAction" object:nil];
}

- (void) showBackButton:(id) sender {
    self.viewAds.headerImage.hidden = YES;
    
    _isShowSwx = YES;
    UIImage *image = [UIImage imageNamed:@"swx"];
    [self.viewAds.adlogImage setImage:image];
    
   
  
    if (_isPortrate==YES) {
        
        UIButton *button = [self.merchView viewWithTag:1123];
        [button removeFromSuperview];
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 8,  65.0, 22.0)];
        [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
        backButton.contentMode = UIViewContentModeCenter;
        [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        backButton.tag=1123;
        [self.merchView addSubview:backButton];
    } else {
        UIButton *button = [self.merchView viewWithTag:1123];
        [button removeFromSuperview];
        
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5,  65.0, 22.0)];
        [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
        backButton.contentMode = UIViewContentModeCenter;
        [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        backButton.tag=1123;
        [self.merchView addSubview:backButton];
    }
}


- (void) hideBackButton:(id) sender {
    
    _isShowSwx = NO;
    UIImage *image = [UIImage imageNamed:@"MD"];
    [self.viewAds.adlogImage setImage:image];
    
    self.viewAds.headerImage.hidden = NO;
    
    for (UIView *view in self.merchView.subviews) {
        if (view.tag==1123) {
            view.hidden=YES;
        }
    }
}

- (void) ShowLandscape {


    
    self.viewAds.hidden = NO;
    self.overlay.frame = self.chatView.frame;
    self.overlay.hidden = YES;
    
    for (UIView *view in self.merchView.subviews) {
        if (view.tag==1123) {
            view.frame = CGRectMake(5, 5,  65.0, 22.0);
        }
    }
    
    _isPortrate = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    [_mainBtn removeFromSuperview];
    [_wheel removeFromSuperview];
    [_overlay removeFromSuperview];
    [_viewAds removeFromSuperview];
    [_twitterView removeFromSuperview];
    [_instagramView removeFromSuperview];
    [_tourView removeFromSuperview];
    [_merchView removeFromSuperview];
    [_merchTableView removeFromSuperview];
    [_mapView removeFromSuperview];
    [_chatView removeFromSuperview];
    [_defaultImage removeFromSuperview];
    [_ticketView removeFromSuperview];

    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    self.view.opaque = NO;
    
 
    _bioView.hidden = YES;
    
    
     if (self.viewAds==NULL) {
         //View Ads
         self.viewAds = [[UIAdView alloc] init];
    
         [self.viewAds.mainView  setFrame:CGRectMake(0, 0, ((self.view.bounds.size.width*45)/100), 40)];
         
         
         self.viewAds.mainView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.50];
         self.viewAds.titleLabel.text = [@"Twitter" uppercaseString];
    
         self.viewAds.presentedLabel.text = [self.viewAds.presentedLabel.text uppercaseString];
    
         self.viewAds.hidden = YES;
         self.viewAds.downButton.hidden = YES;
         
         [self.viewAds.backButton addTarget:self
                                     action:@selector(backButtonAction:)
                           forControlEvents:UIControlEventTouchUpInside];
     } else {
         self.viewAds.mainView.frame = CGRectMake(0, 0, ((self.view.bounds.size.width*45)/100), 40);
         self.viewAds.mainView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.50];
  
         if (_bloomYes==NO) {
             self.viewAds.hidden = YES;
         }
     }
    
    
    UIView *overlay = [[UIView alloc] initWithFrame: CGRectMake(0, 0, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height)];
    
    overlay.backgroundColor = [UIColor blackColor];
    
    overlay.alpha = 0.4f;
    
    self.overlay= overlay;
    
    if (_bloomYes==NO) {
        self.overlay.hidden = YES;
    }
    
    
    
    /*TWITTER*/
    
    
    if (self.twitterView==NULL) {
      CGFloat w = self.view.bounds.size.width * 0.45;
      CGFloat h = 30;

      AdTopBar *top = [[NSBundle mainBundle] loadNibNamed:@"AdTopBar" owner:self options:nil][0];
      top.leftImage.image = [UIImage imageNamed:@"twitter-white.png"];
      top.rightImage.image = [UIImage imageNamed:@"honeywell.png"];
      top.frame = CGRectMake(0, 0, w, h);

        self.twitterView = [[UITwitterView alloc] initWithFrame: CGRectMake(0, 0, w, self.view.bounds.size.height)];
    
        self.twitterView.hidden = YES;
    
        _twitterViewController = [[UIView alloc] initWithFrame: CGRectMake(0, h, w, self.view.bounds.size.height - h)];
    
        _twitter = [[TwitterViewController alloc] init];
    
        [self addChildController:_twitter toView:_twitterViewController];
    
      [self.twitterView  addSubview:top];
        [self.twitterView  addSubview:_twitterViewController];
    } else {
      CGFloat w = self.view.bounds.size.width * 0.45;
      CGFloat h = 30;

      self.twitterView.frame =  CGRectMake(0, 5, w, self.view.bounds.size.height);
      _twitterViewController.frame = CGRectMake(0, h, w, self.view.bounds.size.height);
        
        for (UIView *view in self.twitterView.subviews) {
            if (view.tag==12) {
                view.hidden=YES;
            }
        }
        
        if (_bloomYes==NO) {
            self.twitterView.hidden = YES;
        }
    }
    
    
    
    
    //INSTRAGRAM
    
    
    if (self.instagramView==NULL) {
        self.instagramView = [[UIInstagramView alloc] initWithFrame: CGRectMake(0, 5, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height)];
    
        _instagramViewController = [[UIView alloc] initWithFrame: CGRectMake(0, 40, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height-50)];
    
        self.instagramView.hidden = YES;
    
        _instagram = [ self.storyboard instantiateViewControllerWithIdentifier:@"IKCollectionViewController1"];
    
        _instagram.view.backgroundColor = [UIColor clearColor];
    
        [self addChildController:_instagram toView:_instagramViewController];
    
        [self.instagramView  addSubview:_instagramViewController];
    } else {
        self.instagramView.frame =  CGRectMake(0, 5, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height);
        _instagramViewController.frame = CGRectMake(0, 40, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height-50);
        
        for (UIView *view in self.instagramView.subviews) {
            if (view.tag==12) {
                view.hidden=YES;
            }
        }
        
        if (_bloomYes==NO) {
            self.instagramView.hidden = YES;
        }
    }
    
    /*TOUR*/
    
    
    
    if (self.tourView==NULL) {
        self.tourView = [[UIView alloc] initWithFrame: CGRectMake(0, 15, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height-15)];
    
        _tourView.hidden = YES;
    
        
        
        _tour = [[APPViewController alloc] initWithNibName:@"APPViewController" bundle:nil];

        
        //_tour =  [ self.storyboard instantiateViewControllerWithIdentifier:@"statsViewController"];

        _tourViewController = [[UIView alloc] initWithFrame: CGRectMake(5, 40, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height-40)];
    
        [self addChildController:_tour toView:_tourViewController];
    
        [self.tourView  addSubview:_tourViewController];
        
    } else {
        
        
        for (UIView *view in self.tourView.subviews) {
            if (view.tag==12) {
                view.hidden=YES;
            }
        }
        
        self.tourView.frame =  CGRectMake(0, 15, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height-15);
        _tourViewController.frame =CGRectMake(0, 40, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height-40);
        if (_bloomYes==NO) {
            self.tourView.hidden = YES;
        }
    }
    
    
    
    /*TICKET*/
    
    
    
    if (self.ticketView==NULL) {
        self.ticketView = [[UIView alloc] initWithFrame: CGRectMake(0, 15, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height-15)];
        
        _ticketView.hidden = YES;
        
        
        
        _ticketController = [self.storyboard instantiateViewControllerWithIdentifier:@"tourTableViewController"];
        
        _ticketViewController = [[UIView alloc] initWithFrame: CGRectMake(5, 40, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height-55)];
        
        [self addChildController:_ticketController toView:_ticketViewController];
        
        [self.ticketView  addSubview:_ticketViewController];
        
    } else {
        
        
        for (UIView *view in self.ticketView.subviews) {
            if (view.tag==12) {
                view.hidden=YES;
            }
        }
        
        self.ticketView.frame =  CGRectMake(0, 15, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height-15);
        _ticketViewController.frame =CGRectMake(0, 40, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height-55);
        if (_bloomYes==NO) {
            self.ticketView.hidden = YES;
        }
    }
    
    /*MERCH*/
    
    
    if (self.merchView==NULL) {
        self.merchView = [[UIView alloc] initWithFrame: CGRectMake(0, 5, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height)];
    
        _merchView.hidden = YES;
    
       _merchViewController = [[UIView alloc] initWithFrame: CGRectMake(0, 40, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height)];
    
      _merch = [self.storyboard instantiateViewControllerWithIdentifier:@"betNavigationController"];

        [self addChildController:_merch toView:_merchViewController];
    
        [self.merchView  addSubview:_merchViewController];
    
    } else {
        
        for (UIView *view in self.merchView.subviews) {
            if (view.tag==12) {
                view.hidden=YES;
            }
        }
        
        self.merchView.frame =CGRectMake(0, 5, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height);
        _merchViewController.frame =  CGRectMake(0, 40, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height);
        if (_bloomYes==NO) {
            self.merchView.hidden = YES;
        }
    }
    
    
    
    /*MERCH TABLE*/
    
    
    if (self.merchTableView==NULL) {
        self.merchTableView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height)];
        
        _merchTableView.hidden = YES;
        
        _merchTableViewController = [[UIView alloc] initWithFrame: CGRectMake(0, 40, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height-40)];
    
        
        _merchTable = [self.storyboard instantiateViewControllerWithIdentifier:@"merchNavigationController"];
        
        [self addChildController:_merchTable toView:_merchTableViewController];
        
        [self.merchTableView  addSubview:_merchTableViewController];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setColorClear12" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setColorClear22" object:nil];
    } else {
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setColorClear12" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setColorClear22" object:nil];
        
        for (UIView *view in self.merchTableView.subviews) {
            if (view.tag==12) {
                view.hidden=YES;
            }
        }
        
        self.merchTableView.frame =CGRectMake(0, 0, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height);
        _merchTableViewController.frame =  CGRectMake(0, 40, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height-40);
    
        if (_bloomYes==NO) {
            self.merchTableView.hidden = YES;
        }
    }
    
    /*MAP*/
    
    BOOL mapHidden;
    if (self.mapView!=NULL) {
        mapHidden = self.mapView.isHidden;
    } else {
        mapHidden=YES;
    }
    
    
    
    self.mapView = [[UIView alloc] initWithFrame: CGRectMake(0, 5, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height)];
    
    _mapView.hidden = mapHidden;
   
    
    //65 - 90
    
    UIView *mapViewController = [[UIView alloc] initWithFrame: CGRectMake(0, 80, ((self.view.bounds.size.width*45)/100), self.view.bounds.size.height-50)];
    
    _mapController = [[MapViewController alloc] init];
    
    _listController = [self.storyboard instantiateViewControllerWithIdentifier:@"mapTableViewController"];
    
    [_listController.view setHidden:YES];
    
    [self addChildController:_mapController toView:mapViewController];
    [self addChildController:_listController toView:mapViewController];
    
    [self.mapView  addSubview:mapViewController];
    
    _showMap = YES;
    _showList = NO;
    
    
    UIView *buttonsView = [[UIView alloc] initWithFrame:CGRectMake(60, 45, ((self.view.bounds.size.width*45)/100)-120, 30)];
    
    
    [buttonsView.layer setCornerRadius:15.0f];
    buttonsView.layer.borderColor = [UIColor whiteColor].CGColor;
    buttonsView.layer.borderWidth = 1.0f;
    [buttonsView.layer setMasksToBounds:YES];
    
    
    [_mapView addSubview:buttonsView];
    
    /*Map menu*/
    UIButton *buttonMap = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonMap addTarget:self
                  action:@selector(switchMapMenu:)
        forControlEvents:UIControlEventTouchUpInside];
    [buttonMap.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [buttonMap setTitle:@"GLOBE" forState:UIControlStateNormal];
    [buttonMap setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonMap.frame = CGRectMake(0, 0,  (((self.view.bounds.size.width*45)/100)-120)/2.0, 30.0);
    
    buttonMap.tag = 1;
    
    _buttonMap = buttonMap;
    
    _buttonMap.backgroundColor = [UIColor whiteColor];
    
    
    [_buttonMap  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [buttonsView addSubview:_buttonMap];
    
    
    UIButton *buttonList = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonList addTarget:self
                   action:@selector(switchMapMenu:)
         forControlEvents:UIControlEventTouchUpInside];
    [buttonList.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [buttonList setTitle:@"LIST" forState:UIControlStateNormal];
    [buttonList setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonList.frame = CGRectMake((((self.view.bounds.size.width*45)/100)-120)/2.0, 0,  (((self.view.bounds.size.width*45)/100)-120)/2.0, 30.0);
    
    buttonList.tag = 2;
    
    
    _buttonList= buttonList;
    
    
    [buttonsView addSubview:_buttonList];
    
    
    [self.view addSubview:_overlay];
    
    [self.view addSubview:_viewAds];
    
    [self.view addSubview:_twitterView];
    
    [self.view addSubview:_instagramView];
    
    
    [self.view addSubview:_tourView];
    
    [self.view addSubview:_merchView];
    
    [self.view addSubview:_mapView];
    
    [self.view addSubview:_merchTableView];
    
    
    [self.view addSubview:_ticketView];
    
    if (_bloomYes==NO) {
        self.mapView.hidden = YES;
    }
    
    
    //CHAT
    
    
    BOOL chatHidden;
    if (self.chatView!=NULL) {
        chatHidden = self.chatView.isHidden;
    } else {
        chatHidden = YES;
    }

  if (self.chat == nil) {
    CGFloat w = self.view.bounds.size.width * 0.45;
    CGFloat h = 30;

    AdTopBar *top = [[NSBundle mainBundle] loadNibNamed:@"AdTopBar" owner:self options:nil][0];
    top.leftImage.image = [UIImage imageNamed:@"menu-chat.png"];
    top.rightImage.image = [UIImage imageNamed:@"honeywell.png"];
    top.frame = CGRectMake(0, 0, w, h);

    self.chatView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, w, self.view.bounds.size.height)];

    UIView *chatViewController = [[UIView alloc] initWithFrame: CGRectMake(0, h, w, self.view.bounds.size.height - h)];
    UIStoryboard *chat;
    self.chatView.hidden = chatHidden;
    chat = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    self.chat = [chat instantiateViewControllerWithIdentifier:@"chatRoomViewController"];
    [self addChildController:self.chat toView: chatViewController];

    [self.chatView addSubview:top];
    [self.chatView  addSubview: chatViewController];

    if (!_bloomYes) {
      self.chatView.hidden = YES;
    }

    [self.view addSubview:self.chatView];
  }
    //add player to controllers
    _chat.player = _player;
    _twitter.player = _player;
    //_ticketController.player = _player;
    
    //Add buttons to crowdsurfing
    UIImage *imageAlpha = [[UIImage imageNamed:@"Whhite_swirl"] imageWithAlpha];
    
    
    
    _mainBtn = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"Whhite_swirl"] highlightedImage:imageAlpha];
    
    DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-placebutton"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    DCPathItemButton *itemButton_4 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    DCPathItemButton *itemButton_5 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    DCPathItemButton *itemButton_6 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    DCPathItemButton *itemButton_7 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    
    
    
    
    _mainBtn.delegate = self;
     _mainBtn.dcButtonCenter = CGPointMake(self.view.bounds.size.width-45, self.view.bounds.size.height-38);
    _mainBtn.bloomRadius = 115.0f;
    
    _mainBtn.bloomAngel = 320.0f;
    
    _mainBtn.allowSounds = NO;
    _mainBtn.allowCenterButtonRotation = YES;
    
    [_mainBtn addPathItems:@[itemButton_1,
                             itemButton_2,
                             itemButton_3,
                             itemButton_4,
                             itemButton_5,
                             itemButton_6,
                             itemButton_7
                             ]];
    
    
    UIView *bottomOverlay = [[UIView alloc] init];
    
    bottomOverlay.frame = _mainBtn.bottomView.frame;
    
    bottomOverlay.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu:) ];
    
    tapGesture.numberOfTapsRequired = 1;
    
    
    [_mainBtn.bottomView addSubview:bottomOverlay];
    
    [bottomOverlay addGestureRecognizer:tapGesture];
    
    SMWheelControl *wheel = [[SMWheelControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-60-125, self.view.bounds.size.height-53-115, 300,  300)];
    
    [wheel addTarget:self action:@selector(wheelDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    
    wheel.delegate = self;
    wheel.dataSource = self;
    [wheel reloadData];
    
    self.wheel = wheel;
    
    [self.wheel setSelectedIndex:7];
    [_mainBtn.bottomView addSubview:wheel];

//    [self.view addSubview:_mainBtn];

    [self.wheel setHidden:YES];
    
    
    for (UIView *view in self.merchView.subviews) {
        if (view.tag==1123) {
            view.frame = CGRectMake(5, 5,  65.0, 22.0);
        }
    }
    
    self.merchView.backgroundColor = [UIColor clearColor];
	
	[self initAdParams];
	[self startAd];
}


- (void) ShowPortrait {
    
    
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //1280x720 - 16*9
    
    _isPortrate = YES;
    [_mainBtn removeFromSuperview];
    [_wheel removeFromSuperview];
    [_overlay removeFromSuperview];
    [_viewAds removeFromSuperview];
    [_twitterView removeFromSuperview];
    [_instagramView removeFromSuperview];
    [_tourView removeFromSuperview];
    [_merchView removeFromSuperview];
    [_merchTableView removeFromSuperview];
    [_mapView removeFromSuperview];
    [_chatView removeFromSuperview];
    [_defaultImage removeFromSuperview];
    
    [_ticketView removeFromSuperview];
    
    
    self.overlay.hidden = YES;
    
    
    
    self.defaultImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.player.view.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height)];
        [self.defaultImage setImage:[UIImage imageNamed:@"default"]];
    self.defaultImage.contentMode = UIViewContentModeCenter;
    
    [self.view addSubview:self.defaultImage];
    
    
    
    self.defaultImage.hidden=_bloomYes;
    
    
    /*TWITTER*/
    
    
    if (self.twitterView==NULL) {
      CGFloat w = self.view.bounds.size.width * 0.45;
      CGFloat h = 30;

      AdTopBar *top = [[NSBundle mainBundle] loadNibNamed:@"AdTopBar" owner:self options:nil][0];
      top.leftImage.image = [UIImage imageNamed:@"twitter-white.png"];
      top.rightImage.image = [UIImage imageNamed:@"honeywell.png"];
      top.frame = CGRectMake(0, 0, w, h);

      self.twitterView = [[UITwitterView alloc] initWithFrame: CGRectMake(0, self.player.view.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height)];
    
        self.twitterView.hidden = YES;
        
        _twitterViewController = [[UIView alloc] initWithFrame: CGRectMake(0, h, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height-h)];
        
        _twitter = [[TwitterViewController alloc] init];
        
        
        [self addChildController:_twitter toView:_twitterViewController];
        
        [self.twitterView  addSubview:_twitterViewController];
        
       
        UIButton *downButton = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-42, 8,  25.0, 25.0)];
        [downButton setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
        downButton.contentMode = UIViewContentModeCenter;
        [downButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        downButton.tag=12;
        [self.twitterView addSubview:downButton];
        
    } else {
        self.twitterView.frame = CGRectMake(0, self.player.view.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height);
        _twitterViewController.frame = CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height-90);
        
        if (_bloomYes==NO) {
            self.twitterView.hidden = YES;
        }
        
        
        BOOL isSet = NO;
        for (UIView *view in self.twitterView.subviews) {
            if (view.tag==12) {
                view.hidden=NO;
                isSet = YES;
            }
        }
        
        if (isSet==NO) {
           UIButton *downButton = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-42, 8,  25.0, 25.0)];
            [downButton setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
            downButton.contentMode = UIViewContentModeCenter;
            [downButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
            downButton.tag=12;
            [self.twitterView addSubview:downButton];
        }
    }
    
   
    
    
    
    if (self.viewAds==NULL) {
    
        self.viewAds = [[UIAdView alloc] init];
    
        [self.viewAds.mainView  setFrame:CGRectMake(0, self.player.view.frame.size.height-2, self.view.bounds.size.width, 40)];
    
    
        self.viewAds.titleLabel.text = [@"Twitter" uppercaseString];
    
        self.viewAds.presentedLabel.text = [self.viewAds.presentedLabel.text uppercaseString];
    
        self.viewAds.hidden = YES;
    
        self.viewAds.mainView.backgroundColor =  [UIColor colorWithCSS:@"1c1e20"];
        self.viewAds.mainView.alpha = 1.0;
    } else {
        self.viewAds.mainView.frame = CGRectMake(0, self.player.view.frame.size.height-2, self.view.bounds.size.width, 40);
        if (_bloomYes==NO) {
            self.viewAds.hidden = YES;
        }
        
        self.viewAds.mainView.backgroundColor =  [UIColor colorWithCSS:@"1c1e20"];
    }
    
    
    [self.view addSubview:_viewAds];
    
 
    
    //INSTRAGRAM
    
    
    
    if (self.instagramView==NULL) {
    
        self.instagramView = [[UIInstagramView alloc] initWithFrame:  CGRectMake(0, self.player.view.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height)];
        
         self.instagramView.hidden = YES;
        
        _instagramViewController = [[UIView alloc] initWithFrame: CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height-90)];
        
        
        
        
        _instagram = [ self.storyboard instantiateViewControllerWithIdentifier:@"IKCollectionViewController1"];
        
        _instagram.view.backgroundColor = [UIColor clearColor];
        
        [self addChildController:_instagram toView:_instagramViewController];
    
        [self.instagramView  addSubview:_instagramViewController];
        
        UIButton *downButton = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-42, 8,  25.0, 25.0)];
        [downButton setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
        downButton.contentMode = UIViewContentModeCenter;
        [downButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        downButton.tag=12;
        [self.instagramView  addSubview:downButton];
    } else {
        self.instagramView.frame =  CGRectMake(0, self.player.view.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height);
        _instagramViewController.frame = CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height-90);
        
        BOOL isSet = NO;
        for (UIView *view in self.instagramView.subviews) {
            if (view.tag==12) {
                view.hidden=NO;
                isSet = YES;
            }
        }
        
        if (isSet==NO) {
            UIButton *downButton = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-42, 8,  25.0, 25.0)];
            [downButton setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
            downButton.contentMode = UIViewContentModeCenter;
            [downButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
            downButton.tag=12;
            [self.instagramView addSubview:downButton];
        }
        
        if (_bloomYes==NO) {
            self.instagramView.hidden = YES;
        }
    }
    
    
    
    /*TOUR*/
    
    
    
    if (self.tourView==NULL) {
        self.tourView = [[UIView alloc] initWithFrame:CGRectMake(0, self.player.view.frame.size.height+10, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height-50)];
    
        _tourView.hidden = YES;
        
        
        
       _tour = [[APPViewController alloc] initWithNibName:@"APPViewController" bundle:nil];
        
        
        _tourViewController = [[UIView alloc] initWithFrame: CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height-40)];
        
        [self addChildController:_tour toView:_tourViewController];
        
        [self.tourView  addSubview:_tourViewController];
        
       UIButton *downButton = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-42, 0,  25.0, 25.0)];
        [downButton setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
        downButton.contentMode = UIViewContentModeCenter;
        [downButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        downButton.tag=12;
        [self.tourView  addSubview:downButton];
        
        
    } else {
        self.tourView.frame =  CGRectMake(0, self.player.view.frame.size.height+10, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height-40);
        _tourViewController.frame = CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height-50);
        
        BOOL isSet = NO;
        for (UIView *view in self.tourView.subviews) {
            if (view.tag==12) {
                view.hidden=NO;
                isSet = YES;
            }
        }
        
        if (isSet==NO) {
           UIButton *downButton = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-42, 0,  25.0, 25.0)];
            [downButton setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
            downButton.contentMode = UIViewContentModeCenter;
            [downButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
            downButton.tag=12;
            [self.tourView addSubview:downButton];
        }
        
        if (_bloomYes==NO) {
            self.tourView.hidden = YES;
        }
    }
    
    
    
    /*TICKET*/
    
    
    
    if (self.ticketView==NULL) {
        self.ticketView = [[UIView alloc] initWithFrame:CGRectMake(0, self.player.view.frame.size.height+10, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height-50)];
        
        _ticketView.hidden = YES;
        _ticketController = [self.storyboard instantiateViewControllerWithIdentifier:@"tourTableViewController"];
        _ticketViewController = [[UIView alloc] initWithFrame: CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height-50)];
        
        [self addChildController:_ticketController toView:_ticketViewController];
        
        [self.ticketView  addSubview:_ticketViewController];
        
        UIButton *downButton = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-42, 0,  25.0, 25.0)];
        [downButton setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
        downButton.contentMode = UIViewContentModeCenter;
        [downButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        downButton.tag=12;
        [self.tourView  addSubview:downButton];
        
        
    } else {
        self.ticketView.frame =  CGRectMake(0, self.player.view.frame.size.height+10, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height-50);
        _ticketViewController.frame = CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height-50);
        
        BOOL isSet = NO;
        for (UIView *view in self.ticketView.subviews) {
            if (view.tag==12) {
                view.hidden=NO;
                isSet = YES;
            }
        }
        
        if (isSet==NO) {
            UIButton *downButton = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-42, 0,  25.0, 25.0)];
            [downButton setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
            downButton.contentMode = UIViewContentModeCenter;
            [downButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
            downButton.tag=12;
            [self.ticketView addSubview:downButton];
        }
        
        if (_bloomYes==NO) {
            self.ticketView.hidden = YES;
        }
    }
  
    
    /*MERCH*/
    
    
    if (self.merchView==NULL) {
        self.merchView = [[UIView alloc] initWithFrame:CGRectMake(0, self.player.view.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height)];
    
        _merchView.hidden = YES;
        
        _merchViewController = [[UIView alloc] initWithFrame: CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height-40)];
        
        _merch= [self.storyboard instantiateViewControllerWithIdentifier:@"betNavigationController"];
        
        [self addChildController:_merch toView:_merchViewController];
        
        [self.merchView  addSubview:_merchViewController];
        
        UIButton *downButton = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-42, 8,  25.0, 25.0)];
        [downButton setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
        downButton.contentMode = UIViewContentModeCenter;
        [downButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        downButton.tag=12;
        [self.merchView  addSubview:downButton];
        
        
        [self.viewAds.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        self.merchView.frame = CGRectMake(0, self.player.view.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height);
        _merchViewController.frame = CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height-40);
        
        
        BOOL isSet = NO;
        for (UIView *view in self.merchView.subviews) {
            if (view.tag==12) {
                view.hidden=NO;
                isSet = YES;
            }
        }
        
        if (isSet==NO) {
            UIButton *downButton = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-42, 8,  25.0, 25.0)];
            [downButton setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
            downButton.contentMode = UIViewContentModeCenter;
            [downButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
            downButton.tag=12;
            [self.merchView addSubview:downButton];
        }
        
        if (_bloomYes==NO) {
            self.merchView.hidden = YES;
        }
    }
    
    
    if (self.merchTableView==NULL) {
        
        self.merchTableView = [[UIView alloc] initWithFrame:CGRectMake(0, self.player.view.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height)];
        
        _merchTableView.hidden = YES;
       
        _merchTableViewController = [[UIView alloc] initWithFrame: CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height-40)];
        
        _merchTable = [self.storyboard instantiateViewControllerWithIdentifier:@"merchNavigationController"];
        
       
        [self addChildController:_merchTable toView:_merchTableViewController];
        
        [self.merchTableView  addSubview:_merchTableViewController];
    
        UIButton *downButton = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-42, 8,  25.0, 25.0)];
        [downButton setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
        downButton.contentMode = UIViewContentModeCenter;
        [downButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        downButton.tag=12;
        [self.merchTableView  addSubview:downButton];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setColorClear11" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setColorClear21" object:nil];
        
    } else {
        
        self.merchTableView.frame = CGRectMake(0, self.player.view.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height);
        _merchTableViewController.frame = CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height-40);
        

        BOOL isSet = NO;
        for (UIView *view in self.merchTableView.subviews) {
            if (view.tag==12) {
                view.hidden=NO;
                isSet = YES;
            }
        }
        
        
        
        if (isSet==NO) {
            UIButton *downButton = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-42, 8,  25.0, 25.0)];
            [downButton setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
            downButton.contentMode = UIViewContentModeCenter;
            [downButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
            downButton.tag=12;
            [self.merchTableView addSubview:downButton];
        }
        
        if (_bloomYes==NO) {
            self.merchTableView.hidden = YES;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setColorClear11" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setColorClear21" object:nil];

    }

    
    /*MAP*/
    
    BOOL mapHidden;
    if (self.mapView!=NULL) {
        mapHidden = self.mapView.isHidden;
    } else {
        mapHidden = YES;
    }
    self.mapView = [[UIView alloc] initWithFrame: CGRectMake(0, self.player.view.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height)];
    _mapView.hidden = mapHidden;
    
    //65 - 90
    
    UIView *mapViewController = [[UIView alloc] initWithFrame: CGRectMake(0, 80, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height-90)];
    
    _mapController = [[MapViewController alloc] init];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateOrientation" object:nil];
    
    _listController = [self.storyboard instantiateViewControllerWithIdentifier:@"mapTableViewController"];
    
    [_listController.view setHidden:YES];
    
    [self addChildController:_mapController toView:mapViewController];
    [self addChildController:_listController toView:mapViewController];
    
    [self.mapView  addSubview:mapViewController];
    
    _showMap = YES;
    _showList = NO;
    
    
    
    UIView *buttonsView = [[UIView alloc] init];
    buttonsView.center = self.view.center;
    
    buttonsView = [[UIView alloc] initWithFrame:CGRectMake(buttonsView.frame.origin.x-(((self.view.bounds.size.width*45)/100))/2.0, 50, ((self.view.bounds.size.width*45)/100), 30)];

    [buttonsView.layer setCornerRadius:15.0f];
    buttonsView.layer.borderColor = [UIColor whiteColor].CGColor;
    buttonsView.layer.borderWidth = 1.0f;
    [buttonsView.layer setMasksToBounds:YES];
    
    
    [_mapView addSubview:buttonsView];
    
    /*Map menu*/
    UIButton *buttonMap = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonMap addTarget:self
                  action:@selector(switchMapMenu:)
        forControlEvents:UIControlEventTouchUpInside];
    [buttonMap.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [buttonMap setTitle:@"GLOBE" forState:UIControlStateNormal];
    [buttonMap setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonMap.frame = CGRectMake(0, 0,  (((self.view.bounds.size.width*45)/100))/2.0, 30.0);
    
    buttonMap.tag = 1;
    
    _buttonMap = buttonMap;
    
    _buttonMap.backgroundColor = [UIColor whiteColor];
    
    
    [_buttonMap  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [buttonsView addSubview:_buttonMap];
    
    
    UIButton *buttonList = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonList addTarget:self
                   action:@selector(switchMapMenu:)
         forControlEvents:UIControlEventTouchUpInside];
    [buttonList.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [buttonList setTitle:@"LIST" forState:UIControlStateNormal];
    [buttonList setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonList.frame = CGRectMake((((self.view.bounds.size.width*45)/100))/2.0, 0,  (((self.view.bounds.size.width*45)/100))/2.0, 30.0);
    
    buttonList.tag = 2;
    
    
    _buttonList= buttonList;
    
    
    [buttonsView addSubview:_buttonList];
    
    if (_bloomYes==NO) {
        self.mapView.hidden = YES;
    }
    
    UIButton *downButton = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-42, 8,  25.0, 25.0)];
    [downButton setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
    downButton.contentMode = UIViewContentModeCenter;
    [downButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    downButton.tag=12;
    [self.mapView addSubview:downButton];
    

    //CHAT
    
    
    BOOL chatHidden;
    if (self.chatView!=NULL) {
        chatHidden = self.chatView.isHidden;
    } else {
        chatHidden = YES;
    }
    
  if (self.chat == nil) {
    self.chatView= [[UIView alloc] initWithFrame: CGRectMake(0, self.player.view.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height)];
    
    self.chatView.hidden = chatHidden;
    
    UIView *chatViewController = [[UIView alloc] initWithFrame: CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height-40)];
    
    UIStoryboard *chat = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    self.chat = [chat instantiateViewControllerWithIdentifier:@"chatRoomViewController"];
    [self addChildController:self.chat toView:chatViewController];

    [self.chatView  addSubview:chatViewController];
        
    UIButton *downButton1 = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-42, 8,  25.0, 25.0)];
    [downButton1 setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
    downButton1.contentMode = UIViewContentModeCenter;
    [downButton1 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    downButton1.tag=12;
    [self.chatView addSubview:downButton1];
    
    if (!_bloomYes) {
        self.chatView.hidden = YES;
    }
  }
    UIView *overlay = [[UIView alloc] initWithFrame:self.chatView.frame];
    
    overlay.backgroundColor = [UIColor blackColor];
    
    overlay.alpha = 0.4f;
    
    self.overlay= overlay;
    [self.view addSubview:self.overlay];
    
    [self.view addSubview:_viewAds];
    
    [self.view addSubview:_twitterView];
    
    [self.view addSubview:_instagramView];

    
    [self.view addSubview:_tourView];
    
    [self.view addSubview:_merchView];
    
    
     [self.view addSubview:_merchTableView];
    
    [self.view addSubview:_mapView];
    
    [self.view addSubview:_chatView];
    
    [self.view addSubview:_ticketView];
    
    self.overlay.hidden = YES;
    //add player to controllers
    _chat.player = _player;
    _twitter.player = _player;

    
    //Add buttons to crowdsurfing
    UIImage *imageAlpha = [[UIImage imageNamed:@"Whhite_swirl"] imageWithAlpha];
    
    
    
    _mainBtn = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"Whhite_swirl"] highlightedImage:imageAlpha];

    
    DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-placebutton"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    DCPathItemButton *itemButton_4 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    DCPathItemButton *itemButton_5 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    DCPathItemButton *itemButton_6 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    
    DCPathItemButton *itemButton_7 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"button"]
                                                           highlightedImage:[UIImage imageNamed:@"button"]
                                                            backgroundImage:[UIImage imageNamed:@"button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"button"]];
    

    

    
    
    
    
    _mainBtn.delegate = self;
    _mainBtn.dcButtonCenter =  _mainBtn.dcButtonCenter = CGPointMake(self.view.bounds.size.width/2.0
                                                                     , self.view.bounds.size.height-38);
    _mainBtn.bloomRadius = 115.0f;
    
    _mainBtn.bloomAngel = 300.0f;
    
    _mainBtn.allowSounds = NO;
    _mainBtn.allowCenterButtonRotation = YES;
    
    
    if (_bloomYes==YES) {
        _mainBtn.hidden = YES;
    }
    
    [_mainBtn addPathItems:@[itemButton_1,
                             itemButton_2,
                             itemButton_3,
                             itemButton_4,
                             itemButton_5,
                             itemButton_6,
                             itemButton_7
                             ]];
    
    
    UIView *bottomOverlay = [[UIView alloc] init];
    
    bottomOverlay.frame = _mainBtn.bottomView.frame;
    
    bottomOverlay.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMenuHideGesture:) ];
    
    tapGesture.numberOfTapsRequired = 1;
    

    [_mainBtn.bottomView addSubview:bottomOverlay];
    
    bottomOverlay.tag = 122;
    [bottomOverlay addGestureRecognizer:tapGesture];
    
    SMWheelControl *wheel = [[SMWheelControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-30-125, self.view.bounds.size.height-53-115, 300,  300)];
    
    
    
    //SMWheelControl *wheel = [[SMWheelControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-60-125, self.view.bounds.size.height-53-115, 300,  300)];;
    
    [wheel addTarget:self action:@selector(wheelDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    
    wheel.delegate = self;
    wheel.dataSource = self;
    [wheel reloadData];
    
    self.wheel = wheel;
    
    [self.wheel setSelectedIndex:7];
    [_mainBtn.bottomView addSubview:wheel];
//    [self.view addSubview:_mainBtn];

    [self.wheel setHidden:YES];
    
    
    for (UIView *view in self.merchView.subviews) {
        if (view.tag==1123) {
            view.frame = CGRectMake(5, 8,  65.0, 22.0);
        }
    }
    
    if (_isSuccessW == YES) {
        self.merchView.backgroundColor = [UIColor colorWithRed:109.0/255.0 green:182.0/255.0 blue:29.0/255.0 alpha:1.0];
        self.merchView.alpha = 1.0;
    }
	
	[self hideAndStopAdWithAnimation:NO];
    
}


- (void) btnDownTapped:(id) sender {
    NSLog(@"button tapped");
}

- (void)deviceOrientationChanged:(NSNotification *)notification
{
    [self deviceForDeviceOrientation:[UIDevice currentDevice].orientation];
}

- (void) deviceForDeviceOrientation:(UIDeviceOrientation)orientation
{

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KeyboardHide" object:nil];
    
    switch (orientation)
    {
        case UIDeviceOrientationPortrait:
            self.player.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.width*9/16);
            [self ShowPortrait];
           
            
            break;
        case UIDeviceOrientationPortraitUpsideDown:
           
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            self.player.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
           
            [self ShowLandscape];
           
            
                      break;
        case UIDeviceOrientationLandscapeRight:
            self.player.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            [self ShowLandscape];
           
           
            break;
            
        case UIDeviceOrientationFaceUp:
            
           
            break;
        case UIDeviceOrientationFaceDown:
           
            break;
        case UIDeviceOrientationUnknown:
    
            break;
    }
}



-(void) resignResponder:(id)sender {
    
    NSLog(@"resign");
    [self.view endEditing:YES];
}

-(void) switchMapMenu:(UIButton *) sender {
    
    if (sender.tag==2) {
    
        if (_showMap==YES) {
            [_listController.view setHidden:NO];
            [_mapController.view setHidden:YES];
            _showMap = NO;
            _showList = YES;
        
            _buttonMap.backgroundColor = [UIColor clearColor];
            [_buttonMap  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            _buttonList.backgroundColor = [UIColor whiteColor];
            [_buttonList  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }
    }
    
    if (sender.tag==1) {
        
        if (_showList==YES) {
            [_listController.view setHidden:YES];
            [_mapController.view setHidden:NO];
            _showMap = YES;
            _showList = NO;
            
            _buttonList.backgroundColor = [UIColor clearColor];
            [_buttonList  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            _buttonMap.backgroundColor = [UIColor whiteColor];
            [_buttonMap  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];        }
    }
}



- (void) showMenu:(id)sender {
    
    
    //self.player.avPlayer.rate = -1.5;
    NSLog(@"rate player %f", self.player.avPlayer.rate);
    
   BOOL keyboardIsShowing = ((AppDelegate*)[UIApplication sharedApplication].delegate).keyboardIsShowing;
    
    
    if (keyboardIsShowing==YES) {
        [self.view endEditing:YES];
    }  else {
        
       
        _mainBtn.hidden = NO;
        
        
        if (_isPortrate==YES) {
            _defaultImage.hidden = NO;
        }
        __weak id weakSelf = self.wheel;
        [weakSelf setRotation:360 duration:0.5f finished:^{
            if (_isPortrate==YES) {
                [_mainBtn pathCenterButtonBloom];
            } else {
                [_mainBtn pathCenterButtonFold];
            }
        }];
        
        _bloomYes = NO;
    
        
     
        self.overlay.hidden = YES;
        
         self.viewAds.hidden = YES;
        
        [self.twitterView expandIntoView:NULL finished:NULL];
        [self.instagramView expandIntoView:NULL finished:NULL];
        [self.chatView expandIntoView:NULL finished:NULL];
        [self.tourView expandIntoView:NULL finished:NULL];
        [self.merchView expandIntoView:NULL finished:NULL];
        [self.merchTableView expandIntoView:NULL finished:NULL];
        [self.mapView expandIntoView:NULL finished:NULL];
        [self.ticketView expandIntoView:NULL finished:NULL];
      [self.regView expandIntoView:NULL finished:NULL];
      [self.storeView expandIntoView:NULL finished:NULL];

        
        if (_isPortrate!=YES) {
            
            self.twitterView.hidden = YES;
            self.instagramView.hidden = YES;
            self.chatView.hidden = YES;
            self.tourView.hidden = YES;
            self.mapView.hidden = YES;
            self.merchView.hidden = YES;
            self.merchTableView.hidden = YES;
            self.ticketView.hidden = YES;
            
        }
        
        
    }
}


- (void) showMenuHideGesture:(id)sender {
    
    _bloomYes = NO;
    self.overlay.hidden = YES;
   
    
    self.overlay.hidden = YES;
    
    __weak id weakSelf = self.wheel;
    [weakSelf setRotation:360 duration:0.5f finished:^{
        
        [_mainBtn pathCenterButtonFold];
        
    }];
    
    if (_isPortrate!=YES) {
      
        [self.twitterView expandIntoView:NULL finished:NULL];
        [self.instagramView expandIntoView:NULL finished:NULL];
        [self.chatView expandIntoView:NULL finished:NULL];
        [self.tourView expandIntoView:NULL finished:NULL];
        [self.merchView expandIntoView:NULL finished:NULL];
        [self.ticketView expandIntoView:NULL finished:NULL];
      [self.regView expandIntoView:NULL finished:NULL];
      [self.storeView expandIntoView:NULL finished:NULL];
        [self.mapView expandIntoView:NULL finished:NULL];
        self.viewAds.hidden = YES;
        self.viewAds.hidden = YES;
        self.twitterView.hidden = YES;
        self.instagramView.hidden = YES;
        self.chatView.hidden = YES;
        self.tourView.hidden = YES;
        self.mapView.hidden = YES;
        self.merchView.hidden = YES;
        self.merchTableView.hidden = YES;
        self.ticketView.hidden = YES;
    }
    
}

- (void) showMenuHide:(id)sender {
    
    self.overlay.hidden = YES;
    self.viewAds.hidden = YES;
    
    self.overlay.hidden = YES;
    
    _bloomYes = NO;
    
    _mainBtn.hidden = NO;
    
    
    if (_isPortrate==YES) {
        _defaultImage.hidden = NO;
    }
    

    
    [self.twitterView expandIntoView:NULL finished:NULL];
    [self.instagramView expandIntoView:NULL finished:NULL];
    [self.chatView expandIntoView:NULL finished:NULL];
    [self.tourView expandIntoView:NULL finished:NULL];
    [self.merchView expandIntoView:NULL finished:NULL];
    [self.mapView expandIntoView:NULL finished:NULL];
    [self.ticketView expandIntoView:NULL finished:NULL];
  [self.regView expandIntoView:NULL finished:NULL];
  [self.storeView expandIntoView:NULL finished:NULL];
    if (_isPortrate!=YES) {
        self.viewAds.hidden = YES;
        self.twitterView.hidden = YES;
        self.instagramView.hidden = YES;
        self.chatView.hidden = YES;
        self.tourView.hidden = YES;
        self.mapView.hidden = YES;
        self.merchView.hidden = YES;
        self.merchTableView.hidden = YES;
        self.ticketView.hidden = YES;
    }
}






-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {

}

- (void)playStream:(NSURL*)url {
    VKVideoPlayerTrack *track = [[VKVideoPlayerTrack alloc] initWithStreamURL:url];
    
    //track.hasNext = YES;
    [self.player loadVideoWithTrack:track];
}

- (void)playVideo {
    NSString *videoIdentifier = @"idmTgHmbDjE"; // A 11 characters YouTube video identifier
    [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:videoIdentifier completionHandler:^(XCDYouTubeVideo *video, NSError *error) {
        
        
        NSLog(@"log %@", error);
        if (video)
        {
            NSURL *url = [video.streamURLs objectForKey:@(XCDYouTubeVideoQualityMedium360)];
            
            NSLog(@"url %@", url);
            [self playStream:url];
        }
        else
        {
        
        }
    }];
    
    //NSString *url = @"https://dl.dropboxusercontent.com/s/ioit4eot3lew6h1/Imagine%20Dragons%20Concert.mp4?dl=0";
    //[self playStream:[NSURL URLWithString:url]];
   

}


//1280*720

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


- (void)willPresentDCPathButtonItems:(DCPathButton *)dcPathButton {
   [self.wheel setHidden:NO];
    [self.mainBtn changeCenterImage:[UIImage imageNamed:@"exit"]];
    [self.mainBtn changeCenterHighlightedImage:[UIImage imageNamed:@"exit"]];
	[self hideAndStopAdWithAnimation:YES];
}
- (void)didPresentDCPathButtonItems:(DCPathButton *)dcPathButton {
    
    for (int i = 0; i < dcPathButton.itemButtons.count; i++) {
        
        DCPathItemButton *pathItemButton = dcPathButton.itemButtons[i];
        [pathItemButton setHidden:YES];
    }
    
   [self showMenuHide:self];
    
   [self.popTip hide];
    
   [self.wheel expandIntoView:self.mainBtn.bottomView finished:NULL];
    __weak id weakSelf = self.wheel;
    [weakSelf setRotation:180 duration:1.5f finished:^{
    }];
    
    
    //UIImage *image = [[UIImage imageNamed:@"Swirl_Color"] imageWithAlpha];
    //UIImage *imageAlpha = [[UIImage imageNamed:@"Swirl_Color_h"] imageWithAlpha];
    //[_mainBtn.pathCenterButton setImage:image forState:UIControlStateNormal];
    //[_mainBtn.pathCenterButton setImage:imageAlpha forState:UIControlStateHighlighted];
    swirleWhite = NO;
}

- (void)willDismissDCPathButtonItems:(DCPathButton *)dcPathButton {
    
    [self.wheel setHidden:YES];
    
    //UIImage *image = [[UIImage imageNamed:@"Whhite_swirl"] imageWithAlpha];
    //UIImage *imageAlpha = [[UIImage imageNamed:@"Whhite_swirl_h"] imageWithAlpha];
    //[_mainBtn.pathCenterButton setImage:image forState:UIControlStateNormal];
    //[_mainBtn.pathCenterButton setImage:imageAlpha forState:UIControlStateHighlighted];
    swirleWhite = YES;
    
    for (int i = 0; i < dcPathButton.itemButtons.count; i++) {
        
        DCPathItemButton *pathItemButton = dcPathButton.itemButtons[i];
        [pathItemButton setHidden:NO];
    }
}

- (void)didDismissDCPathButtonItems:(DCPathButton *)dcPathButton {
    [self.mainBtn changeCenterImage:[UIImage imageNamed:@"Whhite_swirl"]];
    [self.mainBtn changeCenterHighlightedImage:[UIImage imageNamed:@"Whhite_swirl"]];
	[self startAd];
}

- (void)pathButton:(DCPathButton *)dcPathButton clickItemButtonAtIndex:(NSUInteger) itemButtonIndex {
    
}

#pragma mark - VKVideoPlayerControllerDelegate
- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didControlByEvent:(VKVideoPlayerControlEvent)event {
    if (_isPortrate==YES) {
        [self showMenuHideGesture:self];
    } else {
        [self showMenu:self];
    }
}

#pragma mark - Wheel delegate

- (void)wheelDidEndDecelerating:(SMWheelControl *)wheel
{
    
}

- (void)wheel:(SMWheelControl *)wheel didRotateByAngle:(CGFloat)angle
{

    for (UIView *i in _wheel.sliceContainer.subviews) {
        if([i isKindOfClass:[UIView class]]){
            UIView *view = (UIView *)i;
                for (UIView *j in view.subviews) {
                    if([j isKindOfClass:[UIImageView class]]){
                        UIImageView *image = (UIImageView *)j;
                        if (image.tag==111) {
                           
                        }
                    }
                }
        }
    }
}

#pragma mark - Wheel dataSource

- (NSUInteger)numberOfSlicesInWheel:(SMWheelControl *)wheel
{
    return 8;
}

- (UIView *)wheel:(SMWheelControl *)wheel viewForSliceAtIndex:(NSUInteger)index
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 125, 50)];
    
    UIImage *image;
    
    
    /*
     
     - swx - 0
     - twitter - 5
     - instagram - 4
     - stats - 2 or 7
     - merch - 3
     - chat - 1
     - share - 6
     */
    if (index==0) {
        
        image = [UIImage imageNamed:@"swx"];
        
        /*button*/
        UIImage *imageButton;
        imageButton = [UIImage imageNamed:@"button"];
        
        UIImageView *imageButtonView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [imageButtonView setImage:imageButton];
        
        imageButtonView.tag=23;
        imageButtonView.contentMode = UIViewContentModeScaleToFill;
        view.tag = index;
        [view addSubview:imageButtonView];
        
        /*image*/
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 16, 35, 20)];
        [imageView setImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        view.tag = index;
        [view addSubview:imageView];

        imageView.tag = 111;
        
    } else if (index==5) {
        
        image = [UIImage imageNamed:@"twitter-header"];
        
        /*button*/
        UIImage *imageButton;
        imageButton = [UIImage imageNamed:@"button"];
        
        UIImageView *imageButtonView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [imageButtonView setImage:imageButton];
        imageButtonView.contentMode = UIViewContentModeScaleToFill;
        view.tag = index;
        [view addSubview:imageButtonView];
        
        /*image*/
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
        [imageView setImage:image];
        imageView.contentMode = UIViewContentModeScaleToFill;
        view.tag = index;
        [view addSubview:imageView];
    
        imageView.tag = 111;
      
    } else if (index==4) {
        
        image = [UIImage imageNamed:@"instagram-header"];
        
        /*button*/
        UIImage *imageButton;
        imageButton = [UIImage imageNamed:@"button"];
        
        /*button*/
        UIImageView *imageButtonView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [imageButtonView setImage:imageButton];
        imageButtonView.contentMode = UIViewContentModeScaleToFill;
        view.tag = index;
        [view addSubview:imageButtonView];
        
        /*image*/
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
        [imageView setImage:image];
        imageView.contentMode = UIViewContentModeScaleToFill;
        view.tag = index;
        [view addSubview:imageView];
        
        imageView.tag = 111;
        
    } else if (index==3) {
        
       image = [UIImage imageNamed:@"merch-header"];
        
        /*button*/
        UIImage *imageButton;
        imageButton = [UIImage imageNamed:@"button"];
        
        UIImageView *imageButtonView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [imageButtonView setImage:imageButton];
        imageButtonView.contentMode = UIViewContentModeScaleToFill;
        view.tag = index;
        [view addSubview:imageButtonView];
        
        /*image*/
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
        [imageView setImage:image];
        imageView.contentMode = UIViewContentModeScaleToFill;
        view.tag = index;
        [view addSubview:imageView];
        imageView.tag = 111;
        
    } else if (index==2) {
        
        image = [UIImage imageNamed:@"stats"];
        
        /*button*/
        UIImage *imageButton;
        imageButton = [UIImage imageNamed:@"button"];
        
        /*button*/
        UIImageView *imageButtonView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [imageButtonView setImage:imageButton];
        imageButtonView.contentMode = UIViewContentModeScaleToFill;
        view.tag = index;
        [view addSubview:imageButtonView];
        
        /*image*/
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
        [imageView setImage:image];
        imageView.contentMode = UIViewContentModeScaleToFill;
        view.tag = index;
        [view addSubview:imageView];
        
        imageView.tag = 111;
    }
    
    
    else if (index==7)  {
        
        image = [UIImage imageNamed:@"ticket-header"];
        
        /*button*/
        UIImage *imageButton;
        imageButton = [UIImage imageNamed:@"button"];
        
        /*button*/
        UIImageView *imageButtonView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [imageButtonView setImage:imageButton];
        imageButtonView.contentMode = UIViewContentModeScaleToFill;
        view.tag = index;
        [view addSubview:imageButtonView];
        
        /*image*/
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
        [imageView setImage:image];
        imageView.contentMode = UIViewContentModeScaleToFill;
        view.tag = index;
        [view addSubview:imageView];
        
        imageView.tag = 111;
    }
    
    else if (index==1) {
        
        image = [UIImage imageNamed:@"chat-header"];
        
        /*button*/
        UIImage *imageButton;
        imageButton = [UIImage imageNamed:@"button"];
        
        /*button*/
        UIImageView *imageButtonView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [imageButtonView setImage:imageButton];
        imageButtonView.contentMode = UIViewContentModeScaleToFill;
        view.tag = index;
        [view addSubview:imageButtonView];
    
        /*image*/
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
        [imageView setImage:image];
        imageView.contentMode = UIViewContentModeScaleToFill;
        view.tag = index;
        [view addSubview:imageView];
        
        imageView.tag = 111;
        
    } else if (index==6) {
        
        /*button*/
        UIImage *imageButton;
        imageButton = [UIImage imageNamed:@"button"];
        
        /*button*/
        UIImageView *imageButtonView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [imageButtonView setImage:imageButton];
        imageButtonView.contentMode = UIViewContentModeScaleToFill;
        view.tag = index;
        [view addSubview:imageButtonView];
        
        image = [UIImage imageNamed:@"share-header"];
        
        /*image*/
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
        [imageView setImage:image];
        imageView.contentMode = UIViewContentModeScaleToFill;
        view.tag = index;
        [view addSubview:imageView];
        imageView.tag = 111;
        
    }
    
    return view;
}

- (void) showItem:(id) sender {
   
}
- (void)wheel:(SMWheelControl *)wheel didTapOnSliceAtIndex:(NSUInteger)index {
//
    
    
    /*
     
     - swx - 0
     - twitter - 5
     - instagram - 4
     - stats - 2 or 7
     - merch - 3
     - chat - 1
     - share - 6
     */
    
    _bloomYes = YES;
  
    if (_isPortrate==YES) {
        _mainBtn.hidden = YES;
        _defaultImage.hidden = YES;
    }
  
    self.viewAds.adlogImage.image = [UIImage imageNamed:@"MD"];
    self.viewAds.headerImage.hidden = NO;

    for (UIView *i in _wheel.sliceContainer.subviews) {
        if([i isKindOfClass:[UIView class]]){
            UIView *view = (UIView *)i;
            if(view.tag == index){
               for (UIView *j in view.subviews) {
                  if([j isKindOfClass:[UIImageView class]]){
                      UIImageView *image = (UIImageView *)j;
                      if (image.tag==111) {
                          
                            [_mainBtn pathCenterButtonFold];
                            //0-5 - tw, 11-4 instagram, chat - 8, share - 7
                        
                             if (index==0) {
                                  self.slider.hidden = YES;
                                  UIImage *image = [UIImage imageNamed:@"swx"];
                                  [self.viewAds.headerImage setImage:image];
                                  self.overlay.hidden = NO;
                                  self.viewAds.hidden = NO;
                                  self.twitterView.hidden = YES;
                                  self.instagramView.hidden = YES;
                                  self.chatView.hidden = YES;
                                  [self.merchView expandIntoView:self.view finished:NULL];
                                  self.tourView.hidden = YES;
                                  self.mapView.hidden = YES;
                                  self.merchTableView.hidden = YES;
                                  self.ticketView.hidden = YES;
                                  if (_isShowSwx == YES) {
                                      image = [UIImage imageNamed:@"swx"];
                                      self.viewAds.adlogImage.image = [UIImage imageNamed:@"swx"];
                                      self.viewAds.headerImage.hidden = YES;
                                  } else {
                                      image = [UIImage imageNamed:@"swx"];
                                      self.viewAds.adlogImage.image = [UIImage imageNamed:@"MD"];
                                      self.viewAds.headerImage.hidden = NO;
                                  }
                              }
                          
                          
                              if (index==3) {
                                  self.slider.hidden = YES;
                                  UIImage *image = [UIImage imageNamed:@"merch-header"];
                                  [self.viewAds.headerImage setImage:image];
                                  self.overlay.hidden = NO;
                                  self.viewAds.hidden = NO;
                                  self.twitterView.hidden = YES;
                                  self.instagramView.hidden = YES;
                                  self.chatView.hidden = YES;
                                  [self.merchTableView expandIntoView:self.view finished:NULL];
                                  self.tourView.hidden = YES;
                                  self.mapView.hidden = YES;
                                  self.merchView.hidden = YES;
                                  self.ticketView.hidden = YES;
                              }
                          
                              if (index==5) {
                                  self.slider.hidden = YES;
                                  UIImage *image = [UIImage imageNamed:@"twitter-header"];
                                  
                                  [self.viewAds.headerImage setImage:image];
                                  
                                  self.overlay.hidden = NO;
                                  self.viewAds.hidden = NO;
                                  
                                  [self.twitterView expandIntoView:self.view finished:NULL];
                                  
                                  self.instagramView.hidden = YES;
                                  self.chatView.hidden = YES;
                                  self.tourView.hidden = YES;
                                  self.merchView.hidden = YES;
                                  self.merchTableView.hidden = YES;
                                  self.mapView.hidden = YES;
                                  self.ticketView.hidden = YES;
                              }
                              
                            if  (index==4) {
                                  self.slider.hidden = YES;
                                  
                                  UIImage *image = [UIImage imageNamed:@"instagram-header"];
                                  [self.viewAds.headerImage setImage:image];
                                  self.overlay.hidden = NO;
                                  self.viewAds.hidden = NO;
                                  self.twitterView.hidden = YES;
                                  [self.instagramView expandIntoView:self.view finished:NULL];
                                  self.chatView.hidden = YES;
                                  self.tourView.hidden = YES;
                                  self.merchView.hidden = YES;
                                  self.merchTableView.hidden = YES;
                                  self.mapView.hidden = YES;
                                 self.ticketView.hidden = YES;
                              }
                              
                              
                              if (index==1) {
                                  self.slider.hidden = YES;
                                  UIImage *image = [UIImage imageNamed:@"chat-header"];
                                  [self.viewAds.headerImage setImage:image];
                                  self.overlay.hidden = NO;
                                  self.viewAds.hidden = NO;
                                  self.twitterView.hidden = YES;
                                  self.instagramView.hidden = YES;
                                  [self.chatView expandIntoView:self.view finished:NULL];
                                  self.tourView.hidden = YES;
                                  self.merchView.hidden = YES;
                                  self.merchTableView.hidden = YES;
                                  self.mapView.hidden = YES;
                                  self.ticketView.hidden = YES;
                              }
                          
                              if (index==6) {
                                  self.slider.hidden = YES;
                                  self.overlay.hidden = YES;
                                  self.viewAds.hidden = YES;
                                  self.twitterView.hidden = YES;
                                  self.chatView.hidden = YES;
                                  self.instagramView.hidden = YES;
                                  self.tourView.hidden = YES;
                                  self.merchView.hidden = YES;
                                  self.mapView.hidden = YES;
                                  self.merchTableView.hidden = YES;
                                  self.ticketView.hidden = YES;
                                   _mainBtn.hidden = NO;
                                  NSString *shareText = @"NFL ON CBS";
                                  
                                  NSArray *items = @[shareText];
                                  
                                  self.activity = [[UIActivityViewController alloc]
                                                                        initWithActivityItems:items
                                                                        applicationActivities:nil];
								  
							 		__weak MainViewController *weakSelf = self;
								  self.activity.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
//									  if (completed) {
										  [weakSelf.activity dismissViewControllerAnimated:YES completion:nil];
										  weakSelf.activity = nil;
										  [weakSelf startAd];
//									  }
								  };
                                  [self presentViewController:_activity animated:YES completion:nil];
                             }
                          
                             if (index==2) {
                                 self.slider.hidden = YES;
                                 UIImage *image = [UIImage imageNamed:@"stats"];
                                 [self.viewAds.headerImage setImage:image];
                                 self.overlay.hidden = NO;
                                 self.viewAds.hidden = NO;
                                 self.twitterView.hidden = YES;
                                 self.instagramView.hidden = YES;
                                 self.chatView.hidden = YES;
                                 [self.tourView expandIntoView:self.view finished:NULL];
                                 self.merchView.hidden = YES;
                                 self.mapView.hidden = YES;
                                 self.merchTableView.hidden = YES;
                                 self.ticketView.hidden = YES;
                             }
                          
                            if (index==7) {
                              self.slider.hidden = YES;
                              UIImage *image = [UIImage imageNamed:@"ticket-header"];
                              [self.viewAds.headerImage setImage:image];
                              self.overlay.hidden = NO;
                              self.viewAds.hidden = NO;
                              self.twitterView.hidden = YES;
                              self.instagramView.hidden = YES;
                              self.chatView.hidden = YES;
                              self.merchView.hidden = YES;
                              self.mapView.hidden = YES;
                              self.merchTableView.hidden = YES;
                              self.tourView.hidden = YES;
                             [self.ticketView expandIntoView:self.view finished:NULL];
                          }
                        }
                   }
               }
                /// Write your code
            }
        }
    }
	[self hideAndStopAdWithAnimation:YES];
}


- (void)activityDidFinish:(BOOL)completed{
    if (completed) {
        
        [self.activity dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void) hideBanner:(id) sender {
    NSLog(@"compress");
    
    //[_banner hinge:NULL];
}

#pragma mark - Wheel Control

- (void)wheelDidChangeValue:(id)sender
{
    //self.valueLabel.text = [NSString stringWithFormat:@"Selected index: %d", self.wheel.selectedIndex];
}

- (CGFloat)snappingAngleForWheel:(id)sender
{
    return M_PI / 2;
}

-(void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) keyboardWasShown:(NSNotification*)aNotification
{
    
    NSDictionary* info = [aNotification userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    
    
    // Move
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    NSLog(@"frame..%f..%f..%f..%f",self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    NSLog(@"keyboard..%f..%f..%f..%f",keyboardFrame.origin.x, keyboardFrame.origin.y, keyboardFrame.size.width, keyboardFrame.size.height);
    
  
    
   
    if (_isPortrate==YES) {
        
        NSLog(@"--keyboard shown--");
         self.viewAds.hidden = YES;
        self.chatView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.frame.size.height-keyboardFrame.size.height-40);
        
        self.overlay.frame = self.chatView.frame;
        self.overlay.hidden = NO;
        
        _chat.mainView.frame = self.chatView.frame;
        [self.view layoutIfNeeded];
        [self.chatView layoutIfNeeded];
        [self.chat.mainView layoutIfNeeded];
        

    } else {
       
    }
    
    [UIView commitAnimations];
}


-(void) keyboardWillHide:(NSNotification*)aNotification
{
    

    if (_isPortrate==YES) {
        self.viewAds.hidden = NO;
        self.overlay.frame = self.chatView.frame;
        self.overlay.hidden = YES;
        
        [self.viewAds.mainView  setFrame:CGRectMake(self.viewAds.frame.origin.x, self.player.view.frame.size.height-2, self.view.bounds.size.width, 40.0)];
        self.chatView.frame = CGRectMake(0, self.player.view.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.player.view.frame.size.height);
       _chat.mainView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.chatView.frame.size.height-40.0);
        [self.view layoutIfNeeded];
        [self.chatView layoutIfNeeded];
        [self.chat.mainView layoutIfNeeded];
        
    }
}

#pragma mark - Actions

- (void)twitterAction
{
  [self.menu collapse];
  self.overlay.hidden = NO;
  self.twitterView.hidden = NO;
  [self.twitterView expandIntoView:self.view finished:NULL];
}

- (void)chatAction
{
  [self.menu collapse];
  self.overlay.hidden = NO;
  self.chatView.hidden = NO;
  [self.chatView expandIntoView:self.view finished:NULL];
}

- (void)registrationAction
{
  if (self.regView == nil) {
    CGFloat w = self.view.bounds.size.width * 0.45;
    CGFloat h = 30;

    AdTopBar *top = [[NSBundle mainBundle] loadNibNamed:@"AdTopBar" owner:self options:nil][0];
    top.leftImage.image = [UIImage imageNamed:@"menu-reg.png"];
    top.rightImage.image = [UIImage imageNamed:@"honeywell.png"];
    top.frame = CGRectMake(0, 0, w, h);

    self.regView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, w, self.view.bounds.size.height)];
    self.regView.hidden = YES;

    UIView *regViewContainer = [[UIView alloc] initWithFrame: CGRectMake(0, h, w, self.view.bounds.size.height - h)];

    RegistrationViewController *regVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
    regVC.containerView = self.regView;
    [self addChildController:regVC toView: regViewContainer];

    [self.regView addSubview:top];
    [self.regView  addSubview: regViewContainer];
  }
  [self.menu collapse];
  self.overlay.hidden = NO;
  self.regView.hidden = NO;
  [self.regView expandIntoView:self.view finished:NULL];
}

- (void)shopAction
{
  if (self.storeView == nil) {
    CGFloat w = self.view.bounds.size.width * 0.45;
    CGFloat h = 30;

    AdTopBar *top = [[NSBundle mainBundle] loadNibNamed:@"AdTopBar" owner:self options:nil][0];
    top.leftImage.image = [UIImage imageNamed:@"menu-cart.png"];
    top.rightImage.image = [UIImage imageNamed:@"honeywell.png"];
    top.frame = CGRectMake(0, 0, w, h);

    self.storeView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, w, self.view.bounds.size.height)];
    self.storeView.hidden = YES;

    UIView *storeViewContainer = [[UIView alloc] initWithFrame: CGRectMake(0, h, w, self.view.bounds.size.height - h)];

    StoreViewController *storeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreViewController"];
    storeVC.containerView = self.storeView;
    [self addChildController:storeVC toView: storeViewContainer];

    [self.storeView addSubview:top];
    [self.storeView addSubview:storeViewContainer];
  }
  [self.menu collapse];
  self.overlay.hidden = NO;
  self.storeView.hidden = NO;
  [self.storeView expandIntoView:self.view finished:NULL];
}

#pragma mark - Ad

NSTimer *_adTimer;
BOOL _adShown;
UIImageView *_adView;
CGFloat _adWidth;

- (void)initAdParams
{
	adInterval = 15;
	adShowDuration = 5;
	adAnimationDuration = 1;
	adMargin = 10;
	adBackgroundColor = [UIColor colorWithRed:27.0 / 255.0 green:53.0 / 255.0 blue:79.0 / 255.0 alpha:0.7];
	adBorderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
	adBorderWidth = 2;
	CGFloat fontSize = 13;
	adTextColor = [UIColor whiteColor];
	adTextFont = [UIFont systemFontOfSize:fontSize];
	adTextBoldFont = [UIFont systemFontOfSize:fontSize weight:UIFontWeightHeavy];
	UIColor *yellow = [UIColor colorWithRed:249.0 / 255.0 green:205.0 / 255.0 blue:0 alpha:1];
	NSDictionary *regularAttrs = @{ NSFontAttributeName:adTextFont, NSForegroundColorAttributeName:adTextColor };
	NSDictionary *boldAttrs = @{ NSFontAttributeName:adTextBoldFont, NSForegroundColorAttributeName:adTextColor };
	NSDictionary *yellowBoldAttrs = @{ NSFontAttributeName:adTextBoldFont, NSForegroundColorAttributeName:yellow };
	adText = [[NSMutableAttributedString alloc] initWithString:@"Hungry? Enjoy a free Big Mac on us. Click here." attributes:regularAttrs];
	[adText setAttributes:boldAttrs range:NSMakeRange(0, 7)];
	[adText setAttributes:boldAttrs range:NSMakeRange(36, 11)];
	[adText setAttributes:yellowBoldAttrs range:NSMakeRange(16, 12)];
	adImage = @"ad.png";
}

- (void)startAd
{
	[self hideAndStopAdWithAnimation:YES];
	if (self.wheel != nil) {
		[self stopAd];
		_adTimer = [NSTimer scheduledTimerWithTimeInterval:adInterval target:self selector:@selector(showHideAd) userInfo:nil repeats:NO];
	}
}

- (void)stopAd
{
	[_adTimer invalidate];
	_adTimer = nil;
//  [self.view addSubview:self.mainBtn];
}


- (void)showHideAd
{
	[self showHideAdWithAnimation:YES];
}


- (void)showHideAdWithAnimation:(BOOL)animated
{
	if (!self.overlay.hidden || self.activity != nil) {
		[self stopAd];
		return;
	}
	
//	CGRect buttonFrame = self.mainBtn.frame;
  CGRect buttonFrame = self.menu.buttonFrame;
	if (_adShown) {
		switch (self.adType) {
			case 0: {
				if (animated) {
					[UIView animateWithDuration:adAnimationDuration delay:0 options:0 animations:^{
						_adView.frame = CGRectMake(buttonFrame.origin.x + buttonFrame.size.height / 2, buttonFrame.origin.y, 0, buttonFrame.size.height);
					} completion:^(BOOL finished){
						[self stopAd];
						[_adView removeFromSuperview];
						_adTimer = [NSTimer scheduledTimerWithTimeInterval:adInterval target:self selector:@selector(showHideAd) userInfo:nil repeats:NO];
					}];
				} else {
					[self stopAd];
					[_adView removeFromSuperview];
					_adTimer = [NSTimer scheduledTimerWithTimeInterval:adInterval target:self selector:@selector(showHideAd) userInfo:nil repeats:NO];
				}
			}	break;
			case 1:
			case 2:
			case 3: {
				if (animated) {
					[UIView animateWithDuration:adAnimationDuration delay:0 options:0 animations:^{
						_adView.alpha = 0;
					} completion:^(BOOL finished){
						[self stopAd];
						[_adView removeFromSuperview];
						_adTimer = [NSTimer scheduledTimerWithTimeInterval:adShowDuration target:self selector:@selector(showHideAd) userInfo:nil repeats:NO];
					}];
				} else {
					[self stopAd];
					[_adView removeFromSuperview];
					_adTimer = [NSTimer scheduledTimerWithTimeInterval:adInterval target:self selector:@selector(showHideAd) userInfo:nil repeats:NO];
				}
			}	break;
			default:
				break;
		}
	} else {
		self.adType = (self.adType + 1) % 1;

//		self.adType = 3;
		
		switch (self.adType) {
			case 0: {
        UILabel *adLabel = [[UILabel alloc] init];
				adLabel.text = @"Click to checkout our 2018 Connected Solutions!";
        adLabel.textColor = [UIColor whiteColor];
        adLabel.font = [UIFont boldSystemFontOfSize:12];
				adLabel.numberOfLines = 1;
				[adLabel sizeToFit];
				CGRect frame = adLabel.frame;
				frame.size.height = buttonFrame.size.height;
				frame.origin.x = buttonFrame.size.width / 2;
				adLabel.frame = frame;

        _adWidth = adLabel.frame.size.width + buttonFrame.size.width * 1.5;
        _adView = [[UIImageView alloc] initWithFrame:CGRectMake(self.menu.frame.origin.x + self.menu.buttonFrame.size.width / 2, self.menu.buttonFrame.origin.y, 0, buttonFrame.size.height)];
				_adView.clipsToBounds = YES;
        _adView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
        [_adView addSubview:adLabel];

        UIView *leftBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, buttonFrame.size.height)];
        leftBorder.backgroundColor = [UIColor redColor];
        [_adView addSubview:leftBorder];

				[self.view insertSubview:_adView belowSubview:self.menu];
				[self stopAd];
				[UIView animateWithDuration:adAnimationDuration delay:0 options:0 animations:^{
          CGRect frame = _adView.frame;
          frame.origin.x -= _adWidth;
          frame.size.width = _adWidth;
          _adView.frame = frame;
				} completion:^(BOOL finished){
					[self stopAd];
					_adTimer = [NSTimer scheduledTimerWithTimeInterval:adShowDuration target:self selector:@selector(showHideAd) userInfo:nil repeats:NO];
				}];
			}	break;
			case 1: { // movie
				NSString *descPath = [[NSBundle mainBundle] pathForResource:@"description.plist" ofType:nil inDirectory:@"Ad/Movie"];
				NSDictionary *desc = [NSDictionary dictionaryWithContentsOfFile:descPath];
				CGFloat sx = self.view.bounds.size.width / 544;
				CGFloat sy = self.view.bounds.size.height / 306;
				CGFloat s = MIN(sx, sy);
				_adView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 120 * sy, self.view.bounds.size.width, 120 * sy)];
				_adView.userInteractionEnabled = YES;
				UIView *toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, (120 - 52) * sy, _adView.bounds.size.width, 52 * sy)];
				toolbar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65];
				[_adView addSubview:toolbar];
				NSString *posterPath = [[NSBundle mainBundle] pathForResource:desc[@"Poster"] ofType:nil inDirectory:@"Ad/Movie"];
				UIImage *poster = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:posterPath]];
				UIImageView *filmPoster = [[UIImageView alloc] initWithImage:poster];
				filmPoster.contentMode = UIViewContentModeScaleAspectFit;
				CGFloat posterWidth = _adView.bounds.size.width * 0.321;
				CGFloat sideWidth = (_adView.bounds.size.width - posterWidth) / 2;
				filmPoster.frame = CGRectMake(sideWidth, 0, posterWidth, _adView.bounds.size.height);
				[_adView addSubview:filmPoster];
				NSString *namePath = [[NSBundle mainBundle] pathForResource:desc[@"Name"] ofType:nil inDirectory:@"Ad/Movie"];
				UIImageView *filmName = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:namePath]];
				filmName.contentMode = UIViewContentModeScaleAspectFit;
				filmName.frame = CGRectMake(0, (120 - 52) * sy, sideWidth, 52 * sy);
				[_adView addSubview:filmName];
				CGFloat gap = 10;
				CGFloat seeTrailerWidth = _adView.bounds.size.width * 0.224 - 2 * gap;
				UITextField *seeTrailer = [[UITextField alloc] initWithFrame:CGRectMake(sideWidth + posterWidth + gap, (120 - 52) * sy, seeTrailerWidth, 52 * sy)];
				seeTrailer.font = [desc[@"See"][@"Font"] getFontWithScale:s];
				seeTrailer.text = desc[@"See"][@"Text"];
				seeTrailer.textAlignment = NSTextAlignmentCenter;
				seeTrailer.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
				seeTrailer.textColor = [desc[@"See"][@"Font"][@"Color"] getColor];
				seeTrailer.enabled = NO;
				seeTrailer.adjustsFontSizeToFitWidth = YES;
				[_adView addSubview:seeTrailer];
				CGFloat playButtonWidth = _adView.bounds.size.width * 0.048;
				UIButton *play = [[UIButton alloc] initWithFrame:CGRectMake(seeTrailer.frame.origin.x + seeTrailer.frame.size.width + gap, (120 - 52) * sy + (52 * sy - playButtonWidth) / 2, playButtonWidth, playButtonWidth)];
				NSString *playButtonPath = [[NSBundle mainBundle] pathForResource:desc[@"Play Button"] ofType:nil inDirectory:@"Ad/Movie"];
				[play setImage:[UIImage imageWithContentsOfFile:playButtonPath] forState:UIControlStateNormal];
				[play addTarget:self action:@selector(playVideoAction:) forControlEvents:UIControlEventTouchUpInside];
				[_adView addSubview:play];
				CGFloat closeWidth = 13 * s;
				UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(_adView.bounds.size.width - closeWidth - 5, (120 - 52) * sy + 5, closeWidth, closeWidth)];
				[close setImage:[UIImage imageNamed:@"closeBtn1.png"] forState:UIControlStateNormal];
				[close addTarget:self action:@selector(closeToolbarAdAction:) forControlEvents:UIControlEventTouchUpInside];
				[_adView addSubview:close];
				
				[self.view addSubview:_adView];
				
				AnimationLayer *gradientLayer = [[AnimationLayer alloc] init];
				gradientLayer.frame = _adView.bounds;
				_adView.layer.mask = gradientLayer;
				
				CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"radius"];
				animation.fromValue = [NSNumber numberWithFloat:0];
				animation.toValue = [NSNumber numberWithFloat:sqrtf(_adView.bounds.size.width * _adView.bounds.size.width / 4 + _adView.bounds.size.height * _adView.bounds.size.height / 4)];
				animation.duration = 1.0;
				[gradientLayer addAnimation:animation forKey:@"radiusAnimation"];
				
				[self stopAd];
				[self.mainBtn removeFromSuperview];
				_adTimer = [NSTimer scheduledTimerWithTimeInterval:adShowDuration target:self selector:@selector(showHideAd) userInfo:nil repeats:NO];
			}	break;
			case 2: { // shop
				CGFloat sx = self.view.bounds.size.width / 544;
				CGFloat sy = self.view.bounds.size.height / 306;
				CGFloat s = MIN(sx, sy);
				_adView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 52 * sy, self.view.bounds.size.width, 52 * sy)];
				_adView.userInteractionEnabled = YES;
				_adView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
				
				UIImageView *logo1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"adShopLogo1.png"]];
				logo1.contentMode = UIViewContentModeScaleAspectFit;
				logo1.frame = CGRectMake(6 * sx, 0, 94 * sx, 52 * sy);
				[_adView addSubview:logo1];
				
				UIImageView *logo2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"adShopLogo2.png"]];
				logo2.contentMode = UIViewContentModeScaleAspectFit;
				logo2.frame = CGRectMake(109 * sx, 0, 38 * sx, 52 * sy);
				[_adView addSubview:logo2];
				
				CGFloat w = 32 * s;
				UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - w - 43 * sx, (_adView.bounds.size.height - w) / 2, w, w)];
				button.backgroundColor = [UIColor redColor];
				button.layer.cornerRadius = w / 2;
				button.layer.borderWidth = 2;
				button.layer.borderColor = [[UIColor whiteColor] CGColor];
				UIColor *color = [UIColor whiteColor];
				UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(11 * s)];
				NSDictionary *attrs = @{ NSFontAttributeName:font, NSForegroundColorAttributeName:color };
				[button setAttributedTitle:[[NSAttributedString alloc] initWithString:@"GO" attributes:attrs] forState:UIControlStateNormal];
				[button addTarget:self action:@selector(shopAction:) forControlEvents:UIControlEventTouchUpInside];
				[_adView addSubview:button];

				UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(173 * sx, 0, button.frame.origin.x - 173 * sx - 5, 52 * sy)];
				textLabel.numberOfLines = 0;
				font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(13 * s)];
				attrs = @{ NSFontAttributeName:font, NSForegroundColorAttributeName:color };
				NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"Tired of that old jersey? Check-out our new 2017 collection while you watch the game!" attributes:attrs];
				[textLabel setAttributedText:text];
				[_adView addSubview:textLabel];

				w = 13 * s;
				UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(_adView.bounds.size.width - w - 5, 5, w, w)];
				[close setImage:[UIImage imageNamed:@"closeBtn1.png"] forState:UIControlStateNormal];
				[close addTarget:self action:@selector(closeToolbarAdAction:) forControlEvents:UIControlEventTouchUpInside];
				[_adView addSubview:close];

				[self.view addSubview:_adView];
				[self stopAd];
				[self.mainBtn removeFromSuperview];
				_adView.alpha = 0;
				[UIView animateWithDuration:adAnimationDuration delay:0 options:0 animations:^{
					_adView.alpha = 1;
				} completion:^(BOOL finished){
					[self stopAd];
					[self.mainBtn removeFromSuperview];
					_adTimer = [NSTimer scheduledTimerWithTimeInterval:adShowDuration target:self selector:@selector(showHideAd) userInfo:nil repeats:NO];
				}];
			}	break;
			case 3: { // survey
				CGFloat sx = self.view.bounds.size.width / 544;
				CGFloat sy = self.view.bounds.size.height / 306;
				CGFloat s = MIN(sx, sy);
				_adView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 76 * sy, self.view.bounds.size.width, 76 * sy)];
				_adView.userInteractionEnabled = YES;
				_adView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
				
				UIImageView *logo1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"survey_logo_toolbar.png"]];
				logo1.contentMode = UIViewContentModeScaleAspectFit;
				logo1.frame = CGRectMake(10 * sx, -37 * sx, 120 * sx, 107 * sy);
				[_adView addSubview:logo1];
				
				CGFloat w = 64 * s;
				UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - w - 40 * sx, 28 * sy, w, 29 * sy)];
				button.backgroundColor = [UIColor colorWithRed:0 green:147.0 / 255.0 blue:112.0 / 255.0 alpha:1];
				button.layer.borderWidth = 1;
				button.layer.borderColor = [[UIColor whiteColor] CGColor];
				UIColor *color = [UIColor whiteColor];
				UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(12 * s)];
				NSDictionary *attrs = @{ NSFontAttributeName:font, NSForegroundColorAttributeName:color };
				[button setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Play Now" attributes:attrs] forState:UIControlStateNormal];
				[button addTarget:self action:@selector(surveyAction:) forControlEvents:UIControlEventTouchUpInside];
				[_adView addSubview:button];
				
				UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(146 * sx, 0, button.frame.origin.x - 146 * sx - 10, 76 * sy)];
				textLabel.numberOfLines = 0;
				font = [UIFont fontWithName:@"HelveticaNeue" size:(15 * s)];
				attrs = @{ NSFontAttributeName:font, NSForegroundColorAttributeName:color };
				NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"Pick the first team to score in the 2nd half and win a free large 1-topping pizza!" attributes:attrs];
				UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(13 * s)];
				NSDictionary *boldAttrs = @{ NSFontAttributeName:boldFont, NSForegroundColorAttributeName:color };
				[text setAttributes:boldAttrs range:NSMakeRange(49, 33)];
				[textLabel setAttributedText:text];
				[_adView addSubview:textLabel];
				
				w = 13 * s;
				UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(_adView.bounds.size.width - w - 5, 5, w, w)];
				[close setImage:[UIImage imageNamed:@"closeBtn1.png"] forState:UIControlStateNormal];
				[close addTarget:self action:@selector(closeToolbarAdAction:) forControlEvents:UIControlEventTouchUpInside];
				[_adView addSubview:close];
				
				[self.view addSubview:_adView];
				[self stopAd];
				[self.mainBtn removeFromSuperview];
				_adView.alpha = 0;
				[UIView animateWithDuration:adAnimationDuration delay:0 options:0 animations:^{
					_adView.alpha = 1;
				} completion:^(BOOL finished){
					[self stopAd];
					[self.mainBtn removeFromSuperview];
					_adTimer = [NSTimer scheduledTimerWithTimeInterval:adShowDuration target:self selector:@selector(showHideAd) userInfo:nil repeats:NO];
				}];
			}	break;
			default:
				break;
		}
	}
	_adShown = !_adShown;
}


- (void)hideAndStopAdWithAnimation:(BOOL)animated
{
	[self stopAd];
	if (_adShown) {
		[_adView removeFromSuperview];
		_adShown = NO;
//    [self.view addSubview:self.mainBtn];
	}
	if (self.adSideViewController != nil || self.videoSideViewController != nil || self.surveySideViewController != nil) {
		if (self.videoSideViewController != nil) {
			self.player.avPlayer.muted = NO;
		}
		UIView *adSideView = self.adSideViewController.view;
		if (adSideView == nil) {
			adSideView = self.videoSideViewController.view;
		}
		if (adSideView == nil) {
			adSideView = self.surveySideViewController.view;
		}
		if (adSideView != nil) {
			if (animated) {
				[UIView animateWithDuration:0.35 animations:^{
					CGRect frame = adSideView.frame;
					frame.origin.x = -frame.size.width;
					adSideView.frame = frame;
				} completion:^(BOOL finished){
					[adSideView removeFromSuperview];
					self.adSideViewController = nil;
					self.videoSideViewController = nil;
					self.surveySideViewController = nil;
				}];
			} else {
				[adSideView removeFromSuperview];
				self.adSideViewController = nil;
				self.videoSideViewController = nil;
				self.surveySideViewController = nil;
			}
		}
	}
}


- (void)showAdAction
{
	[self hideAndStopAdWithAnimation:NO];
	
	self.adSideViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdSide"];
	self.adSideViewController.adDelegate = self;
	self.adSideViewController.parentView = self.view;
	self.adSideViewController.width = self.overlay.frame.size.width;
	
	[self.view addSubview:self.adSideViewController.view];
	UIView *adView = self.adSideViewController.view;
	[UIView animateWithDuration:0.35 animations:^{
		CGRect frame = adView.frame;
		frame.origin.x = 0;
		adView.frame = frame;
	} completion:^(BOOL finished){
		_adShown = YES;
	}];
}


- (void)playVideoAction:(UIButton*)sender
{
	[self hideAndStopAdWithAnimation:NO];
	
	self.videoSideViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoSide"];
	self.videoSideViewController.videoSideViewControllerDelegate = self;
	self.videoSideViewController.parentView = self.view;
	self.videoSideViewController.width = self.overlay.frame.size.width;
	
	[self.view addSubview:self.videoSideViewController.view];
	UIView *adView = self.videoSideViewController.view;
	[UIView animateWithDuration:0.35 animations:^{
		CGRect frame = adView.frame;
		frame.origin.x = 0;
		adView.frame = frame;
	} completion:^(BOOL finished){
		self.player.avPlayer.muted = YES;
		_adShown = YES;
	}];
}


- (void)shopAction:(UIButton*)sender
{
	[self hideAndStopAdWithAnimation:NO];
	
	self.slider.hidden = YES;
	UIImage *image = [UIImage imageNamed:@"merch-header"];
	[self.viewAds.headerImage setImage:image];
	self.overlay.hidden = NO;
	self.viewAds.hidden = NO;
	self.twitterView.hidden = YES;
	self.instagramView.hidden = YES;
	self.chatView.hidden = YES;
	[self.merchTableView expandIntoView:self.view finished:NULL];
	self.tourView.hidden = YES;
	self.mapView.hidden = YES;
	self.merchView.hidden = YES;
	self.ticketView.hidden = YES;
}


- (void)surveyAction:(UIButton*)sender
{
	[self hideAndStopAdWithAnimation:NO];
	
	self.surveySideViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SurveySide"];
	self.surveySideViewController.surveySideViewControllerDelegate = self;
	self.surveySideViewController.parentView = self.view;
	self.surveySideViewController.width = self.overlay.frame.size.width;
	
	[self.view addSubview:self.surveySideViewController.view];
	UIView *adView = self.surveySideViewController.view;
	[UIView animateWithDuration:0.35 animations:^{
		CGRect frame = adView.frame;
		frame.origin.x = 0;
		adView.frame = frame;
	} completion:^(BOOL finished){
		_adShown = YES;
	}];
}


- (void)closeToolbarAdAction:(UIButton*)sender
{
	[self showHideAdWithAnimation:NO];
}


- (void)adSideViewControllerDidFinish:(AdSideViewController *)controller
{
	[self startAd];
}


- (void)videoSideViewControllerDidFinish:(VideoSideViewController *)controller
{
	[self startAd];
}


- (void)surveySideViewControllerDidFinish:(SurveySideViewController *)controller
{
	[self startAd];
}

- (void)menuButtonTapped
{
  [self showMenuHide:self];
}

@end

