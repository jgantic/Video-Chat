#import "VideoSideViewController.h"
#import "Extensions.h"
#import <XCDYouTubeKit/XCDYouTubeKit.h>

@interface VideoSideViewController ()

@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (strong, nonatomic) VKVideoPlayer *playerVideo;
@property (weak, nonatomic) IBOutlet UIImageView *nameImageView;
@property (weak, nonatomic) IBOutlet UILabel *whereLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation VideoSideViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.view.frame = CGRectMake(-self.width, 0, self.width, self.parentView.frame.size.height);

	NSString *descPath = [[NSBundle mainBundle] pathForResource:@"description.plist" ofType:nil inDirectory:@"Ad/Movie"];
	NSDictionary *desc = [NSDictionary dictionaryWithContentsOfFile:descPath];

	NSString *namePath = [[NSBundle mainBundle] pathForResource:desc[@"Name"] ofType:nil inDirectory:@"Ad/Movie"];
	self.nameImageView.image = [UIImage imageWithContentsOfFile:namePath];
	
	self.whereLabel.text = desc[@"Where"][@"Text"];
	self.whereLabel.font = [desc[@"Where"][@"Font"] getFont];
	self.whereLabel.textColor = [desc[@"Where"][@"Font"][@"Color"] getColor];
	
	self.dateLabel.text = desc[@"Date"][@"Text"];
	self.dateLabel.font = [desc[@"Date"][@"Font"] getFont];
	self.dateLabel.textColor = [desc[@"Date"][@"Font"][@"Color"] getColor];

	NSString *videoIdentifier = desc[@"Trailer Id"];
	[[XCDYouTubeClient defaultClient] getVideoWithIdentifier:videoIdentifier completionHandler:^(XCDYouTubeVideo *video, NSError *error) {
		if (video) {
			NSURL *url = [video.streamURLs objectForKey:@(XCDYouTubeVideoQualitySmall240)];
			self.playerVideo = [[VKVideoPlayer alloc] init];
			self.playerVideo.delegate = self;
			self.playerVideo.volume = 1;
			self.playerVideo.view.frame = self.videoView.bounds;
			self.playerVideo.playerControlsEnabled = NO;
			self.playerVideo.view.playerControlsAutoHideTime = @0;
			[self.videoView addSubview:self.playerVideo.view];

			VKVideoPlayerTrack *track = [[VKVideoPlayerTrack alloc] initWithStreamURL:url];
			[self.playerVideo loadVideoWithTrack:track];
			[self.playerVideo playContent];
		}
	}];
}


- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didPlayToEnd:(id<VKVideoPlayerTrackProtocol>)track
{
	[self.videoSideViewControllerDelegate videoSideViewControllerDidFinish:self];
}


@end
