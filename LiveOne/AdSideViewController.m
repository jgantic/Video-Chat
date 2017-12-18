#import "AdSideViewController.h"

@interface AdSideViewController ()

@property (weak, nonatomic) IBOutlet UIButton *enterPhoneButton;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *agreementLabel;
@property (weak, nonatomic) IBOutlet UILabel *agreementLabel2;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *submitView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *keyboardView;
@property (weak, nonatomic) IBOutlet UIButton *key1;
@property (weak, nonatomic) IBOutlet UIButton *key2;
@property (weak, nonatomic) IBOutlet UIButton *key3;
@property (weak, nonatomic) IBOutlet UIButton *key4;
@property (weak, nonatomic) IBOutlet UIButton *key5;
@property (weak, nonatomic) IBOutlet UIButton *key6;
@property (weak, nonatomic) IBOutlet UIButton *key7;
@property (weak, nonatomic) IBOutlet UIButton *key8;
@property (weak, nonatomic) IBOutlet UIButton *key9;
@property (weak, nonatomic) IBOutlet UIButton *key0;
@property (weak, nonatomic) IBOutlet UIButton *keyDel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardCenter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *key5Bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *key5Trailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *key5Leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *key5Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *key0Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyHeight;

@property (strong, nonatomic) NSMutableString *phone;

@end

@implementation AdSideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.frame = CGRectMake(-self.width, 0, self.width, self.parentView.frame.size.height);
	self.phone = [NSMutableString string];
	self.phoneTextField.tintColor = [UIColor clearColor]; // setting in IB doesn't work
	self.enterPhoneButton.layer.borderWidth = 1;
	self.enterPhoneButton.layer.borderColor = [[UIColor whiteColor] CGColor];
	UIFont *font = [UIFont fontWithName:@"Helvetica" size:9];
	NSDictionary *regularAttrs = @{ NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor] };
	NSDictionary *yellowAttrs = @{ NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor colorWithRed:249.0 / 255.0 green:205.0 / 255.0 blue:0 alpha:1] };
	NSMutableAttributedString *agreement = [[NSMutableAttributedString alloc] initWithString:@"By sumbitting your mobile number you are agreeing to McDonald's Terms of Agreement" attributes:regularAttrs];
	[agreement setAttributes:yellowAttrs range:NSMakeRange(64, 18)];
	self.agreementLabel.attributedText = agreement;
	self.agreementLabel2.attributedText = agreement;
	self.phoneTextField.layer.masksToBounds = YES;
	self.phoneTextField.layer.borderColor = [[UIColor whiteColor] CGColor];
	self.phoneTextField.layer.borderWidth = 1;
	self.phoneTextField.layer.cornerRadius = 2;
	CGFloat keyWidth = 48;
	if (self.view.bounds.size.height == 320) {
		keyWidth = 42;
		self.phoneTop.constant = 40;
		self.phoneBottom.constant = 5;
		self.keyWidth.constant = keyWidth;
		self.keyHeight.constant = keyWidth;
		self.key5Bottom.constant = 8;
		self.key5Top.constant = 8;
		self.key5Trailing.constant = 8;
		self.key5Leading.constant = 8;
		self.key0Top.constant = 8;
		self.keyboardCenter.constant = 4;
	} else if (self.view.bounds.size.height == 375) {
			keyWidth = 42;
			self.phoneTop.constant = 70;
			self.phoneBottom.constant = 10;
			self.keyWidth.constant = keyWidth;
			self.keyHeight.constant = keyWidth;
			self.key5Bottom.constant = 12;
			self.key5Top.constant = 12;
			self.key5Trailing.constant = 12;
			self.key5Leading.constant = 12;
			self.key0Top.constant = 12;
			self.keyboardCenter.constant = 6;
	}
	self.keyDel.imageView.contentMode = UIViewContentModeScaleAspectFit;
	self.keyDel.imageEdgeInsets = UIEdgeInsetsMake(0, keyWidth / 8, 0, keyWidth / 4);
	for (UIButton *key in @[self.key0, self.key1, self.key2, self.key3, self.key4, self.key5, self.key6, self.key7, self.key8, self.key9]) {
		key.layer.cornerRadius = keyWidth / 2;
		key.layer.borderColor = [[UIColor whiteColor] CGColor];
		key.layer.borderWidth = 1;
	}
	self.backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
	self.firstView.hidden = NO;
	self.headerView.hidden = NO;
	self.adView.hidden = NO;
	self.phoneView.hidden = YES;
	self.submitView.hidden = YES;
	self.keyboardView.hidden = YES;
	self.secondView.hidden = YES;
}


- (IBAction)enterPhoneAction:(UIButton*)sender
{
	CGRect frame = self.phoneView.frame;
	frame.origin.x = frame.size.width;
	self.phoneView.frame = frame;
	self.phoneView.hidden = NO;
	frame = self.keyboardView.frame;
	frame.origin.x = frame.size.width;
	self.keyboardView.frame = frame;
	self.keyboardView.hidden = NO;
	[UIView animateWithDuration:0.35 animations:^{
		CGRect frame = self.phoneView.frame;
		frame.origin.x = 0;
		self.phoneView.frame = frame;
		frame = self.keyboardView.frame;
		frame.origin.x = 0;
		self.keyboardView.frame = frame;
		frame = self.adView.frame;
		frame.origin.x = -frame.size.width;
		self.adView.frame = frame;
	} completion:^(BOOL finished){
		self.adView.hidden = YES;
	}];
}


