#import <UIKit/UIKit.h>

@class SurveySideViewController;

@protocol SurveySideViewControllerDelegate

- (void)surveySideViewControllerDidFinish:(SurveySideViewController*)controller;

@end

@interface SurveySideViewController <UITextFieldDelegate> : UIViewController

@property (nonatomic, weak) id<SurveySideViewControllerDelegate> surveySideViewControllerDelegate;
@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, assign) CGFloat width;

@end
