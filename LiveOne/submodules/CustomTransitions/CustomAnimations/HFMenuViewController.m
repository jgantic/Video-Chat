//
//  HFMenuViewController.m
//  CustomAnimations
//
//  Created by Gregory Klein on 11/13/13.
//  Copyright (c) 2013 HardFlip. All rights reserved.
//

#import "HFMenuViewController.h"
#import "HFOptionsViewController.h"
#import "HFAnimator.h"
#import "HFDynamicAnimator.h"

@interface HFMenuViewController ()

@end

@implementation HFMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   if ([segue.identifier isEqualToString:@"showOptions"])
   {
      HFOptionsViewController *optionsViewController =
         (HFOptionsViewController *)segue.destinationViewController;
      optionsViewController.transitioningDelegate = self;
      optionsViewController.modalPresentationStyle = UIModalPresentationCustom;
   }
}

//UIViewControllerTransitioningDelegate protocol methods

- (id <UIViewControllerAnimatedTransitioning>)
animationControllerForPresentedController:(UIViewController *)presented
                     presentingController:(UIViewController *)presenting
                         sourceController:(UIViewController *)source
{
   HFDynamicAnimator *animator = [HFDynamicAnimator new];
   animator.presenting = YES;
   return animator;
}

- (id <UIViewControllerAnimatedTransitioning>)
animationControllerForDismissedController:(UIViewController *)dismissed
{
   HFDynamicAnimator *animator = [HFDynamicAnimator new];
   return animator;
}


@end
