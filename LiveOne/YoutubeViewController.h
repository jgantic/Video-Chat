//
//  YoutubeViewController.h
//  LiveOne
//
//  Created by Александр on 17.09.15.
//  Copyright © 2015 Remi Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKVideoPlayer.h"
#import "VideoTableViewCell.h"
#import "DMChatRoomViewController.h"

@interface YoutubeViewController : UIViewController <VKVideoPlayerDelegate>
@property (nonatomic, strong) VKVideoPlayer* player;
@property (nonatomic, strong) VKVideoPlayer* playerVideo;
@property (nonatomic, strong) NSURL *urlForVideo;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) VideoTableViewCell *cell;
@property (nonatomic, strong) UIView *tapView;
@end
