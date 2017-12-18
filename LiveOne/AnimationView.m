#import "AnimationView.h"


@interface AnimationLayer()

@property (nonatomic, assign) CGFloat border;

@end


@implementation AnimationLayer


+ (BOOL)needsDisplayForKey:(NSString *)key
{
	if ([key isEqualToString:@"radius"]) {
		return YES;
	}
	return [super needsDisplayForKey:key];
}


- (instancetype)init
{
	self = [super init];
	if (self) {
		self.border = 100;
		[self setNeedsDisplay];
	}
	return self;
}


- (void)drawInContext:(CGContextRef)ctx
{
	CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
	CGFloat r = self.radius.floatValue;
	CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
	if (r == 0) {
		CGContextFillRect(ctx, self.bounds);
		return;
	}
	CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
	CGContextFillEllipseInRect(ctx, CGRectMake(center.x - r, center.y - r, r * 2, r * 2));
}


@end
