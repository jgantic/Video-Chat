//
//  TourTableViewController.h
//  LiveOne
//
//  Created by Александр on 23.08.15.
//  Copyright (c) 2015 Remi Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKVideoPlayer.h"

@interface TourTableViewController : UITableViewController {
    NSMutableArray *titles;
    NSMutableArray *subTitles;
    NSMutableArray *dateTitles;
    NSMutableArray *monthTitles;
}

@property (nonatomic, strong) VKVideoPlayer* player;
@property (nonatomic, strong) VKVideoPlayer* playerVideo;
@property (nonatomic, strong) NSString* headerString;
@end
