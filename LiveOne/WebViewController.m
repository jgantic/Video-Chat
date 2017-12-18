//
//  WebViewController.m
//  LiveOne
//
//  Created by Александр on 08.08.15.
//  Copyright (c) 2015 Remi Development. All rights reserved.
//

#import "WebViewController.h"
#import "NJKWebViewProgressView.h"
#import "UIViewController+MaryPopin.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@end

@implementation WebViewController
NJKWebViewProgressView *_progressView;
NJKWebViewProgress *_progressProxy;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView.frame = CGRectMake(0, _webView.frame.origin.y+30, self.view.frame.size.width, self.view.frame.size.height-45);
    _closeButton.frame = CGRectMake(self.view.frame.size.width-self.closeButton.frame.size.width-10,  self.closeButton.frame.origin.y, self.closeButton.frame.size.width, self.closeButton.frame.size.height);
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    CGFloat progressBarHeight = 3.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self.navigationController.navigationBar addSubview:_progressView];
    
    _labelWebView.text = _url.absoluteString;
    
    [self loadData];
    
    /*----*/
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

-(void)loadData
{
    if (_url!=nil) {
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:_url];
        [_webView loadRequest:req];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
  
    [_progressView setProgress:progress animated:YES];
}
- (BOOL)webView:(UIWebView * _Nonnull)webView
shouldStartLoadWithRequest:(NSURLRequest * _Nonnull)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *currentURL = _webView.request.URL.absoluteString;
    _labelWebView.text = currentURL;
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView * _Nonnull)webView {
   
}

- (IBAction)closeButtonPressed:(id)sender {
    [self.presentingPopinViewController dismissCurrentPopinControllerAnimated:YES completion:^{
        [_player playContent];
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
   NSString *webTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
   _labelWebView.text = webTitle;
}

@end
