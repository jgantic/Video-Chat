#import <UIKit/UIKit.h>

@class AdSideViewController;

@protocol AdSideViewControllerDelegate
- (void)adSideViewControllerDidFinish:(AdSideViewController*)controller;
@end

@interface AdSideViewController : UIViewController<UITextFieldDelegate> {
}

@property (nonatomic, weak) id<AdSideViewControllerDelegate> adDelegate;
@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, assign) CGFloat width;

@end
