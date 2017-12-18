//
//  successViewController.m
//  LiveOne
//
//  Created by Александр Мазалецкий on 02.02.17.
//  Copyright © 2017 Remi Development. All rights reserved.
//

#import "successViewController.h"

@interface successViewController ()

@end

@implementation successViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backButtonAction:) name:@"backButtonAction" object:nil];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"anotherBackground" object:nil];
    
    _successImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleFingerTap1 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap1:)];
    [_successImage addGestureRecognizer:singleFingerTap1];
}


- (void)handleSingleTap1:(UITapGestureRecognizer *)recognizer {
    
    _scrollView.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"returnBackground" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //Do stuff here...
}

- (void) viewWillAppear:(BOOL)animated {
    
}

- (void) backButtonAction:(id) sender {
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"returnBackground" object:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

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

@end