- (IBAction)submitAction:(UIButton*)sender
{
	CGRect frame = self.secondView.frame;
	frame.origin.x = frame.size.width;
	self.secondView.frame = frame;
	self.secondView.hidden = NO;
	[UIView animateWithDuration:0.35 animations:^{
		CGRect frame = self.secondView.frame;
		frame.origin.x = 0;
		self.secondView.frame = frame;
		frame = self.firstView.frame;
		frame.origin.x = -frame.size.width;
		self.firstView.frame = frame;
		frame = self.headerView.frame;
		frame.origin.x = -frame.size.width;
		self.headerView.frame = frame;
		frame = self.phoneView.frame;
		frame.origin.x = -frame.size.width;
		self.phoneView.frame = frame;
		frame = self.submitView.frame;
		frame.origin.x = -frame.size.width;
		self.submitView.frame = frame;
	} completion:^(BOOL finished){
		self.firstView.hidden = YES;
	}];

	NSString *accountSID = @"AC556a36e2a4d7d5915e93f1dacbcf6143";
	NSString *authToken = @"79523876a0dd9906c7d20ad7e085ca07";
	NSString *fromNumber = @"%2B12248777213";
	NSString *toNumber = [@"%2B1" stringByAppendingString:self.phone];
	NSString *message = @"McDonald_s: Here is your coupon for a free Big Mac at participating locations. We look forward to seeing you. Enjoy!";
	
	NSString *requestURLStr = [NSString stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages", accountSID, authToken, accountSID];
	NSURL *requestURL = [NSURL URLWithString:requestURLStr];
	NSString *body = [NSString stringWithFormat:@"From=%@&To=%@&Body=%@", fromNumber, toNumber, message];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
	request.HTTPMethod = @"POST";
	request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];

	[[NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		if (data == nil) {
			NSLog(@"error sending sms = %@", [error localizedDescription]);
		}
	}] resume];
}

- (IBAction)backEnterPhoneAction:(UIButton*)sender
{
	[self showKeyboard];
}


- (IBAction)doneAction:(UIButton *)sender
{
	[self.adDelegate adSideViewControllerDidFinish:self];
}


- (IBAction)buttonAction:(UIButton*)sender
{
	switch (sender.tag) {
		case 0:
			[self textField:self.phoneTextField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"0"];
			break;
		case 1:
			[self textField:self.phoneTextField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"1"];
			break;
		case 2:
			[self textField:self.phoneTextField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"2"];
			break;
		case 3:
			[self textField:self.phoneTextField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"3"];
			break;
		case 4:
			[self textField:self.phoneTextField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"4"];
			break;
		case 5:
			[self textField:self.phoneTextField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"5"];
			break;
		case 6:
			[self textField:self.phoneTextField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"6"];
			break;
		case 7:
			[self textField:self.phoneTextField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"7"];
			break;
		case 8:
			[self textField:self.phoneTextField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"8"];
			break;
		case 9:
			[self textField:self.phoneTextField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"9"];
			break;
		case 10:
			[self textField:self.phoneTextField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
			break;
		default:
			break;
	}
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	[self showKeyboard];
	return NO;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if (self.phone.length < 10 && string.length > 0) {
		[self.phone appendString:string];
	} else if (self.phone.length > 0 && string.length == 0) {
		[self.phone deleteCharactersInRange:NSMakeRange(self.phone.length - 1, 1)];
	}
	if (self.phone.length > 0) {
		NSString *template = @"abcdefghij";
		NSMutableString *result = [NSMutableString stringWithString:@"(abc) def ghij"];
		for (NSInteger i = 0; i < template.length; ++i) {
			NSString *fromChar = [template substringWithRange:NSMakeRange(i, 1)];
			NSString *toChar;
			if (i < self.phone.length) {
				toChar = [self.phone substringWithRange:NSMakeRange(i, 1)];
			} else if (i < 3) {
				toChar = @" ";
			} else {
				toChar = @"";
			}
			[result replaceOccurrencesOfString:fromChar withString:toChar options:0 range:NSMakeRange(0, result.length)];
		}
		textField.text = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		if (self.phone.length == 10) {
			[textField resignFirstResponder];
			[self hideKeyboard];
		}
	} else {
		textField.text = nil;
	}
	return NO;
}


- (void)showKeyboard
{
	if (!self.keyboardView.hidden) {
		return;
	}
	CGRect frame = self.keyboardView.frame;
	frame.origin.x = -frame.size.width;
	self.keyboardView.frame = frame;
	self.keyboardView.hidden = NO;
	[UIView animateWithDuration:0.35 animations:^{
		CGRect frame = self.keyboardView.frame;
		frame.origin.x = 0;
		self.keyboardView.frame = frame;
		frame = self.submitView.frame;
		frame.origin.x = frame.size.width;
		self.submitView.frame = frame;
	} completion:^(BOOL finished){
		self.submitView.hidden = YES;
	}];
}


- (void)hideKeyboard
{
	CGRect frame = self.submitView.frame;
	frame.origin.x = frame.size.width;
	self.submitView.frame = frame;
	self.submitView.hidden = NO;
	[UIView animateWithDuration:0.35 animations:^{
		CGRect frame = self.submitView.frame;
		frame.origin.x = 0;
		self.submitView.frame = frame;
		frame = self.keyboardView.frame;
		frame.origin.x = -frame.size.width;
		self.keyboardView.frame = frame;
	} completion:^(BOOL finished){
		self.keyboardView.hidden = YES;
	}];
}


@end
