#import "UIColor+AventaPlus.h"

@implementation UIColor (AventaPlus)

+ (UIColor*)AP_basicOrangeColorWithTransparent:(CGFloat)transparent{
    return [UIColor colorWithRed:255.0f/255.0f green:105.0f/255.0f blue:0.0f/255.0f alpha:transparent];
}

@end
