//
//  ViewController.h
//  LiveOne
//
//  Created by Александр on 06.08.15.
//  Copyright (c) 2015 Remi Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AddChild)

- (void)addChildController:(UIViewController*)childController toView:(UIView*)view;

@end
