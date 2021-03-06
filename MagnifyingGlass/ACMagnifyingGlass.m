//
//  ACMagnifyingGlass.m
//  MagnifyingGlass
//

#import "ACMagnifyingGlass.h"
#import <QuartzCore/QuartzCore.h>


static CGFloat const kACMagnifyingGlassDefaultRadius = 40;
static CGFloat const kACMagnifyingGlassDefaultOffset = -40;
static CGFloat const kACMagnifyingGlassDefaultScale = 1.5;

@interface ACMagnifyingGlass ()
@end

@implementation ACMagnifyingGlass

@synthesize viewToMagnify, touchPoint, touchPointOffset, scale, scaleAtTouchPoint;

- (id)init {
    self = [self initWithFrame:CGRectMake(0, 0, kACMagnifyingGlassDefaultRadius*2, kACMagnifyingGlassDefaultRadius*2)];
    return self;
}

- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		
		self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		self.layer.borderWidth = 3;
		self.layer.cornerRadius = frame.size.width / 2;
		self.layer.masksToBounds = YES;
		self.touchPointOffset = CGPointMake(0, kACMagnifyingGlassDefaultOffset);
		self.scale = kACMagnifyingGlassDefaultScale;
		self.viewToMagnify = nil;
		self.scaleAtTouchPoint = YES;
	}
	return self;
}

- (void)setFrame:(CGRect)f {
	super.frame = f;
	self.layer.cornerRadius = f.size.width / 2;
}

- (void)setTouchPoint:(CGPoint)point {
	touchPoint = point;
	self.center = CGPointMake(point.x + touchPointOffset.x, point.y + touchPointOffset.y);
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, self.frame.size.width/2, self.frame.size.height/2 );
	CGContextScaleCTM(context, scale, scale);
	CGContextTranslateCTM(context, -touchPoint.x, -touchPoint.y + (self.scaleAtTouchPoint? 0 : self.bounds.size.height/2));
	
	//This is a huge performance boost
	CGContextSetInterpolationQuality(context, kCGInterpolationNone);
	[self.viewToMagnify.layer renderInContext:context];
	CGContextRestoreGState(context);
	
	UIGraphicsPushContext(context);
	UIBezierPath* crossHair = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(CGRectGetMidX(self.bounds)-3,CGRectGetMidY(self.bounds)-3,6,6)];
	/*UIBezierPath* crossHair = [UIBezierPath bezierPath];
	[crossHair moveToPoint:CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMinY(self.bounds))];
	[crossHair addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMaxY(self.bounds))];
	[crossHair moveToPoint:CGPointMake(CGRectGetMinX(self.bounds),CGRectGetMidY(self.bounds))];
	[crossHair addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds),CGRectGetMidY(self.bounds))];*/
	[[UIColor colorWithWhite:1 alpha:0.4] setStroke];
	[crossHair stroke];
	UIGraphicsPopContext();
}


@end
