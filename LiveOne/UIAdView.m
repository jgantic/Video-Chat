//
//  UIAdView.m
//  LiveOne
//
//  Created by Александр on 14.08.15.
//  Copyright (c) 2015 Remi Development. All rights reserved.
//

#import "UIAdView.h"

@implementation UIAdView

#pragma mark -
#pragma mark Initializate

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initalizate];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initalizate];
}

- (void)initalizate {
    [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"UIAdView"] owner:self options:nil];
    [self addSubview:self.mainView];
    [self setFrame:self.mainView.frame];
    
}


@end
