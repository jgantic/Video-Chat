//
//  MenuButton.m
//  SZZL
//
//  Created by Vasily Krainov on 03/04/2018.
//  Copyright © 2018 Remi Development. All rights reserved.
//

#import "MenuButton.h"

@implementation MenuButton

CGFloat startSize = 55;
CGFloat startGap = 6;
CGFloat size = 45;
CGFloat radius = 4;
CGFloat distance = 15;
CGFloat gap = 4;
CGFloat imageInset = 12;
UIColor *normalColor;

- (CGRect)buttonFrame
{
  CGRect result = self.frame;
  result.origin.y += result.size.height - result.size.width;
  result.size.height = result.size.width;
  return result;
}

- (id)initWithParentView:(UIView*)parentView
{
  self = [super init];

  normalColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];

  self.frame = CGRectMake(0, 0, startSize, startSize);
  self.backgroundColor = [UIColor clearColor];
  self.clipsToBounds = NO;
  buttons = [NSMutableArray array];
  menuButton = [[UIButton alloc] initWithFrame:self.bounds];
  [menuButton setImage:[UIImage imageNamed:@"menu-start.png"] forState:UIControlStateNormal];
  menuButton.layer.cornerRadius = radius;
  menuButton.clipsToBounds = YES;
  [menuButton addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:menuButton];

  return self;
}

- (void)layoutSubviews
{
  CGRect frame = self.frame;
  frame.origin.x = self.superview.frame.size.width - distance - frame.size.width;
  frame.origin.y = self.superview.frame.size.height - distance - frame.size.height;
  self.frame = frame;
}

- (void)addMenuButton:(UIButton *)button
{
  CGRect frame = self.frame;
  CGFloat theGap = buttons.count == 0 ? startGap : gap;
  frame.origin.y -= size + theGap;
  frame.size.height += size + theGap;
  self.frame = frame;

  [buttons addObject:button];
  button.frame = CGRectMake((startSize - size) / 2, (startSize - size) / 2, size, size);
  button.backgroundColor = normalColor;
  button.layer.cornerRadius = radius;
  button.clipsToBounds = YES;
  button.imageEdgeInsets = UIEdgeInsetsMake(imageInset, imageInset, imageInset, imageInset);
  [self insertSubview:button atIndex:0];
  for (NSInteger i = 0; i < self.subviews.count; i++) {
    UIView *v = self.subviews[i];
    CGRect frame = v.frame;
    frame.origin.y = self.frame.size.height - self.frame.size.width + (i < self.subviews.count - 1 ? (startSize - size) / 2 : 0);
    v.frame = frame;
  }
}

- (void)tapAction
{
  if (expanded) {
    [UIView animateWithDuration:0.4 animations:^{
      for (NSInteger i = 0; i < self.subviews.count - 1; i++) {
        UIView *v = self.subviews[i];
        CGRect frame = v.frame;
        frame.origin.y = self.frame.size.height - self.frame.size.width + (startSize - size) / 2;
        v.frame = frame;
      }
    }];
  } else {
    [UIView animateWithDuration:0.4 animations:^{
      for (NSInteger i = 0; i < self.subviews.count - 1; i++) {
        UIView *v = self.subviews[i];
        CGRect frame = v.frame;
        frame.origin.y -= (i + 1) * (size + gap) + (startGap - gap + (startSize - size) / 2);
        v.frame = frame;
      }
    }];
  }
  expanded = !expanded;
  [self.menuDelegate menuButtonTapped];
}

- (void)collapse
{
  expanded = YES;
  [self tapAction];
}

@end
