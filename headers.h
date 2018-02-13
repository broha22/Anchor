#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#import <CommonCrypto/CommonDigest.h>
#import <dlfcn.h>
#import <mach/port.h>
#import <mach/kern_return.h>
#include <IOKit/IOKitLib.h>
#include <CoreFoundation/CoreFoundation.h>/*
typedef NS_ENUM(NSInteger, UIAlertActionStyle) {
    UIAlertActionStyleDefault = 0,
    UIAlertActionStyleCancel,
    UIAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, UIAlertControllerStyle) {
    UIAlertControllerStyleActionSheet = 0,
    UIAlertControllerStyleAlert
};
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
@end*/
@interface NSUserDefaults (an) {
}
- (id)objectForKey:(id)key inDomain:(id)d;
- (void)setObject:(id)r forKey:(id)key inDomain:(id)d;
- (id)_initWithSuiteName:(id)i container:(id)p;
@end
@interface SBIcon : NSObject
-(id)leafIdentifier;
-(id)displayName;
- (id)applicationBundleID;
-(BOOL)isFolderIcon;
-(id)folder;
-(id)containedNodeIdentifiers;
@end

@interface SBIconView : UIView
@property (nonatomic,retain) SBIcon * icon; 
@end
@interface SBIconListModel
-(NSUInteger)firstFreeSlotIndex;
-(BOOL)addIcon:(id)arg1;
- (id)icons;
- (id)iconAtIndex:(unsigned long long)arg1;
@end
@interface SBIconIndexMutableList
-(void)insertNode:(id)arg1 atIndex:(NSUInteger)arg2;
-(void)removeNode:(id)arg1 ;
-(id)nodeAtIndex:(NSUInteger)arg1 ;
-(NSUInteger)indexOfNode:(id)arg1 ;
+(NSUInteger)maxIcons;
-(NSUInteger)countByEnumeratingWithState:(id*)arg1 objects:(id*)arg2 count:(NSUInteger)arg3 ;
-(void)removeNodeAtIndex:(NSUInteger)arg1 ;
-(void)addNode:(id)arg1 ;
-(void)removeAllNodes;
-(NSUInteger)count;
-(NSArray *)nodes;
-(void)replaceNodeAtIndex:(unsigned long long)arg1 withNode:(id)arg2;
@end
@interface SBIconListView : NSObject
-(id)model;
-(void)removeIcon:(id)arg1 ;
-(id)icons;
-(NSUInteger)firstFreeSlotIndex;
+(NSUInteger)maxIcons;
-(BOOL)isFull;
-(void)buildBlanksFor:(NSInteger)index;
-(void)removeIconAtIndex:(NSUInteger)arg1 ;
-(NSUInteger)iconColumnsForCurrentOrientation;
-(NSUInteger)iconRowsForCurrentOrientation;
-(void)removeBlanksAndDestroy;
-(id)iconWithID:(NSString *)ating;
- (id)insertIcon:(id)arg1 atIndex:(NSUInteger)arg2 moveNow:(BOOL)arg3;
@end
@interface SBRootIconListView : SBIconListView
@end
@interface SBFolder : NSObject
@property (assign,nonatomic) SBIcon *icon;
- (NSArray *)allIcons;
-(NSArray *)folderIcons;
-(void)setDisplayName:(NSString *)arg1 ;
-(id)addIcon:(id)arg1 ;
-(void)setIcon:(SBIcon *)arg1 ;
-(id)_createNewListWithIcon:(id)arg1 ;
-(void)_addList:(id)arg1 ;
-(id)lists;
-(void)purgeLists;
- (id)addEmptyList;
@property(copy, nonatomic) NSString *displayName;
@end
@interface SBFolderView : UIView
-(NSArray *)iconListViews;
-(void)resetIconListViews;
@property(retain, nonatomic) SBFolder *folder;
@end
@interface SBRootFolderView : SBFolderView

@end
@interface SBFolderIcon : SBIcon
-(id)initWithFolder:(id)arg1 ;
- (id)displayNameForLocation:(int)arg1;
- (SBFolder *)folder;

@end

@interface SBFolderController : NSObject
- (id)addEmptyListView;
- (id)initWithFolder:(id)arg1 orientation:(long long)arg2 viewMap:(id)arg3;
@property(readonly, nonatomic) id viewMap;
-(id)iconListViewContainingIcon:(id)arg1;
-(SBRootFolderView *)contentView;
-(id)currentIconListView;
-(SBFolder *)folder;
-(NSArray *)iconListViews;
-(SBRootIconListView *)dockListView;
@property(readonly, nonatomic) NSInteger currentPageIndex;
@property(readonly, nonatomic) NSUInteger iconListViewCount;
@end
@interface SBIconModel : NSObject
-(id)expectedIconForDisplayIdentifier:(id)arg1 ;
-(id)leafIconForIdentifier:(NSString *)id;
-(id)bookmarkIconForWebClipIdentifier:(id)arg1 ;
-(id)iconsOfClass:(Class)arg1;
-(id)leafIconForWebClipIdentifier:(id)webClipIdentifier;
- (void)clearDesiredIconState;
- (BOOL)importState:(id)arg1;
- (void)deleteIconState;
- (id)iconState;
@end
@interface SBIconController : NSObject
- (Class)controllerClassForFolder:(id)arg1;
-(SBFolderController *)_rootFolderController;
+ (id)sharedInstance;
-(id)grabbedIcon;
-(SBFolderController *)_openFolderController;
-(id)openFolder;
-(BOOL)isEditing;
-(SBIconModel *)model;
-(void)_resetRootIconLists;
-(id)insertIcon:(id)icon intoListView:(id)listview iconIndex:(NSInteger)index moveNow:(BOOL)move;
-(id)createNewFolderFromRecipientIcon:(id)arg1 grabbedIcon:(id)arg2 ; //YES
- (void)noteIconStateChangedExternally;
- (void)scrollToIconListContainingIcon:(id)arg1 animate:(BOOL)arg2;
- (BOOL)scrollToIconListAtIndex:(NSInteger)arg1 animate:(BOOL)arg2;
- (id)currentFolderIconList;
- (id)currentRootIconList;
-(void)addIcons:(id)arg1 intoFolderIcon:(id)arg2 animated:(BOOL)arg3 openFolderOnFinish:(BOOL)arg4 complete:(/*^block*/id)arg5 ; //YES
@end
@interface SBDefaultIconModelStore : NSObject
+ (id)sharedInstance;
@end
@interface SpringBoard : UIApplication
-(void)_relaunchSpringBoardNow;
-(NSUInteger)activeInterfaceOrientation;
@end
@interface SBIconViewMap : NSObject
@end
@interface NSUserDefaults (anchor) {
}
- (id)objectForKey:(id)key inDomain:(id)d;
@end
@interface ISIconSupport : NSObject
+(id)sharedInstance;
-(void)repairAndReloadIconState;
-(void)addExtension:(NSString *)name;
- (void)repairAndReloadIconState:(NSDictionary *)state;
@end
@interface FBSystemService : NSObject
- (id)sharedInstance;
- (void)exitAndRelaunch:(bool)arg1;
@end
#define ANLog NSLog
//#define ANLog(...)
