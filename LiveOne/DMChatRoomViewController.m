//
//  DMChatRoomViewController.m
//  chatDemo
//
//  Created by David Mendels on 4/14/12.
//  Copyright (c) 2012 Cognoscens. All rights reserved.
//

#import "DMChatRoomViewController.h"
#import "UIViewController+MaryPopin.h"
#import "YoutubeViewController.h"
#import "WebViewController.h"
#import "DateTools.h"
#import <XCDYouTubeKit/XCDYouTubeKit.h>




#define TABBAR_HEIGHT 49.0f
#define TEXTFIELD_HEIGHT 70.0f
#define MAX_ENTRIES_LOADED 1000

@interface DMChatRoomViewController ()
{
    
}
@property (nonatomic) BOOL isCurrentlyFetching;
@property (nonatomic, strong) NSMutableArray* mutArray;
@property (nonatomic, strong) UIImageView *imageRight;
@property (nonatomic, strong) VideoTableViewCell *cell;
@end

@implementation DMChatRoomViewController
@synthesize tfEntry;
@synthesize chatTable;
@synthesize chatData;

BOOL isShowingAlertView = NO;
BOOL isFirstShown = YES;
BOOL isFavorite = YES;
BOOL textEditing = NO;
BOOL isShouldReturn = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHide:)
                                                 name:@"KeyboardHide" object:nil];
    
    self.mutArray = [[NSMutableArray alloc] init];
    
    [chatTable setFrame:CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    
    
    chatTable.transform = CGAffineTransformMakeScale (1,-1);
    
    chatTable.rowHeight = UITableViewAutomaticDimension;
    chatTable.estimatedRowHeight = 70.0;
	
    tfEntry.delegate = self;
    tfEntry.clearButtonMode = UITextFieldViewModeWhileEditing;
	
    [tfEntry setKeyboardAppearance:UIKeyboardAppearanceAlert];
    [tfEntry addTarget:self
                  action:@selector(tfDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    //[self reloadTableViewDataSource];
    
    [self registerForKeyboardNotifications];
    

    
    NSString *videoIdentifier = @"L8_9bxgyPhM"; // A 11 characters YouTube video identifier
    [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:videoIdentifier completionHandler:^(XCDYouTubeVideo *video, NSError *error) {
        if (video)
        {
            UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
            NSURL *url = [video.streamURLs objectForKey:@(XCDYouTubeVideoQualitySmall240)];
            self.playerVideo = [[VKVideoPlayer alloc] init];
            self.playerVideo.volume =  0.0;
            self.playerVideo.view.frame = view.bounds;
            self.playerVideo.playerControlsEnabled = NO;
            self.playerVideo.view.playerControlsAutoHideTime = @0;
            VKVideoPlayerTrack *track = [[VKVideoPlayerTrack alloc] initWithStreamURL:url];
            
            
            track.hasNext = YES;
            [self.playerVideo loadVideoWithTrack:track];
            [self.playerVideo playContent];
            view.hidden = YES;
            [self.view addSubview:view];
        }
    }];
    
    videoIdentifier = @"LIYeHCFttMc";
    [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:videoIdentifier completionHandler:^(XCDYouTubeVideo *video, NSError *error) {
        if (video)
        {
            UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
            NSURL *url = [video.streamURLs objectForKey:@(XCDYouTubeVideoQualitySmall240)];
            self.playerVideo = [[VKVideoPlayer alloc] init];
            self.playerVideo.volume =  0.0;
            self.playerVideo.view.frame = view.bounds;
            self.playerVideo.playerControlsEnabled = NO;
            self.playerVideo.view.playerControlsAutoHideTime = @0;
            VKVideoPlayerTrack *track = [[VKVideoPlayerTrack alloc] initWithStreamURL:url];
            
            
            track.hasNext = YES;
            [self.playerVideo loadVideoWithTrack:track];
            [self.playerVideo playContent];
            view.hidden = YES;
            [self.view addSubview:view];
        }
    }];
    
}


-(void) keyboardWasHide:(id) sender {
    NSLog(@"--message--");
    _bottomKeyboard.constant = 0;
}

-(void)dealloc
{
   
}


- (void)tfDidChange:(id)sender {
       //[_imageRight setImage:[UIImage imageNamed:@"fillmessages"]];
}

// Add a delegate method to handle the tap and do something with it.
-(void)handleTap:(UITapGestureRecognizer *)sender
{
    
    [tfEntry becomeFirstResponder];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //if (self.videoPlayerViewController==nil) {
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network"
														message:[self stringFromStatus: status]
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
            [alert show];
        }
        className = @"chatroom1";

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        userName = [defaults stringForKey:@"chatName"];
        if ([userName isEqualToString:@"Chat Name"]) {
            [self presentChatNameDialog];
        }
        chatData  = [[NSMutableArray alloc] init];
    
    
    
        //[tfEntry setFrame:CGRectMake(0, self.view.frame.size.height-15, tfEntry.frame.size.width, tfEntry.frame.size.height)];
    
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 40)];
        tfEntry.leftView = paddingView;
        tfEntry.leftViewMode = UITextFieldViewModeAlways;
    
        
        UIView *paddingRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    
        _imageRight = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 5, 20, 30)];
    
        [_imageRight setImage:[UIImage imageNamed:@"message"]];
    
        _imageRight.contentMode = UIViewContentModeScaleAspectFit;
    
        //[paddingRightView addSubview:_imageRight];
        //tfEntry.rightView = paddingRightView;
        //tfEntry.rightViewMode = UITextFieldViewModeAlways;
    
        paddingRightView.userInteractionEnabled = YES;
    
        UITapGestureRecognizer *tapPR;
        tapPR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapPR:)];
        tapPR.numberOfTapsRequired = 1;
        [paddingRightView addGestureRecognizer:tapPR];
    
	UIColor *color = [UIColor grayColor];
  
        tfEntry.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Say something…" attributes:@{NSForegroundColorAttributeName: color}];
        [tfEntry setReturnKeyType:UIReturnKeySend];
    

        [self loadLocalChat];
    //}

}


