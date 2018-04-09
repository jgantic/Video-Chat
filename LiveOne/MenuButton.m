//
//  MenuButton.m
//  SZZL
//
//  Created by Vasily Krainov on 03/04/2018.
//  Copyright © 2018 Remi Development. All rights reserved.
//

#import "MenuButton.h"

@implementation MenuButton

CGFloat size = 45;
CGFloat radius = 11;
CGFloat distance = 15;
CGFloat gap = 6;
CGFloat imageInset = 6;
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

  self.frame = CGRectMake(0, 0, size, size);
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
  frame.origin.y -= self.frame.size.width + gap;
  frame.size.height += self.frame.size.width + gap;
  self.frame = frame;

  [buttons addObject:button];
  button.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
  button.backgroundColor = normalColor;
  button.layer.cornerRadius = radius;
  button.clipsToBounds = YES;
  button.imageEdgeInsets = UIEdgeInsetsMake(imageInset, imageInset, imageInset, imageInset);
  [self insertSubview:button atIndex:0];
  for (NSInteger i = 0; i < self.subviews.count; i++) {
    UIView *v = self.subviews[i];
    CGRect frame = v.frame;
    frame.origin.y = self.frame.size.height - self.frame.size.width;
    v.frame = frame;
  }
}

- (void)tapAction
{
  if (expanded) {
    [UIView animateWithDuration:0.4 animations:^{
      for (UIView *v in self.subviews) {
        CGRect frame = v.frame;
        frame.origin.y = (self.subviews.count - 1) * (self.frame.size.width + gap);
        v.frame = frame;
      }
    }];
  } else {
    [UIView animateWithDuration:0.4 animations:^{
      for (NSInteger i = 0; i < self.subviews.count - 1; i++) {
        UIView *v = self.subviews[i];
        CGRect frame = v.frame;
        frame.origin.y -= (i + 1) * (self.frame.size.width + gap);
        v.frame = frame;
      }
    }];
  }
  expanded = !expanded;
  [self.menuDelegate menuButtonTapped];
}

- (void)collapse
{
  if (expanded) {
    [UIView animateWithDuration:0.4 animations:^{
      for (UIView *v in self.subviews) {
        CGRect frame = v.frame;
        frame.origin.y = (self.subviews.count - 1) * (self.frame.size.width + gap);
        v.frame = frame;
      }
    }];
  }
  expanded = NO;
  [self.menuDelegate menuButtonTapped];
}

@end
