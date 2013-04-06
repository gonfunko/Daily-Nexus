//
//  UIImage+TDNAdditions.h
//  Daily Nexus
//
//  UIImage+TDNAdditions adds a method to UIImage to scale and crop images
//

#import <UIKit/UIKit.h>

@interface UIImage (TDNAdditions)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
