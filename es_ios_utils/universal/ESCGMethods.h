#import <Foundation/Foundation.h>

#define $size(w, h) CGSizeMake(w, h)
#define $point(x, y) CGPointMake(x, y)
#define $rect(x, y, w, h) CGRectMake(x, y, w, h)

@interface CG : NSObject
  +(float)scaleToAspectFit:(CGSize)source into:(CGSize)into;
  +(float)scaleToAspectFit:(CGSize)source into:(CGSize)into padding:(float)padding;
  +(float)scaleToAspectFill:(CGSize)source into:(CGSize)into;

  +(CGSize)multiplySize:(CGSize)size by:(float)multiple;
  +(CGPoint)pointFromSize:(CGSize)s;
  +(CGPoint)centerOfSize:(CGSize)s;
  +(CGPoint)subtractPoint:(CGPoint)p from:(CGPoint)from;
  +(float)distanceFromOriginToPoint:(CGPoint)p;

  //drawing methods. Methods without context references use the current context.
  +(CGContextRef)currentContext;

  +(void)beginPathInContext:(CGContextRef)c;
  +(void)context:(CGContextRef)c drawPath:(CGPathDrawingMode)mode;

  +(void)context:(CGContextRef)c setLineWidth:(CGFloat)w;
  +(void)context:(CGContextRef)c setLineCap:(CGLineCap)cap;
  +(void)context:(CGContextRef)c setStrokeColor:(UIColor*)color;
  +(void)context:(CGContextRef)c setFillColor:(UIColor*)color;
  +(void)context:(CGContextRef)c drawElipseInRect:(CGRect)r;
  +(void)context:(CGContextRef)c drawCircleAt:(CGPoint)p radius:(float)r;
  +(void)context:(CGContextRef)c moveTo:(CGPoint)p;
  +(void)context:(CGContextRef)c addLineTo:(CGPoint)p;
  +(void)context:(CGContextRef)c addLineFrom:(CGPoint)f to:(CGPoint)t;

  +(void)beginPath;
  +(void)drawPath:(CGPathDrawingMode)mode;
  +(void)fillPath;

  +(void)setLineWidth:(CGFloat)w;
  +(void)setLineCap:(CGLineCap)cap;
  +(void)setStrokeColor:(UIColor*)color;
  +(void)setFillColor:(UIColor*)color;
  +(void)drawElipseInRect:(CGRect)r;
  +(void)drawCircleAt:(CGPoint)p radius:(float)r;
  +(void)moveTo:(CGPoint)p;
  +(void)addLineTo:(CGPoint)p;
  +(void)addLineFrom:(CGPoint)f to:(CGPoint)t;
@end
