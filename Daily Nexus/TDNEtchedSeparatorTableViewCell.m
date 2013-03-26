//
//  TDNEtchedSeparatorTableViewCell.m
//  Daily Nexus
//
//  TDNEtchedSeparatorTableViewCell is a UITableViewCell subclass that draws an etched separator
//  line between cells
//

#import "TDNEtchedSeparatorTableViewCell.h"

@implementation TDNEtchedSeparatorTableViewCell

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1);

    // Draw the dark primary line
    [[UIColor colorWithWhite:0.8 alpha:1.0] setStroke];
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, rect.size.height - 1.5);
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), rect.size.height - 1.5);
    CGContextStrokePath(context);
    
    // And the white "shadow" line just below it
    [[UIColor colorWithWhite:0.95 alpha:1.0] setStroke];
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, rect.size.height - 0.5);
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), rect.size.height - 0.5);
    CGContextStrokePath(context);
}

@end