-(void) resignResponder:(id)sender {
    
    if (textEditing==YES) {
       
    }
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    [self freeKeyboardNotifications];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Chat textfield



-(IBAction) textFieldDoneEditing : (id) sender
{
    textEditing = NO;
}

-(IBAction) backgroundTap:(id) sender
{
     textEditing = NO;
}


- (void) textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"editing");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
 
    
    NSLog(@"ok");
    
    
    if (tfEntry.text.length>0) {
        
        NSLog(@"should return");
        // updating the table immediately
        NSArray *keys = [NSArray arrayWithObjects:@"text", @"userName", @"date", @"count", @"replies", nil];
        NSArray *objects = [NSArray arrayWithObjects:tfEntry.text, userName, [NSDate date], @"0", @"0", nil];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        [chatData addObject:dictionary];
        
        NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [insertIndexPaths addObject:newPath];
        [chatTable beginUpdates];
        [chatTable insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
        [chatTable endUpdates];
        [chatTable reloadData];
        
        // going for the parsing
        PFObject *newMessage = [PFObject objectWithClassName:@"chatroom1"];
        [newMessage setObject:tfEntry.text forKey:@"text"];
        [newMessage setObject:userName forKey:@"userName"];
        [newMessage setObject:[NSDate date] forKey:@"date"];
        [newMessage setObject:@"0" forKey:@"count"];
        [newMessage setObject:@"0" forKey:@"replies"];
        [newMessage saveInBackground];
        
        tfEntry.text = @"";
        textEditing = NO;
        
        // reload the data
        [self loadLocalChat];
    }

    return NO;
}


