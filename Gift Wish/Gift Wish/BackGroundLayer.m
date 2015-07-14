#import "BackgroundLayer.h"

@implementation BackgroundLayer

//Metallic grey gradient background
+ (CAGradientLayer*) greyGradient {
    
    UIColor *colorOne = [UIColor colorWithWhite:0.9 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.85 alpha:1.0];
    UIColor *colorThree     = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.7 alpha:1.0];
    UIColor *colorFour = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.4 alpha:1.0];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.02];
    NSNumber *stopThree     = [NSNumber numberWithFloat:0.99];
    NSNumber *stopFour = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

//Blue gradient background
+ (CAGradientLayer*) blueGradient {
    
    UIColor *colorOne = [UIColor colorWithRed:(120/255.0) green:(135/255.0) blue:(150/255.0) alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(57/255.0)  green:(79/255.0)  blue:(96/255.0)  alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

+(CAGradientLayer*) ios7BlueGradient
{
    UIColor *colorOne = [BackgroundLayer colorWithHexString:@"1AD6FD"];//1AD6FD
    UIColor *colorTwo = [BackgroundLayer colorWithHexString:@"1D62F0"];//
    
    return [BackgroundLayer createGradienLayer:colorOne With:colorTwo];
}

+(CAGradientLayer*) ios7LightBlueGradient
{
    UIColor *colorOne = [BackgroundLayer colorWithHexString:@"52EDC7"];
    UIColor *colorTwo = [BackgroundLayer colorWithHexString:@"5AC8FB"];
    
    return [BackgroundLayer createGradienLayer:colorOne With:colorTwo];
}
+(CAGradientLayer*) ios7YellowBlueGradient
{
    UIColor *colorOne = [BackgroundLayer colorWithHexString:@"FFDB4C"];
    UIColor *colorTwo = [BackgroundLayer colorWithHexString:@"FFCD02"];
    
    return [BackgroundLayer createGradienLayer:colorOne With:colorTwo];
}

+(CAGradientLayer*) ios7MagentaBlueGradient
{
    UIColor *colorOne = [BackgroundLayer colorWithHexString:@"FF5E3A"];
    UIColor *colorTwo = [BackgroundLayer colorWithHexString:@"FF2A68"];
    
    return [BackgroundLayer createGradienLayer:colorOne With:colorTwo];

}

+(CAGradientLayer*) ios7RevertBlueGradient
{
    UIColor *colorOne = [BackgroundLayer colorWithHexString:@"1D62F0"];
    UIColor *colorTwo = [BackgroundLayer colorWithHexString:@"1D62F0"];//1AD6FD
    
    return [BackgroundLayer createGradienLayer:colorOne With:colorTwo];
}

+(CAGradientLayer*) ios7PurpleGradient
{
    UIColor *colorOne = [BackgroundLayer colorWithHexString:@"C644FC"];
    UIColor *colorTwo = [BackgroundLayer colorWithHexString:@"5856D6"];
    
    return [BackgroundLayer createGradienLayer:colorOne With:colorTwo];
}

+(CAGradientLayer*) ios7BlackGradient
{
    UIColor *colorOne = [BackgroundLayer colorWithHexString:@"4A4A4A"];
    UIColor *colorTwo = [BackgroundLayer colorWithHexString:@"2B2B2B"];
    
    return [BackgroundLayer createGradienLayer:colorOne With:colorTwo];

}

+(CAGradientLayer*) ios7GrayGradient
{
    UIColor *colorOne = [BackgroundLayer colorWithHexString:@"DBDDDE"];
    UIColor *colorTwo = [BackgroundLayer colorWithHexString:@"898C90"];
    
    return [BackgroundLayer createGradienLayer:colorOne With:colorTwo];
}

+(CAGradientLayer*) ios7OrangeGradient
{
    UIColor *colorOne = [BackgroundLayer colorWithHexString:@"FF5E3A"];
    UIColor *colorTwo = [BackgroundLayer colorWithHexString:@"FF9500"];
    
    return [BackgroundLayer createGradienLayer:colorOne With:colorTwo];
}

+(CAGradientLayer*) ios7MildBlueGradient
{
    UIColor *colorOne = [BackgroundLayer colorWithHexString:@"D1EEFC"];
    UIColor *colorTwo = [BackgroundLayer colorWithHexString:@"E0F8D8"];
    
    return [BackgroundLayer createGradienLayer:colorOne With:colorTwo];
}

+(CAGradientLayer*) ios7MildGrayGradient
{
    UIColor *colorOne = [BackgroundLayer colorWithHexString:@"D7D7D7"];
    UIColor *colorTwo = [BackgroundLayer colorWithHexString:@"F7F7F7"];
    
    return [BackgroundLayer createGradienLayer:colorOne With:colorTwo];
}

+(CAGradientLayer*) ios7GreenGradient
{
    UIColor *colorOne = [BackgroundLayer colorWithHexString:@"87FC70"];
    UIColor *colorTwo = [BackgroundLayer colorWithHexString:@"0BD318"];
    
    return [BackgroundLayer createGradienLayer:colorOne With:colorTwo];
}

+(CAGradientLayer*) ios7RedGradient
{
    UIColor *colorOne = [BackgroundLayer colorWithHexString:@"FF1300"];
    UIColor *colorTwo = [BackgroundLayer colorWithHexString:@"FF1300"];
    
    return [BackgroundLayer createGradienLayer:colorOne With:colorTwo];
}

+(CAGradientLayer*) ios7ThreeColorBlueGradient
{
    UIColor *colorOne = [BackgroundLayer colorWithHexString:@"1AD6FD"];//1AD6FD
    UIColor *colorTwo = [BackgroundLayer colorWithHexString:@"5AC8FB"];
    UIColor *colorThree = [BackgroundLayer colorWithHexString:@"87FC70"];
    
    return [BackgroundLayer createGradienLayer:colorOne With:colorTwo With:colorThree];
}

+(CAGradientLayer*)createGradienLayer:(UIColor*)colorOne With:(UIColor*)colorTwo
{
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];

    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    
    return headerLayer;
}

+(CAGradientLayer*)createGradienLayer:(UIColor*)colorOne With:(UIColor*)colorTwo With:(UIColor*)colorThree
{
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, nil];
    
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.1];
    NSNumber *stopThree     = [NSNumber numberWithFloat:0.8];
    NSNumber *stopFour = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopTwo, stopThree, stopFour, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}


+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end