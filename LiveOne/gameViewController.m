//
//  gameViewController.m
//  LiveOne
//
//  Created by Александр Мазалецкий on 02.02.17.
//  Copyright © 2017 Remi Development. All rights reserved.
//

#import "gameViewController.h"

@interface gameViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation gameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _plusButton.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleFingerTap1 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap1:)];
    [_plusButton addGestureRecognizer:singleFingerTap1];
    
    _minusButton.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleFingerTap2 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap2:)];
    [_minusButton addGestureRecognizer:singleFingerTap2];
    
    
    
    UITapGestureRecognizer *singleFingerTap3 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap3:)];
    [_buyImage addGestureRecognizer:singleFingerTap3];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backButtonAction:) name:@"backButtonAction" object:nil];
    
    // Do any additional setup after loading the view.
}

- (void) backButtonAction:(id) sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _scrollView.hidden = NO;
}
- (void)handleSingleTap1:(UITapGestureRecognizer *)recognizer {
    
    _scrollView.hidden = YES;
    UIViewController *game = [self.storyboard instantiateViewControllerWithIdentifier:@"plusViewController"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showBackButton" object:nil];
    
    [self.navigationController pushViewController:game animated:YES];
    
    //Do stuff here...
}


- (void)handleSingleTap2:(UITapGestureRecognizer *)recognizer {
    
    _scrollView.hidden = YES;
    UIViewController *game = [self.storyboard instantiateViewControllerWithIdentifier:@"minusViewController"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showBackButton" object:nil];
    
    [self.navigationController pushViewController:game animated:YES];
    
    //Do stuff here...
}


- (void)handleSingleTap3:(UITapGestureRecognizer *)recognizer {
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    _scrollView.hidden = YES;
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
