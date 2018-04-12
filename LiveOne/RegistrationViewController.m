#import "RegistrationViewController.h"
#import "UIView+DCAnimationKit.h"

@interface RegistrationViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UITextField *firstTextField;
@property (weak, nonatomic) IBOutlet UIView *lastView;
@property (weak, nonatomic) IBOutlet UITextField *lastTextField;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIView *companyView;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  CGFloat r = 2;
  UIColor *placeholderColor = [UIColor whiteColor];
  UIFont *placeholderFont = [UIFont systemFontOfSize:12];

  self.firstView.layer.cornerRadius = r;
  NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.firstTextField.placeholder attributes:@{NSForegroundColorAttributeName: placeholderColor, NSFontAttributeName: placeholderFont}];
  self.firstTextField.attributedPlaceholder = str;
  self.firstTextField.delegate = self;

  self.lastView.layer.cornerRadius = r;
  [str replaceCharactersInRange:NSMakeRange(0, [str length]) withString:self.lastTextField.placeholder];
  self.lastTextField.attributedPlaceholder = str;
  self.lastTextField.delegate = self;

  self.emailView.layer.cornerRadius = r;
  [str replaceCharactersInRange:NSMakeRange(0, [str length]) withString:self.emailTextField.placeholder];
  self.emailTextField.attributedPlaceholder = str;
  self.emailTextField.delegate = self;

  self.companyView.layer.cornerRadius = r;
  [str replaceCharactersInRange:NSMakeRange(0, [str length]) withString:self.companyTextField.placeholder];
  self.companyTextField.attributedPlaceholder = str;
  self.companyTextField.delegate = self;

  self.phoneView.layer.cornerRadius = r;
  [str replaceCharactersInRange:NSMakeRange(0, [str length]) withString:self.phoneTextField.placeholder];
  self.phoneTextField.attributedPlaceholder = str;
  self.phoneTextField.delegate = self;

  self.submitButton.layer.cornerRadius = r;
  [self.submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShowNotification:(NSNotification*)notification {
  NSDictionary* userInfo = [notification userInfo];
  CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

  UIEdgeInsets insets = self.scrollView.contentInset;
  insets.bottom = keyboardSize.height;
  self.scrollView.contentInset = insets;
  self.scrollView.scrollIndicatorInsets = insets;
}

- (void)keyboardWillHideNotification:(NSNotification*)notification {
  self.scrollView.contentInset = UIEdgeInsetsZero;
  self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)submitAction {
  self.firstTextField.text = nil;
  self.lastTextField.text = nil;
  self.emailTextField.text = nil;
  self.companyTextField.text = nil;
  self.phoneTextField.text = nil;
  [self.containerView expandIntoView:nil finished:nil];
  self.overlayView.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == self.firstTextField) {
    [self.lastTextField becomeFirstResponder];
  } else if (textField == self.lastTextField) {
    [self.emailTextField becomeFirstResponder];
  } else if (textField == self.emailTextField) {
    [self.companyTextField becomeFirstResponder];
  } else if (textField == self.companyTextField) {
    [self.phoneTextField becomeFirstResponder];
  } else if (textField == self.phoneTextField) {
    [self.phoneTextField resignFirstResponder];
  }
  return YES;
}

@end
