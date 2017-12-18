//
//  UIImage+Alpha.h
//  LiveOne
//
//  Created by Александр on 16.09.15.
//  Copyright (c) 2015 Remi Development. All rights reserved.
//

// Helper methods for adding an alpha layer to an image
@interface UIImage (Alpha)
- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;
@end