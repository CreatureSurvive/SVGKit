#import "SVGKExporterUIImage.h"
#import "SVGKDefine_Private.h"

#if SVGKIT_UIKIT
#import "SVGKImage+CGContext.h" // needed for Context calls

@implementation SVGKExporterUIImage

+(UIImage*) exportAsUIImage:(SVGKImage *)image
{
	return [self exportAsUIImage:image antiAliased:TRUE curveFlatnessFactor:1.0 interpolationQuality:kCGInterpolationDefault];
}

+(UIImage*) exportAsUIImage:(SVGKImage*) image antiAliased:(BOOL) shouldAntialias curveFlatnessFactor:(CGFloat) multiplyFlatness interpolationQuality:(CGInterpolationQuality) interpolationQuality
{
	if( [image hasSize] )
	{
		SVGKitLogError("[%@] DEBUG: Generating a UIImage using the current root-object's viewport (may have been overridden by user code): {0,0,%2.3f,%2.3f}", [self class], image.size.width, image.size.height);
		/**
         #802: Some SVG files may lead to app crash issue when using UIGraphicsBeginImageContextWithOptions on iOS 17 or later,
         Use UIGraphicsImageRenderer when possible
         */
        if (@available(iOS 10.0, *)) {
            UIGraphicsImageRendererFormat * rendererFormat = [[UIGraphicsImageRendererFormat alloc] init];
            rendererFormat.opaque = NO;
            rendererFormat.scale = [UIScreen mainScreen].scale;
            
            UIGraphicsImageRenderer * render = [[UIGraphicsImageRenderer alloc] initWithSize:image.size format:rendererFormat];
            
            UIImage* result = [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
                CGContextRef context = rendererContext.CGContext;
                
                [image renderToContext:context antiAliased:shouldAntialias curveFlatnessFactor:multiplyFlatness interpolationQuality:interpolationQuality flipYaxis:FALSE];
            }];
            
            return result;
        } else {
            UIGraphicsBeginImageContextWithOptions( image.size, FALSE, [UIScreen mainScreen].scale );
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            [image renderToContext:context antiAliased:shouldAntialias curveFlatnessFactor:multiplyFlatness interpolationQuality:interpolationQuality flipYaxis:FALSE];
            
            UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            
            return result;
        }
	}
	else
	{
		NSAssert(FALSE, @"You asked to export an SVG to bitmap, but the SVG file has infinite size. Either fix the SVG file, or set an explicit size you want it to be exported at (by calling .size = something on this SVGKImage instance");
		
		return nil;
	}
}

@end

#endif /* SVGKIT_UIKIT */
