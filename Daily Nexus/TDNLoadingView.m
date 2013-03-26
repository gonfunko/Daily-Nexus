//
//  TDNLoadingView.m
//  Daily Nexus
//
//  TDNLoadingView displays an image of Storke Tower with a glowing light and the text "Loading..."
//  It's shown while the RSS feed is being refreshed
//

#import "TDNLoadingView.h"

@interface TDNLoadingView ()

@property (retain) UILabel *loadingText;
@property (retain) UIImageView *imageView;
@property (retain) CAShapeLayer *light;

@end

@implementation TDNLoadingView

@synthesize loadingText;
@synthesize imageView;
@synthesize light;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Set up our loading text
        loadingText = [[UILabel alloc] init];
        loadingText.text = @"Loading\u2026";
        loadingText.font = [UIFont fontWithName:@"Palatino-Bold" size:30.0];
        loadingText.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        loadingText.shadowColor = [UIColor whiteColor];
        loadingText.shadowOffset = CGSizeMake(0, 1);
        loadingText.backgroundColor = [UIColor clearColor];
        [loadingText sizeToFit];
        
        // Set up the image view with Storke Tower
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"storketower"]];
        [imageView sizeToFit];
        
        // Create a CAShapeLayer with a small red circle – this is the aircraft warning light atop Storke Tower
        light = [[CAShapeLayer alloc] init];
        light.fillColor = [UIColor colorWithRed:208/255.0 green:56/255.0 blue:42/255.0 alpha:1.0].CGColor;
        light.shadowColor = [UIColor colorWithRed:208/255.0 green:56/255.0 blue:42/255.0 alpha:1.0].CGColor;
        light.shadowOffset = CGSizeMake(0, 0);
        light.shadowRadius = 6.0;
        light.shadowOpacity = 1;
        // Unfortunately, CALayers don't support filters on iOS, so we fake a blur by setting the
        // rasterization scale to a small value        
        light.rasterizationScale = 0.5;
        light.shouldRasterize = YES;
        
        light.path = CGPathCreateWithEllipseInRect(CGRectMake(0, 0, 0, 0), NULL);
        light.anchorPoint = CGPointMake(0.5, 0.5);
        light.bounds = CGRectMake(0, 0, 0, 0);
        // Add the light layer
        [self.layer addSublayer:light];
        
        CABasicAnimation *size = [CABasicAnimation animationWithKeyPath:@"path"];
        size.duration = 1.8;
        size.fromValue = (id)light.path;
        size.toValue = (__bridge id)(CGPathCreateWithEllipseInRect(CGRectMake(0, 0, 10, 10), NULL));
        size.repeatCount = INT_MAX;
        size.autoreverses = YES;
        [light addAnimation:size forKey:@"path"];
        
        CABasicAnimation *location = [CABasicAnimation animationWithKeyPath:@"bounds"];
        location.duration = 1.8;
        location.fromValue = [NSValue valueWithCGRect:light.bounds];
        location.toValue = [NSValue valueWithCGRect:CGRectMake(0, 3, 10, 10)];
        location.repeatCount = INT_MAX;
        location.autoreverses = YES;
        [light addAnimation:location forKey:@"bounds"];
        
        // Add the loading text and image
        [self addSubview:loadingText];
        [self addSubview:imageView];
        
    }
    return self;
}

- (void)layoutSubviews {
    // This horrible mess of text handles positioning the loading text and Storke Tower image nicely.
    // You shouldn't edit it, and if you do, it should just be thrown out and done from scratch
    if (self.frame.size.height > self.imageView.frame.size.height) {
        self.imageView.frame = CGRectMake((self.frame.size.width - self.imageView.frame.size.width) / 2, self.frame.size.height - self.imageView.frame.size.height + 10, self.imageView.frame.size.width, self.imageView.frame.size.height);
        self.loadingText.frame = CGRectMake((self.frame.size.width - self.loadingText.frame.size.width) / 2, self.imageView.frame.origin.y - self.loadingText.frame.size.height - 30, self.loadingText.frame.size.width, self.loadingText.frame.size.height);
    } else {
        self.loadingText.frame = CGRectMake((self.frame.size.width - self.loadingText.frame.size.width) / 2, 30, self.loadingText.frame.size.width, self.loadingText.frame.size.height);
        self.imageView.frame = CGRectMake((self.frame.size.width - self.imageView.frame.size.width) / 2, self.loadingText.frame.origin.y + self.loadingText.frame.size.height + 30, self.imageView.frame.size.width, self.imageView.frame.size.height);
    }
    
    light.position = CGPointMake(self.frame.size.width / 2, imageView.frame.origin.y);
}

@end
