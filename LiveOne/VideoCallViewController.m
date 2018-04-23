#import "VideoCallViewController.h"
#import "UIView+DCAnimationKit.h"
#import <TwilioVideo/TwilioVideo.h>

@interface VideoCallViewController () <TVIParticipantDelegate, TVIRoomDelegate, TVIVideoViewDelegate, TVICameraCapturerDelegate>

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIView *lastView;
@property (weak, nonatomic) IBOutlet UIButton *endButton;

@property (strong) NSString *user1Token;
@property (strong) NSString *user2Token;
@property (strong) NSString *accessToken;

@property (nonatomic, strong) TVICameraCapturer *camera;
@property (nonatomic, strong) TVILocalVideoTrack *localVideoTrack;
@property (nonatomic, strong) TVILocalAudioTrack *localAudioTrack;
@property (nonatomic) TVIParticipant *participant;
@property (nonatomic, weak) IBOutlet TVIVideoView *remoteView;
@property (nonatomic, strong) TVIRoom *room;

@end

@implementation VideoCallViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  CGFloat r = 2;
  UIColor *placeholderColor = [UIColor whiteColor];
  UIFont *placeholderFont = [UIFont systemFontOfSize:12];

  self.userView.layer.cornerRadius = r;
  NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.userTextField.placeholder attributes:@{NSForegroundColorAttributeName: placeholderColor, NSFontAttributeName: placeholderFont}];
  self.userTextField.attributedPlaceholder = str;

  self.submitButton.layer.cornerRadius = r;
  self.endButton.layer.cornerRadius = self.endButton.frame.size.width / 2;

  CGFloat imageInset = 8;
  self.endButton.imageEdgeInsets = UIEdgeInsetsMake(imageInset, imageInset, imageInset, imageInset);

  [self.submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
  [self.endButton addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];

  self.user1Token = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTSzZiNWM0MGQyYjQwYzllZDU3OTFmMjgzMmUwYzBlN2JlLTE1MjQ0NjI2ODEiLCJpc3MiOiJTSzZiNWM0MGQyYjQwYzllZDU3OTFmMjgzMmUwYzBlN2JlIiwic3ViIjoiQUMwYWIzMzQ5YTUwMjNiMGQ5MmE5NjA4MTAyZDQxNjA3NiIsImV4cCI6MTUyNDQ2NjI4MSwiZ3JhbnRzIjp7ImlkZW50aXR5IjoidXNlcjEiLCJ2aWRlbyI6eyJyb29tIjoidGVzdCJ9fX0.czxSrLeNErGrSDR-MnOBc0RWx_UaEsRAbaWpwjB_obM";
  self.user2Token = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTSzZiNWM0MGQyYjQwYzllZDU3OTFmMjgzMmUwYzBlN2JlLTE1MjQ0NjM0MDQiLCJpc3MiOiJTSzZiNWM0MGQyYjQwYzllZDU3OTFmMjgzMmUwYzBlN2JlIiwic3ViIjoiQUMwYWIzMzQ5YTUwMjNiMGQ5MmE5NjA4MTAyZDQxNjA3NiIsImV4cCI6MTUyNDQ2NzAwNCwiZ3JhbnRzIjp7ImlkZW50aXR5IjoidXNlcjIiLCJ2aWRlbyI6eyJyb29tIjoidGVzdCJ9fX0.oWAEeaNjlkKM5yqIflO0JWGSkZlYyfIMtseknDSlYGk";
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  self.firstView.frame = self.view.frame;
  self.lastView.frame = self.view.frame;
  self.firstView.hidden = NO;
  self.lastView.hidden = YES;

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
  self.lastView.hidden = NO;
  CGRect frame = self.lastView.frame;
  frame.origin.x = frame.size.width;
  self.lastView.frame = frame;
  [UIView animateWithDuration:0.4 animations:^{
    CGRect frame = self.view.frame;
    frame.origin.x = -frame.size.width;
    self.firstView.frame = frame;

    frame = self.view.frame;
    frame.origin.x = 0;
    self.lastView.frame = frame;
  } completion: ^(BOOL finished) {
    [self connectAction];
  }];
}

// MARK: - TV

