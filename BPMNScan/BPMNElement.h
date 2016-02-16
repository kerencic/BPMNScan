#import <Foundation/Foundation.h>

@interface BPMNElement : NSObject {
    @private
   /* NSString *_elementId;
    NSString *_elementName;
    NSString *_elementDescription;
    NSString *_elementImageName;
    NSString *_elementCategory;
    NSString *_elementInfo;*/
}

/*@property(nonatomic, strong) NSString *_elementId;
@property(nonatomic, strong) NSString *_elementName;
@property(nonatomic, strong) NSString *_elementDescription;
@property(nonatomic, strong) NSString *_elementImageName;
@property(nonatomic, strong) NSString *_elementCategory;
@property(nonatomic, strong) NSString *_elementInfo;*/

+ (id)plistAllBPMNElements;
+ (id)plistBPMNElementWithId:(NSString*)elementId;

@end
