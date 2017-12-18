#import "Extensions.h"

@implementation NSDictionary (Ext)

- (UIColor*)getColor
{
	CGFloat red = [self[@"Red"] floatValue] / 255;
	CGFloat green = [self[@"Green"] floatValue] / 255;
	CGFloat blue = [self[@"Blue"] floatValue] / 255;
	CGFloat alpha = 1;
	if ([self.allKeys containsObject:@"Alpha"]) {
		alpha = [self[@"Alpha"] floatValue] / 100;
	}
	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIFont*)getFont
{
	return [self getFontWithScale:1];
}

- (UIFont*)getFontWithScale:(CGFloat)s
{
	NSString *name = self[@"Name"];
	CGFloat size = [self[@"Size"] floatValue] * s;
	return [UIFont fontWithName:name size:size];
}

@end