- (void)prepareLocalMedia {
  if (!self.localAudioTrack) {
    self.localAudioTrack = [TVILocalAudioTrack trackWithOptions:nil enabled:YES];
    if (!self.localAudioTrack) {
      NSLog(@"Failed to add audio track");
    }
  }
  if (!self.localVideoTrack) {
    [self startPreview];
  }
}

- (void)startPreview {
  self.camera = [[TVICameraCapturer alloc] initWithSource:TVICameraCaptureSourceFrontCamera delegate:self];
//  self.localVideoTrack = [TVILocalVideoTrack trackWithCapturer:self.camera enabled:YES constraints:nil];
//  if (!self.localVideoTrack) {
//    NSLog(@"Failed to add video track");
//  }
}

- (void)connectAction {
  if ([self.userTextField.text isEqualToString:@"user1"]) {
    self.accessToken = self.user1Token;
  } else if ([self.userTextField.text isEqualToString:@"user2"]) {
    self.accessToken = self.user2Token;
  }
  if (self.accessToken == nil) {
    return;
  }
  [self prepareLocalMedia];

  TVIConnectOptions *connectOptions = [TVIConnectOptions optionsWithToken:self.accessToken block:^(TVIConnectOptionsBuilder * _Nonnull builder) {
                                                                      builder.audioTracks = self.localAudioTrack ? @[ self.localAudioTrack ] : @[ ];
                                                                      builder.videoTracks = self.localVideoTrack ? @[ self.localVideoTrack ] : @[ ];
                                                                      builder.roomName = @"test";
                                                                    }];
  self.room = [TwilioVideo connectWithOptions:connectOptions delegate:self];
}

- (void)endAction {
  [self.room disconnect];
  self.userTextField.text = nil;
  [self.containerView expandIntoView:nil finished:nil];
  self.overlayView.hidden = YES;
}

- (void)cleanupRemoteParticipant {
  if (self.participant) {
    if ([self.participant.videoTracks count] > 0) {
      TVIVideoTrack *videoTrack = self.participant.videoTracks[0];
      [videoTrack removeRenderer:self.remoteView];
      [self.remoteView removeFromSuperview];
    }
    self.participant = nil;
  }
}

#pragma mark - TVIRoomDelegate

- (void)didConnectToRoom:(TVIRoom *)room {

  if (room.participants.count > 0) {
    self.participant = room.participants[0];
    self.participant.delegate = self;
  }
}

- (void)room:(TVIRoom *)room didDisconnectWithError:(nullable NSError *)error {
  [self cleanupRemoteParticipant];
  self.room = nil;
}

- (void)room:(TVIRoom *)room didFailToConnectWithError:(nonnull NSError *)error{
  self.room = nil;
}

- (void)room:(TVIRoom *)room participantDidConnect:(TVIParticipant *)participant {
  if (!self.participant) {
    self.participant = participant;
    self.participant.delegate = self;
  }
}

- (void)room:(TVIRoom *)room participantDidDisconnect:(TVIParticipant *)participant {
  if (self.participant == participant) {
    [self cleanupRemoteParticipant];
  }
}

#pragma mark - TVIRemoteParticipantDelegate

- (void)participant:(TVIParticipant *)participant addedVideoTrack:(TVIVideoTrack *)videoTrack {
  if (self.participant == participant) {
//    [self setupRemoteView];
    [videoTrack addRenderer:self.remoteView];
  }
}

- (void)participant:(TVIParticipant *)participant removedVideoTrack:(TVIVideoTrack *)videoTrack {
  if (self.participant == participant) {
    [videoTrack removeRenderer:self.remoteView];
//    [self.remoteView removeFromSuperview];
  }
}

#pragma mark - TVIVideoViewDelegate

- (void)videoView:(TVIVideoView *)view videoDimensionsDidChange:(CMVideoDimensions)dimensions {
  NSLog(@"Dimensions changed to: %d x %d", dimensions.width, dimensions.height);
  [self.view setNeedsLayout];
}

#pragma mark - TVICameraCapturerDelegate

- (void)cameraCapturer:(TVICameraCapturer *)capturer didStartWithSource:(TVICameraCaptureSource)source {
//  self.previewView.mirror = (source == TVICameraCaptureSourceFrontCamera);
}

@end
