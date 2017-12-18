#import <UIKit/UIKit.h>
#import "VKVideoPlayer.h"

@class VideoSideViewController;

@protocol VideoSideViewControllerDelegate

- (void)videoSideViewControllerDidFinish:(VideoSideViewController*)controller;
	
@end

@interface VideoSideViewController : UIViewController <VKVideoPlayerDelegate>

@property (nonatomic, weak) id<VideoSideViewControllerDelegate> videoSideViewControllerDelegate;
@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, assign) CGFloat width;

@end
