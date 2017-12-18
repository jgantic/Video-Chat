//
//  wagerViewController.m
//  LiveOne
//
//  Created by Александр Мазалецкий on 02.02.17.
//  Copyright © 2017 Remi Development. All rights reserved.
//

#import "wagerViewController.h"

@interface wagerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *enterField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation wagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _enterField.delegate = self;
    // Do any additional setup after loading the view.
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *singleFingerTap1 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(backgroundTap:)];
    
    _scrollView.userInteractionEnabled = YES;
    [_scrollView addGestureRecognizer:singleFingerTap1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backButtonAction:) name:@"backButtonAction" object:nil];
    
    [_enterField becomeFirstResponder];
}

- (void) backButtonAction:(id) sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _scrollView.hidden = NO;
}

-(void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


-(void) keyboardWasShown:(NSNotification*)aNotification
{
    
}


-(IBAction) backgroundTap:(id) sender
{
    //[_enterField resignFirstResponder];
}

-(void) keyboardWillHide:(NSNotification*)aNotification
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)buyAction:(id)sender {
    if (_enterField.text.length>0) {
         _scrollView.hidden = YES;
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        UIViewController *confirm = [self.storyboard instantiateViewControllerWithIdentifier:@"confirmViewController"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showBackButton" object:nil];
        
        [self.navigationController pushViewController:confirm animated:YES];
    }
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
