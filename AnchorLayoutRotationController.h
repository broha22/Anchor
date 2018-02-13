#import "headers.h"
@interface AnchorLayoutRotationController : NSObject
+ (id)sharedInstance;
@property(retain)NSArray *iconLists;
@property(assign)NSMutableArray *changedIndexes;
@property(assign)SBIconModel *iconModel;
- (void)changeLayout:(NSDictionary *)layout;
- (void)updateLayoutAtIndex:(NSInteger)index;
@end