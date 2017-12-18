//
//  WebViewController.h
//  LiveOne
//
//  Created by Александр on 08.08.15.
//  Copyright (c) 2015 Remi Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "VKVideoPlayer.h"

@interface WebViewController : UIViewController <UIWebViewDelegate, NJKWebViewProgressDelegate>
@property (nonatomic, strong) VKVideoPlayer* player;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *labelWebView;
@property (nonatomic, strong) NSURL *url;
@end
