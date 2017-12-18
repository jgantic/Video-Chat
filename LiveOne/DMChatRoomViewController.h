//
//  DMChatRoomViewController.h
//  chatDemo
//
//  Created by David Mendels on 4/14/12.
//  Copyright (c) 2012 Cognoscens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse.h"
#import "chatCell.h"
#import "adTableViewCell.h"
#import "VideoTableViewCell.h"
#import "Reachability.h"
#import "VKVideoPlayer.h"


@interface DMChatRoomViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, VKVideoPlayerDelegate>
{
    UITextField             *tfEntry;
    IBOutlet UITableView    *chatTable;
	NSMutableArray          *chatData;
    BOOL                    _reloading;
    NSString                *className;
    NSString                *userName;
}

@property(nonatomic, strong) IBOutlet UITextField *tfEntry;
@property (nonatomic, retain) UITableView *chatTable;
@property (nonatomic, retain) NSMutableArray *chatData;
@property (nonatomic, strong) VKVideoPlayer* player;
@property (nonatomic, strong) VKVideoPlayer* playerVideo;
@property (nonatomic, strong) NSURL *urlForVideo;
@property (nonatomic, strong) VKVideoPlayerTrack *track;
@property (nonatomic, strong) UIView *tapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomKeyboard;

@property (strong, nonatomic) IBOutlet UIView *mainView;

-(void) registerForKeyboardNotifications;
-(void) freeKeyboardNotifications;
-(void) keyboardWasShown:(NSNotification*)aNotification;
-(void) keyboardWillHide:(NSNotification*)aNotification;
-(void) tapOnVideo:(UITapGestureRecognizer*) sender;
- (void)loadLocalChat;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfEntryBottomContants;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfEntryBottomContantsH;

- (NSString *)stringFromStatus:(NetworkStatus )status;
-(void)presentChatNameDialog;
@end
