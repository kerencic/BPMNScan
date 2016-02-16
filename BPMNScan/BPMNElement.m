#import "BPMNElement.h"

@implementation BPMNElement

#pragma mark -
#pragma mark Class Methods

+ (id)plistBPMNElementWithId:(NSString*)elementId
{
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"BPMNElements" ofType:@"plist"];
    NSArray *elements = [NSArray arrayWithContentsOfFile:fileName];
    
  //  NSLog(@"%@", elements);
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(elementId like %@)", elementId];
    NSArray *filteredElements = [elements filteredArrayUsingPredicate:pred];
    
 //   NSLog(@"%@", filteredElements);
    
    return filteredElements;
}


+ (id)plistAllBPMNElements
{
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"BPMNElements" ofType:@"plist"];
    NSArray *elements = [NSArray arrayWithContentsOfFile:fileName];
    return elements;
}

@end
