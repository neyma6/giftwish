#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface BackgroundLayer : NSObject

+(CAGradientLayer*) greyGradient;
+(CAGradientLayer*) blueGradient;
+(CAGradientLayer*) ios7RedGradient;
+(CAGradientLayer*) ios7BlueGradient;
+(CAGradientLayer*) ios7RevertBlueGradient;
+(CAGradientLayer*) ios7LightBlueGradient;
+(CAGradientLayer*) ios7YellowBlueGradient;
+(CAGradientLayer*) ios7MagentaBlueGradient;
+(CAGradientLayer*) ios7PurpleGradient;
+(CAGradientLayer*) ios7BlackGradient;
+(CAGradientLayer*) ios7GrayGradient;
+(CAGradientLayer*) ios7OrangeGradient;
+(CAGradientLayer*) ios7MildBlueGradient;
+(CAGradientLayer*) ios7MildGrayGradient;
+(CAGradientLayer*) ios7GreenGradient;
+(CAGradientLayer*) ios7ThreeColorBlueGradient;

+(UIColor*)colorWithHexString:(NSString*)hex;
@end