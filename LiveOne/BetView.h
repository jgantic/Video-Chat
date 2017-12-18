//
//  BetView.h
//  LiveOne
//
//  Created by Александр Мазалецкий on 24.02.17.
//  Copyright © 2017 Remi Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BetView : UITableViewCell
@property (strong, nonatomic) IBOutlet BetView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImage;

@end
