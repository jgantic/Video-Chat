//
//  MenuButton.h
//  SZZL
//
//  Created by Vasily Krainov on 03/04/2018.
//  Copyright © 2018 Remi Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuButton : UIView {
  UIButton *menuButton;
  NSMutableArray* buttons;
  BOOL expanded;
}

@property (readonly) CGRect buttonFrame;

- (id)initWithParentView:(UIView*)parentView;
- (void)addMenuButton:(UIButton*)button;
- (void)collapse;

@end