-(void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


-(void) freeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


-(void) keyboardWasShown:(NSNotification*)aNotification
{
    NSLog(@"Keyboard was shown");
    textEditing=YES;
    NSDictionary* info = [aNotification userInfo];
    

    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
//    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
	[[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];

    
    
    // Move
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    NSLog(@"frame..%f..%f..%f..%f",self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    NSLog(@"keyboard..%f..%f..%f..%f",keyboardFrame.origin.x, keyboardFrame.origin.y, keyboardFrame.size.width, keyboardFrame.size.height);
    
    if ([UIScreen mainScreen].bounds.size.width>375) {
        _bottomKeyboard.constant = keyboardFrame.size.height;
    }
    
    
    [self.view layoutIfNeeded];
    [chatTable scrollsToTop];
    [UIView commitAnimations];
    
    
}

-(void) keyboardWillHide:(NSNotification*)aNotification
{
    NSLog(@"Keyboard will hide");
    NSDictionary* info = [aNotification userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    // Move
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    _bottomKeyboard.constant = 0;
	
    [self.view layoutIfNeeded];

    [UIView commitAnimations];
}

#pragma mark - Parse

- (void)loadLocalChat
{
    PFQuery *query = [PFQuery queryWithClassName:className];
    
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([chatData count] == 0) {
        //if (_isCurrentlyFetching) { return; } // Bails if currently fetching
        _isCurrentlyFetching = YES;
        
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query orderByAscending:@"createdAt"];
        NSLog(@"Trying to retrieve from cache");
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
              
                [chatData removeAllObjects];
                [chatData addObjectsFromArray:objects];
                [chatTable reloadData];
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            _isCurrentlyFetching = NO;
        }];
    } else {
    
    
    __block int totalNumberOfEntries = 0;
    [query orderByAscending:@"createdAt"];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            // The count request succeeded. Log the count
            NSLog(@"There are currently %d entries", number);
            totalNumberOfEntries = number;
            if (totalNumberOfEntries > [chatData count]) {
                NSLog(@"Retrieving data");
                int theLimit;
                if (totalNumberOfEntries-[chatData count]>MAX_ENTRIES_LOADED) {
                    theLimit = MAX_ENTRIES_LOADED;
                }
                else {
                    theLimit = totalNumberOfEntries-[chatData count];
                }
                query.limit = theLimit;
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        // The find succeeded.
                        NSLog(@"Successfully retrieved %lu chats.", (unsigned long)objects.count);
                        [chatData addObjectsFromArray:objects];
                        NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
                        for (int ind = 0; ind < objects.count; ind++) {
                            NSIndexPath *newPath = [NSIndexPath indexPathForRow:ind inSection:0];
                            [insertIndexPaths addObject:newPath];
                        } 
                        [chatTable beginUpdates];
                        [chatTable insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
                        [chatTable endUpdates];
                        [chatTable reloadData];
                        [chatTable scrollsToTop];
                    } else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
            
        } else {
            // The request failed, we'll keep the chatData count?
            number = [chatData count];
        }
    }];
    }
}


