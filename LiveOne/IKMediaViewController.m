//
//    Copyright (c) 2015 Shyam Bhat
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "IKMediaViewController.h"
#import "UIImageView+AFNetworking.h"
//#import "InstagramKit.h"
#import "UIViewController+MaryPopin.h"

@interface IKMediaViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@property (strong, nonatomic) UIImageView *imageView1;
@property (strong, nonatomic) UILabel *captionLabel1;

@property (nonatomic) BOOL isPortrait;
@property (nonatomic, strong) InstagramMedia *media;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (nonatomic, weak) IBOutlet SwipeView *swipeView;
@property (nonatomic, strong) NSMutableArray *items;

@end


@implementation IKMediaViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    _isPortrait = NO;
    
  
    
    self.items = [NSMutableArray array];
    for (int i = 0; i < 3; i++)
    {
        [_items addObject:@(i)];
    }
    
    self.swipeView.frame = CGRectMake(self.swipeView.frame.origin.x, self.swipeView.frame.origin.y-10, self.view.frame.size.width, self.view.frame.size.height);
    
    self.closeButton.frame = CGRectMake(self.view.frame.size.width-self.closeButton.frame.size.width-15,  self.closeButton.frame.origin.y, self.closeButton.frame.size.width, self.closeButton.frame.size.height);
    
    
    UIImageView *instagramHeader = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.closeButton.frame.origin.y, self.closeButton.frame.size.width, self.closeButton.frame.size.height)];
    
    [instagramHeader setImage:[UIImage imageNamed:@"instagram-header"]];
    
    [self.view addSubview:instagramHeader];
    
    
    
    UIImageView *cityBank = [[UIImageView alloc] initWithFrame:CGRectMake(((self.view.frame.size.width)*45)/100, self.closeButton.frame.origin.y, 70, self.closeButton.frame.size.height)];
    
    
    cityBank.contentMode = UIViewContentModeScaleAspectFit;
    [cityBank setImage:[UIImage imageNamed:@"adlog"]];
    
    [self.view addSubview:cityBank];
    
    
    
    _swipeView.pagingEnabled = YES;
    [_imageView setHidden:YES];
    [_captionLabel setHidden:YES];
    _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(30, 45, 290, 270)];
    _captionLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(350, 50, 200, 200)];
    
    [_captionLabel1 setTextColor:[UIColor whiteColor]];
    _captionLabel1.numberOfLines = 5;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [self deviceForDeviceOrientation:[UIDevice currentDevice].orientation];
}



- (void) deviceForDeviceOrientation:(UIDeviceOrientation)orientation
{
    
    switch (orientation)
    {
        case UIDeviceOrientationPortrait:
            _isPortrait = YES;
            
            
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            _isPortrait = YES;
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            _isPortrait = NO;
            
            
            break;
        case UIDeviceOrientationLandscapeRight:
            _isPortrait = NO;
            
            break;
            
        case UIDeviceOrientationFaceUp:
            
            
            break;
        case UIDeviceOrientationFaceDown:
            
            break;
        case UIDeviceOrientationUnknown:
            
            break;
    }
}



- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:self.swipeView.frame];
        //view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        if (_isPortrait==NO) {
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, (self.view.frame.size.width*45/100)-50, self.swipeView.frame.size.height-100)];
        
       
        imageView1.contentMode = UIViewContentModeScaleAspectFit;
        
        [imageView1 setImage:[UIImage imageNamed:_image]];
        
        
       
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(imageView1.frame.size.width+45, 30, self.view.frame.size.width-imageView1.frame.size.width+45, self.swipeView.frame.size.height-100)];
        
 
        [imageView2 setImage:[UIImage imageNamed:@"instagram-chat"]];
        
        
        imageView2.contentMode = UIViewContentModeScaleAspectFill;
        //imageView2.contentMode = UIViewContentModeScaleAspectFit;
        
        
        UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.view.frame.size.height-48, 90, 30)];
        
        
        
        imageView3.contentMode = UIViewContentModeScaleAspectFill;
        imageView3.contentMode = UIViewContentModeScaleAspectFit;
        [imageView3 setImage:[UIImage imageNamed:@"like"]];
        
        
        
        //[captionLabel1 setText:self.media.caption.text];
        //[captionLabel1 setTextColor:[UIColor whiteColor]];
        //captionLabel1.numberOfLines = 5;
        [view addSubview:imageView1];
        //[view addSubview:imageView2];
        //[view addSubview:imageView3];
        } else {
            
            UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, self.view.frame.size.width-30, self.view.frame.size.width-60)];
            
            
            imageView1.contentMode = UIViewContentModeScaleAspectFit;
            
            [imageView1 setImage:[UIImage imageNamed:_image]];
            
            
            
            
            UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, imageView1.frame.size.width+30, self.view.frame.size.width, 100)];
            
            
            [imageView2 setImage:[UIImage imageNamed:@"instagram-chat"]];
            
            
            imageView2.contentMode = UIViewContentModeScaleAspectFill;
            //imageView2.contentMode = UIViewContentModeScaleAspectFit;
            
            
            UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.view.frame.size.height-48, 90, 30)];
            
            
            
            imageView3.contentMode = UIViewContentModeScaleAspectFill;
            imageView3.contentMode = UIViewContentModeScaleAspectFit;
            [imageView3 setImage:[UIImage imageNamed:@"like"]];
            
            
            
            //[captionLabel1 setText:self.media.caption.text];
            //[captionLabel1 setTextColor:[UIColor whiteColor]];
            //captionLabel1.numberOfLines = 5;
            [view addSubview:imageView1];
            //[view addSubview:imageView2];
            [view addSubview:imageView3];
            
        }
        
        //[view addSubview:captionLabel1];
    }
    
    return view;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self setModalPresentationStyle:UIModalPresentationCustom];
}


- (void)populateViews
{
    /*[self setTitle:[NSString stringWithFormat:@"@%@",self.media.user.username]];
    [_imageView1 setImageWithURL:self.media.thumbnailURL];
    [_imageView1 setImageWithURL:self.media.standardResolutionImageURL];
    [_captionLabel1 setText:self.media.caption.text];
    
    [self.view addSubview:_imageView1];
    [self.view addSubview:_captionLabel1];*/
}

- (IBAction)closeButtonPressed:(id)sender {
    [self.presentingPopinViewController dismissCurrentPopinControllerAnimated:YES completion:^{
        NSLog(@"Popin dismissed !");
    }];
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //return the total number of items in the carousel
    return [_items count];
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.swipeView.bounds.size;
}


@end
