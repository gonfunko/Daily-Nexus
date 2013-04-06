#`UIImage (TDNAdditions)`#

UIImage+TDNAdditions adds a method to resize and crop images.

##Public Interface##

###Methods###
`- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;` - Returns a copy of the receiver that is first scaled so that both width and height are less than or equal to `targetSize`, then cropped to `targetSize`