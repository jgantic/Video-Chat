//
//  ViewController.m
//  LiveOne
//
//  Created by Александр on 06.08.15.
//  Copyright (c) 2015 Remi Development. All rights reserved.
//

#import "UIViewController+AddChild.h"

@implementation UIViewController (AddChild)

- (void)addChildController:(UIViewController*)childController toView:(UIView*)view {
    [childController willMoveToParentViewController:self];
    
    childController.view.frame = view.bounds;
    
    [view addSubview:childController.view];
    [self addChildViewController:childController];
    
    [childController didMoveToParentViewController:self];
}

@end
