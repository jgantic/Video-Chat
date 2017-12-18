//
//  confirmViewController.m
//  LiveOne
//
//  Created by Александр Мазалецкий on 02.02.17.
//  Copyright © 2017 Remi Development. All rights reserved.
//

#import "confirmViewController.h"
#define MAXLENGTH 1

@interface confirmViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *codeFieldImage;
@property (weak, nonatomic) IBOutlet UITextField *enterField;
@property (weak, nonatomic) IBOutlet UITextField *enterField1;
@property (weak, nonatomic) IBOutlet UITextField *enterField2;
@property (weak, nonatomic) IBOutlet UITextField *enterField3;
@property (strong, nonatomic) NSString *text;
@property (weak, nonatomic) IBOutlet UIImageView *confirmText;

@end

@implementation confirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _enterField.delegate = self;
    _enterField1.delegate = self;
    _enterField2.delegate = self;
    _enterField3.delegate = self;
    
    // Do any additional setup after loading the view.
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *singleFingerTap1 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(backgroundTap:)];
    
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:singleFingerTap1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backButtonAction:) name:@"backButtonAction" object:nil];
    
    [_enterField becomeFirstResponder];
}

- (void) backButtonAction:(id) sender {
    [self.navigationController popViewControllerAnimated:NO];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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


- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
}


- (void) textFieldDidEndEditing:(UITextField *)textField {
    if ((textField == _enterField) && ([_enterField.text length]==0)) {
        _enterField.text = _text;
         [_enterField1 becomeFirstResponder];
    }
    
    if ((textField == _enterField1) && ([_enterField1.text length]==0)) {
        _enterField1.text = _text;
        [_enterField2 becomeFirstResponder];
    }
    
    if ((textField == _enterField2) && ([_enterField2.text length]==0)) {
        _enterField2.text = _text;
        [_enterField3 becomeFirstResponder];
    }
    
    if ((textField == _enterField3) && ([_enterField3.text length]==0)) {
        _enterField3.text = _text;
        [_enterField3 resignFirstResponder];
    }
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    
    if (oldLength == 0) {
        if ((textField == _enterField) && (newLength==1)) {
            _text = string;
            [_enterField resignFirstResponder];
            return NO;
        }
    
        else if ((textField == _enterField1) && (newLength==1)) {
            _text = string;
            [_enterField1 resignFirstResponder];
            return NO;
        }
    
        else if ((textField == _enterField2) && (newLength==1)) {
            _text = string;
            [_enterField2 resignFirstResponder];
            return NO;
        }
    
        else if ((textField == _enterField3) && (newLength==1)) {
            _text = string;
            [_enterField3 resignFirstResponder];
            return NO;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)confirmAction:(id)sender {
    
    if ((_enterField.text.length>0) && (_enterField1.text.length>0) &&  (_enterField2.text.length>0) && (_enterField3.text.length>0)) {
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        UIViewController *confirm = [self.storyboard instantiateViewControllerWithIdentifier:@"successViewController"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showBackButton" object:nil];
        
        [self.navigationController pushViewController:confirm animated:NO];
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
