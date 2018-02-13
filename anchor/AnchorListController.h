#import <Preferences/Preferences.h>
#import "UIImage+animatedGIF.h"
#import <AppSupport/AppSupport.h>
#import <objc/runtime.h>
#import "AnchorResetAll.h"
@interface NSUserDefaults (an) {
}
- (id)objectForKey:(id)key inDomain:(id)d;
- (void)setObject:(id)r forKey:(id)key inDomain:(id)d;
- (id)_initWithSuiteName:(id)i container:(id)p;
@end
@interface PrefsRootController : UIViewController
- (id)rootListController;
@end
@interface PrefsListController : UIViewController
@end
/*
typedef NS_ENUM(NSInteger, UIAlertActionStyle) {
    UIAlertActionStyleDefault = 0,
    UIAlertActionStyleCancel,
    UIAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, UIAlertControllerStyle) {
    UIAlertControllerStyleActionSheet = 0,
    UIAlertControllerStyleAlert
};
@interface UIPresentationController : NSObject
@end
@interface UIPopoverPresentationController : UIPresentationController
@property (nonatomic, assign) UIPopoverArrowDirection permittedArrowDirections;
@property (nonatomic, retain) UIView *sourceView;
@property (nonatomic, assign) CGRect sourceRect;
@end
@interface UIAlertAction : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction *action))handler;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) UIAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end

@interface UIAlertController : UIViewController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle;

- (void)addAction:(UIAlertAction *)action;
@property (nonatomic, readonly) NSArray *actions;
- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;
@property (nonatomic, readonly) NSArray *textFields;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, readonly) UIAlertControllerStyle preferredStyle;
- (id)popoverPresentationController;
@end
*/
@interface PSSpecifier (anchor)
- (void)setButtonAction:(SEL)selc;
- (id)target;
-(SEL)buttonAction;
@end
@interface PSListController (anchor)
- (void)viewDidLoad;
-(void)insertSpecifier:(PSSpecifier*)specifier atIndex:(int)index;
@end
@interface AnchorListController: PSListController <UIAlertViewDelegate> {
UIImageView *_gif;
UIView *_animated;
UILabel *_titleLabel;
UIView *_textContainer;
}
@property (nonatomic, assign) NSString *tempFileName;
- (id)createSpecifierWithCell:(PSCellType)cell customClass:(id)CClass usingDefault:(id)defaultValue label:(id)label key:(id)key;
- (void)resetR;
@end
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#import "AnchorSwitch.h"