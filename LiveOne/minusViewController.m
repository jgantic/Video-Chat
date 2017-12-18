//
//  minusViewController.m
//  LiveOne
//
//  Created by Александр Мазалецкий on 02.02.17.
//  Copyright © 2017 Remi Development. All rights reserved.
//

#import "minusViewController.h"

@interface minusViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *minusDetailImage;
@end

@implementation minusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backButtonAction:) name:@"backButtonAction" object:nil];
    // Do any additional setup after loading the view.
    
    _minusDetailImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleFingerTap1 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap1:)];
    [_minusDetailImage addGestureRecognizer:singleFingerTap1];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _scrollView.hidden = NO;
}

- (void) backButtonAction:(id) sender {
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSingleTap1:(UITapGestureRecognizer *)recognizer {
    
    _scrollView.hidden = YES;
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    UIViewController *game = [self.storyboard instantiateViewControllerWithIdentifier:@"wagerViewController"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showBackButton" object:nil];
    
    [self.navigationController pushViewController:game animated:YES];
    
    //Do stuff here...
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
