#import "StoreViewController.h"
#import "StoreTableViewCell.h"
#import "UIView+DCAnimationKit.h"

@interface StoreViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *descView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;

@end

@implementation StoreViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
  [self.purchaseButton addTarget:self action:@selector(purchaseAction) forControlEvents:UIControlEventTouchUpInside];

  self.descLabel.text = @"Honeywell's LYNX Touch 5210 all-in-one home and business control system features are crystal clear, full-color 4.3\" touchscreen with graphic icons and intuitive prompts for easy operation.\n\nIt features live video on demand, Z-wave automation capabilities, advanced alarm communications, garage door indication and control, tornado alerts for U.S. and Canadian residents, and remote software upgradeability";

  self.backButton.layer.cornerRadius = 2;
  self.backButton.layer.borderWidth = 1;
  self.backButton.layer.borderColor = [[UIColor colorWithRed:(60.0 / 255.0) green:(167.0 / 255.0) blue:(245.0 / 255.0) alpha:1] CGColor];

  self.purchaseButton.layer.cornerRadius = 2;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  CGRect frame = self.tableView.frame;
  frame.origin.x = 0;
  self.tableView.frame = frame;
  self.descView.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  StoreTableViewCell *cell = (StoreTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
  UIView *bgColorView = [[UIView alloc] init];
  bgColorView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
  [cell setSelectedBackgroundView:bgColorView];
  return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UILabel *v = [[UILabel alloc] init];
  v.frame = CGRectMake(0, 0, 1, 60);
  v.numberOfLines = 0;
  v.font = [UIFont systemFontOfSize:16];
  v.textAlignment = NSTextAlignmentCenter;
  v.textColor = [UIColor colorWithWhite:1 alpha:1];
  v.backgroundColor = [UIColor clearColor];
  v.text = @"Explore Honeywell\nConnected Solutions";
  return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  self.descView.hidden = NO;
  CGRect frame = self.descView.frame;
  frame.origin.x = frame.size.width;
  self.descView.frame = frame;
  [UIView animateWithDuration:0.4 animations:^{
    CGRect frame = self.tableView.frame;
    frame.origin.x = -frame.size.width;
    self.tableView.frame = frame;

    frame = self.descView.frame;
    frame.origin.x = 0;
    self.descView.frame = frame;
  } completion: ^(BOOL finished) {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
  }];
}

- (void)backAction {
  [UIView animateWithDuration:0.4 animations:^{
    CGRect frame = self.tableView.frame;
    frame.origin.x = 0;
    self.tableView.frame = frame;

    frame = self.descView.frame;
    frame.origin.x = frame.size.width;
    self.descView.frame = frame;
  }];
}

- (void)purchaseAction {
  [self.containerView expandIntoView:nil finished:nil];
  [self.overlayView expandIntoView:nil finished:nil];
}

@end