#pragma mark - Table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"chatdata %lu", (unsigned long)[chatData count]);
	return [chatData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
         if ((indexPath.row+1)==15) {
            adTableViewCell *cell = (adTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"adTableViewCell"];
            
            
            [tableView registerNib:[UINib nibWithNibName:@"adTableViewCell" bundle:nil] forCellReuseIdentifier:@"adTableViewCell"];
            cell = (adTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"adTableViewCell"];
            
            cell.contentView.transform = CGAffineTransformMakeScale (1,-1);
            [cell.image setImage:[UIImage imageNamed:@"adFanDuel"]];
            return cell;
             
         }  else if ((indexPath.row+1)==10) {
             VideoTableViewCell *cell = (VideoTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"VideoTableViewCell"];
             
             
             
             
             [tableView registerNib:[UINib nibWithNibName:@"VideoTableViewCell" bundle:nil] forCellReuseIdentifier:@"videoTableViewCell"];
             cell = (VideoTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"videoTableViewCell"];
             cell.contentView.transform = CGAffineTransformMakeScale (1,-1);
             
             NSString *videoIdentifier = @"rfWutt9mZhg"; // A 11 characters YouTube video identifier
             [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:videoIdentifier completionHandler:^(XCDYouTubeVideo *video, NSError *error) {
                 if (video)
                 {
                     NSURL *url = [video.streamURLs objectForKey:@(XCDYouTubeVideoQualitySmall240)];
                     self.playerVideo = [[VKVideoPlayer alloc] init];
                     
                     
                     self.playerVideo.volume =  0.0;
                     self.playerVideo.view.frame = cell.view.bounds;
                     self.playerVideo.playerControlsEnabled = NO;
                     self.playerVideo.view.playerControlsAutoHideTime = @0;
                     [cell.view addSubview:self.playerVideo.view];
                     
                     UIView *tapView = [[UIView alloc] initWithFrame:_playerVideo.view.bounds];
                     tapView.backgroundColor = [UIColor clearColor];
                     
                     tapView.userInteractionEnabled = YES;
                     tapView.tag=1;
                     
                     [cell.view addSubview:tapView];
                     
                     _cell = cell;
                     
                     UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnVideo:) ];
                     
                     tapGesture.numberOfTapsRequired = 1;
                     
                     
                     [tapView addGestureRecognizer:tapGesture];
                     
                     _tapView = tapView;
                     
                     _urlForVideo = url;
                     VKVideoPlayerTrack *track = [[VKVideoPlayerTrack alloc] initWithStreamURL:url];
                     
                     
                     track.hasNext = YES;
                     [self.playerVideo loadVideoWithTrack:track];
                     
                     [self.playerVideo pauseContent];
                     
                     
                     
                 }
                 else
                 {
                     // Handle error
                 }
             }];
             
             return cell;
             
        } else if ((indexPath.row+1)==20) {
            VideoTableViewCell *cell = (VideoTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"VideoTableViewCell"];
            
            
            
            
            [tableView registerNib:[UINib nibWithNibName:@"VideoTableViewCell" bundle:nil] forCellReuseIdentifier:@"videoTableViewCell"];
            cell = (VideoTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"videoTableViewCell"];
            cell.contentView.transform = CGAffineTransformMakeScale (1,-1);
            
            NSString *videoIdentifier = @"LIYeHCFttMc"; // A 11 characters YouTube video identifier
            [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:videoIdentifier completionHandler:^(XCDYouTubeVideo *video, NSError *error) {
                if (video)
                {
                    NSURL *url = [video.streamURLs objectForKey:@(XCDYouTubeVideoQualitySmall240)];
                    self.playerVideo = [[VKVideoPlayer alloc] init];
                    
                    
                    self.playerVideo.volume =  0.0;
                    self.playerVideo.view.frame = cell.view.bounds;
                    self.playerVideo.playerControlsEnabled = NO;
                    self.playerVideo.view.playerControlsAutoHideTime = @0;
                    [cell.view addSubview:self.playerVideo.view];
                    
                    UIView *tapView = [[UIView alloc] initWithFrame:_playerVideo.view.bounds];
                    tapView.backgroundColor = [UIColor clearColor];
                    
                    tapView.userInteractionEnabled = YES;
                    tapView.tag=1;
                    
                    [cell.view addSubview:tapView];
                    
                    _cell = cell;
                    
                    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnVideo:) ];
                    
                    tapGesture.numberOfTapsRequired = 1;
                    
                    
                    [tapView addGestureRecognizer:tapGesture];
                    
                    _tapView = tapView;
                    
                    _urlForVideo = url;
                    VKVideoPlayerTrack *track = [[VKVideoPlayerTrack alloc] initWithStreamURL:url];
                    
                    
                    track.hasNext = YES;
                    [self.playerVideo loadVideoWithTrack:track];
                    
                    [self.playerVideo pauseContent];

                    
                 
                }
                else
                {
                    // Handle error
                }
            }];
            
            return cell;
          
        } else if ((indexPath.row+1)==30) {
            adTableViewCell *cell = (adTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"adTableViewCell"];
            
            
            [tableView registerNib:[UINib nibWithNibName:@"adTableViewCell" bundle:nil] forCellReuseIdentifier:@"adTableViewCell"];
            cell = (adTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"adTableViewCell"];
             [cell.image setImage:[UIImage imageNamed:@"adXbox"]];
            cell.contentView.transform = CGAffineTransformMakeScale (1,-1);
            return cell;
            
        } else {
        
            chatCell *cell = (chatCell *)[self.chatTable dequeueReusableCellWithIdentifier: @"chatCellIdentifier"];

        [tableView registerNib:[UINib nibWithNibName:@"chatCell" bundle:nil] forCellReuseIdentifier:@"chatCellIdentifier"];
    
    
        cell = (chatCell *)[self.chatTable dequeueReusableCellWithIdentifier: @"chatCellIdentifier"];

    
            
            
        cell.contentView.transform = CGAffineTransformMakeScale (1,-1);
        
        NSUInteger row = [chatData count]-[indexPath row]-1;
    
    
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
   
    
        if (row < chatData.count){
            NSString *chatText = [[chatData objectAtIndex:row] objectForKey:@"text"];
        
            chatText = [chatText stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
            UIFont *font = [UIFont systemFontOfSize:14.0];
            NSAttributedString *attributedText =
            [[NSAttributedString alloc] initWithString:chatText
                                        attributes:@{NSFontAttributeName:font}];
       
        
        
            //cell.textString.font = [UIFont systemFontOfSize:14.0];
            cell.textString.text = chatText;
            cell.textString.textColor = [UIColor whiteColor];
        
            cell.textString.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGR;
            tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap1:)];
            tapGR.numberOfTapsRequired = 1;
            [cell.textString addGestureRecognizer:tapGR];
        
        
    
            //[cell.textString sizeToFit];
            NSDate *theDate = [[chatData objectAtIndex:row] objectForKey:@"date"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mma"];
            NSString *timeString = [theDate timeAgoSinceNow];
            
            NSString *userName = [[chatData objectAtIndex:row] objectForKey:@"userName"];
            
            if (userName == nil) {
                userName = @"Demo";
            }
            else {
                userName = [userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            
            cell.userLabel.text = userName;
            
            NSArray *nameArray = [userName componentsSeparatedByString:@" "];
            if ([nameArray count]>1) {
                
                NSString *firstName = [nameArray[0] length] > 0 ? nameArray[0] : @"";
                NSString *secondName = [nameArray[1] length] > 0 ? nameArray[1] : @"";
                
                NSString *first = @"";
                if ([firstName length] > 0) {
                    first = [firstName substringToIndex:1];
                }
                
                NSString *second = @"";
                if ([secondName length] > 0) {
                    second = [secondName substringToIndex:1];
                }
                [cell.nameButton setTitle:[[first uppercaseString] stringByAppendingString:[second uppercaseString]]  forState:UIControlStateNormal];
            } else if ([nameArray count]>0) {
                NSString *first = [nameArray[0] length] > 0 ? nameArray[0] : @"";
                
                if ([first length] > 0) {
                    [cell.nameButton setTitle:[[first uppercaseString] substringToIndex:1]  forState:UIControlStateNormal];
                }
            }
        
            [cell.userLabel sizeToFit];
            if ([[[chatData objectAtIndex:row] objectForKey:@"count"] isEqual:@""]) {
            cell.votevalue.text =@"0";
            } else {
            cell.votevalue.text = [[chatData objectAtIndex:row] objectForKey:@"count"];
            }
        
            cell.timeLabel.text = timeString;
            cell.timeLabel.frame = CGRectMake(cell.userLabel.frame.size.width+35, cell.timeLabel.frame.origin.y, cell.timeLabel.frame.size.width, cell.timeLabel.frame.size.height);
        
        
            cell.voteplus.tag = row;
            cell.voteminus.tag = row;
        
            [cell.voteplus addTarget:self
                          action:@selector(addPlusAction:)
           forControlEvents:UIControlEventTouchUpInside];
        
            [cell.voteminus addTarget:self
                          action:@selector(addMinusAction:)
                forControlEvents:UIControlEventTouchUpInside];
        
   
        
            cell.viewFavorites.tag = row;
            cell.starButton.tag = indexPath.row;
        
            [cell.starButton addTarget:self
                            action:@selector(handleTap2:)
                  forControlEvents:UIControlEventTouchUpInside];
        
        
        
            __weak UILabel *favotiteValue = cell.favoriteValue;
        
      
        
            if ([self.mutArray containsObject:@(row)]) {
           
                [cell.starButton setImage:[UIImage imageNamed:@"star-active"] forState:UIControlStateNormal];
                favotiteValue.textColor = [UIColor colorWithRed:241.0/255.0 green:170.0/255.0 blue:68.0/255.0 alpha:1.0];
            }
        
            if (isFavorite==YES) {
                CGRect rect = [attributedText boundingRectWithSize:(CGSize){((screenWidth*45.0)/100.0)-50.0, CGFLOAT_MAX}
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
                CGSize labelSize = rect.size;
            
            
                cell.textString.frame = CGRectMake(10, 25, ((screenWidth*45.0)/100.0)-50, labelSize.height+30);
            
            
                cell.valuesBlock.frame = CGRectMake(cell.valuesBlock.frame.origin.x, cell.textString.frame.size.height+15, cell.valuesBlock.frame.size.width, cell.valuesBlock.frame.size.height);
                cell.valuesBlock.hidden=YES;
                cell.viewFavorites.hidden=NO;
                cell.viewFavorites.frame = CGRectMake(((screenWidth*45.0)/100.0)-50, cell.viewFavorites.frame.origin.y, cell.viewFavorites.frame.size.width, cell.viewFavorites.frame.size.height);
            
                cell.favoriteValue.text = cell.votevalue.text;
            
            } else {
                CGRect rect = [attributedText boundingRectWithSize:(CGSize){((screenWidth*45.0)/100.0)-10.0, CGFLOAT_MAX}
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
                CGSize labelSize = rect.size;
         
                cell.textString.frame = CGRectMake(10, 25, ((screenWidth*45.0)/100.0)-10, labelSize.height+30);

                cell.valuesBlock.frame = CGRectMake(cell.valuesBlock.frame.origin.x, cell.textString.frame.size.height+15, cell.valuesBlock.frame.size.width, cell.valuesBlock.frame.size.height);
                cell.valuesBlock.hidden=YES;
                cell.viewFavorites.hidden=NO;
            }
            
        }
            
            return cell;
    }
    
}


-(void) tapOnVideo:(UITapGestureRecognizer*) sender {

        
        [_player pauseContent];
        
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        YoutubeViewController *mediaViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"youtubeViewController"];
        
        
        
        [mediaViewController setPopinTransitionStyle:BKTPopinTransitionStyleCrossDissolve];
        
        //Add options
        [mediaViewController setPopinOptions:BKTPopinDefault];
        
        
        [mediaViewController setPopinAlignment:BKTPopinAlignementOptionCentered];
        
        //Create a blur parameters object to configure background blur
        BKTBlurParameters *blurParameters = [BKTBlurParameters new];
        blurParameters.alpha = 1.0f;
        blurParameters.radius = 8.0f;
        blurParameters.saturationDeltaFactor = 1.8f;
        blurParameters.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
        [mediaViewController setBlurParameters:blurParameters];
        
        //Add option for a blurry background
        [mediaViewController  setPopinOptions:[mediaViewController popinOptions]|BKTPopinBlurryDimmingView];
        
        mediaViewController.player = _player;
        
        mediaViewController.urlForVideo = _urlForVideo;
        mediaViewController.playerVideo = _playerVideo;
        mediaViewController.cell = _cell;
        mediaViewController.tapView = _tapView;
        
        [self.navigationController presentPopinController:mediaViewController animated:YES completion:^{
            
        }];
}


-(void) handleTapPR:(UIView*) sender {
    
}

- (void) handleTap2:(UIButton*) sender {
    
    NSUInteger row = [chatData count]-sender.tag-1;
    
    PFObject *object = [chatData objectAtIndex:row];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *flag = [defaults objectForKey:[NSString stringWithFormat:@"%ld", (long)sender.tag]];
    
    if (![flag isEqual:@"1"]) {
    
        [defaults setObject:@"1" forKey:[NSString stringWithFormat:@"%ld", (long)sender.tag]];
        [defaults synchronize];
    
        NSInteger count = [[object objectForKey:@"count"] integerValue];
    
        if ([[object  objectForKey:@"count"] isEqual:@""]) {
            count = 0;
        }
    
        count++;
    
        [self.mutArray addObject:@(row)];
    
        [object setObject:[NSString stringWithFormat: @"%ld", (long)count] forKey:@"count"];
        [object saveInBackground];
        [self reloadTableViewDataSource];
    }
}

- (void) handleTap1:(id) sender {
  
}
- (void) addPlusAction:(UIButton*) sender {
    
   
    PFObject *object = [chatData objectAtIndex:sender.tag];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *flag = [defaults objectForKey:[NSString stringWithFormat:@"%ld", (long)sender.tag]];
    
    if (![flag isEqual:@"1"]) {
        [defaults setObject:@"1" forKey:[NSString stringWithFormat:@"%ld", (long)sender.tag]];
        [defaults synchronize];

        NSInteger count = [[object objectForKey:@"count"] integerValue];
    
        if ([[object  objectForKey:@"count"] isEqual:@""]) {
            count = 0;
        }
    
  
        count++;
        [object setObject:[NSString stringWithFormat: @"%ld", (long)count] forKey:@"count"];
        [object saveInBackground];
        [self reloadTableViewDataSource];
    }
}


- (void) addMinusAction:(UIButton*) sender {
 
    PFObject *object = [chatData objectAtIndex:sender.tag];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *flag = [defaults objectForKey:[NSString stringWithFormat:@"%ld", (long)sender.tag]];
    
    if (![flag isEqual:@"1"]) {
        [defaults setObject:@"1" forKey:[NSString stringWithFormat:@"%ld", (long)sender.tag]];
        [defaults synchronize];
    
        NSInteger count = [[object objectForKey:@"count"] integerValue];
        if ([[object  objectForKey:@"count"] isEqual:@""]) {
            count = 0;
        }
    
        count--;
        [object setObject:[NSString stringWithFormat: @"%ld", (long)count] forKey:@"count"];
        [object saveInBackground];
        [self reloadTableViewDataSource];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    
    
    if (((indexPath.row+1)==10) || ((indexPath.row+1)==15) || ((indexPath.row+1)==20) || ((indexPath.row+1)==30)) {
        if (((indexPath.row+1)==10) || ((indexPath.row+1)==20)) {
            return 200.0f;
        } else if ((indexPath.row+1)==15) {
            if (screenRect.size.width<560.0f) {
                return 50.0f;
            } else if (screenRect.size.width<570.0f) {
                return 55.0f;
            } else {
                return 70.f;
            }
        } else {
            return 90.f;
        }
    } else {
        return UITableViewAutomaticDimension;
    }
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
	_reloading = YES;
    [self loadLocalChat];
	[chatTable reloadData];
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
    //[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:chatTable];
    
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

#pragma mark - Connections
- (NSString *)stringFromStatus:(NetworkStatus ) status {
	NSString *string; switch(status) {
		case NotReachable:
			string = @"You are not connected to the internet";
			break;
		case ReachableViaWiFi:
			string = @"Reachable via WiFi";
			break;
		case ReachableViaWWAN:
			string = @"Reachable via WWAN";
			break;
		default:
            string = @"Unknown connection";
            break;
	}
	return string;
}


#pragma mark - Chat name dialog
-(void)presentChatNameDialog
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chat Name"
                                                      message:@"Choose a chat name, it can be changed later in the Options panel"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Continue", nil];
    
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    //    [message setBackgroundColor:[UIColor colorWithRed:0.7765f green:0.1725f blue:0.1451f alpha:1.0f]];
    //    [message setAlpha:0.8f];
    [message show];
    isShowingAlertView = YES;
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSLog(@"Plain text input: %@",textField.text);
        userName = textField.text;
        [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"chatName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        isShowingAlertView = NO;
    }
    else if (isFirstShown){
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Ooops" 
                              message:@"Something's gone wrong. To post in this room you must have a chat name. Go to the options panel to define one" 
                              delegate:self 
                              cancelButtonTitle:nil
                              otherButtonTitles:@"Dismiss", nil];
        [alert show];
        isFirstShown = NO;
    }
    [chatTable setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tfEntry resignFirstResponder];
    textEditing = NO;
    

    
    
    
    if (((indexPath.row+1)==10) || ((indexPath.row+1)==15) || ((indexPath.row+1)==30)) {
          
          
          [_player pauseContent];
          
          
         UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
          
          YoutubeViewController *mediaViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"youtubeViewController"];
          
          
        
          [mediaViewController setPopinTransitionStyle:BKTPopinTransitionStyleCrossDissolve];
          
          //Add options
          [mediaViewController setPopinOptions:BKTPopinDefault];
          
          
          [mediaViewController setPopinAlignment:BKTPopinAlignementOptionCentered];
          
          //Create a blur parameters object to configure background blur
          BKTBlurParameters *blurParameters = [BKTBlurParameters new];
          blurParameters.alpha = 1.0f;
          blurParameters.radius = 8.0f;
          blurParameters.saturationDeltaFactor = 1.8f;
          blurParameters.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
          [mediaViewController setBlurParameters:blurParameters];
          
          //Add option for a blurry background
          [mediaViewController  setPopinOptions:[mediaViewController popinOptions]|BKTPopinBlurryDimmingView];
          
          mediaViewController.player = _player;
          
         

          
          if ((indexPath.row+1)==15) {
              
              
             
              
              WebViewController *mediaViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"webViewController"];
              
              
              [mediaViewController setUrl:[NSURL URLWithString:@"https://www.fanduel.com/"]];
              
              
              [mediaViewController setPopinTransitionStyle:BKTPopinTransitionStyleCrossDissolve];
              
              
              //Add options
              [mediaViewController setPopinOptions:BKTPopinDefault];
              
              
              [mediaViewController setPopinAlignment:BKTPopinAlignementOptionCentered];
              
              
              
              //Create a blur parameters object to configure background blur
              BKTBlurParameters *blurParameters = [BKTBlurParameters new];
              blurParameters.alpha = 1.0f;
              blurParameters.radius = 8.0f;
              blurParameters.saturationDeltaFactor = 1.8f;
              blurParameters.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
              
              //Add option for a blurry background
              [mediaViewController  setPopinOptions:[mediaViewController popinOptions]|BKTPopinBlurryDimmingView];
              
              mediaViewController.player = _player;
              
              [self.navigationController presentPopinController:mediaViewController animated:YES completion:^{
                  
              }];
          }
          
          
        if ((indexPath.row+1)==30) {
            
            
            
            
            WebViewController *mediaViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"webViewController"];
            
            
            [mediaViewController setUrl:[NSURL URLWithString:@"https://www.xbox.com./"]];
            
            
            [mediaViewController setPopinTransitionStyle:BKTPopinTransitionStyleCrossDissolve];
            
            
            //Add options
            [mediaViewController setPopinOptions:BKTPopinDefault];
            
            
            [mediaViewController setPopinAlignment:BKTPopinAlignementOptionCentered];
            
            
            
            //Create a blur parameters object to configure background blur
            BKTBlurParameters *blurParameters = [BKTBlurParameters new];
            blurParameters.alpha = 1.0f;
            blurParameters.radius = 8.0f;
            blurParameters.saturationDeltaFactor = 1.8f;
            blurParameters.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
            
            //Add option for a blurry background
            [mediaViewController  setPopinOptions:[mediaViewController popinOptions]|BKTPopinBlurryDimmingView];
            
            mediaViewController.player = _player;
            
            [self.navigationController presentPopinController:mediaViewController animated:YES completion:^{
                
            }];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (((indexPath.row+1)==5) || ((indexPath.row+1)==20)) {
        [self.playerVideo playContent];
    }
}

- (void)tableView:(UITableView * _Nonnull)tableView
didEndDisplayingCell:(UITableViewCell * _Nonnull)cell
forRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
    if (((indexPath.row+1)==5) || ((indexPath.row+1)==20)) {
       [self.playerVideo pauseContent];
    }
}



@end
