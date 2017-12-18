//
//  ViewController.h
//  LiveOne
//
//  Created by Александр on 06.08.15.
//  Copyright (c) 2015 Remi Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>
#import "VKVideoPlayer.h"

@interface TwitterViewController : TWTRTimelineViewController <TWTRTweetViewDelegate>
@property (nonatomic, strong) VKVideoPlayer* player;
@end

