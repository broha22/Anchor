#import "headers.h"
#import "AnchorLayoutRotationController.h"
#import "prefs.h"
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#pragma clang diagnostic push ignored pop

%group anchor
%subclass ANPlaceHolderIcon : SBIcon
- (id)getGenericIconImage:(NSInteger)arg1 {
  return nil;
}
- (BOOL)shouldCacheImageForFormat:(NSInteger)arg1 {
  return NO;
}

- (id)getIconImage:(NSInteger)arg1 {
  return nil;
}
- (BOOL)canReceiveGrabbedIcon {
  return NO;
}
- (id)applicationBundleID {
  return @"com.broganminer.anchor";
}
- (id)leafIdentifier {
  return @"com.broganminer.anchor";
}
%end

static SBIconListView *oldListView = nil;
static NSInteger oldIndex = -1;
static NSUInteger max = 0;
static NSUInteger folderMax = 0;
static BOOL wasEditing = NO;

//static dispatch_queue_t rotationQ;
// %hook SBRootFolderController
// - (void)_scrollRight:(id)arg1 {
//   ANLog(@"AN - %@", NSStringFromClass([arg1 class]));
//   %orig;
// }
// %end
%hook SBIconController
- (void)folderControllerDidEndScrolling:(id)arg1 {
  %orig;
  if ([arg1 isKindOfClass:[%c(SBRootFolderController) class]]) {
    [[AnchorLayoutRotationController sharedInstance] updateLayoutAtIndex:(NSInteger)[self _rootFolderController].currentPageIndex];
    [[AnchorLayoutRotationController sharedInstance] updateLayoutAtIndex:(NSInteger)[self _rootFolderController].self.currentPageIndex-1];
    [[AnchorLayoutRotationController sharedInstance] updateLayoutAtIndex:(NSInteger)[self _rootFolderController].self.currentPageIndex+1];
  }
}
-(void)removeIcon:(id)arg1 compactFolder:(BOOL)arg2 {
  if ([arg1 isKindOfClass:[%c(SBFolderIcon) class]]) {
    SBFolderController *controller = nil;
    if ([self _openFolderController] != nil) {
      controller = [self _openFolderController];
    }
    else {
      controller = [self _rootFolderController];
    }
    SBIconIndexMutableList *workingList = MSHookIvar<SBIconIndexMutableList *>([[controller iconListViewContainingIcon:arg1] model], "_icons");
    NSUInteger index = [workingList indexOfNode:arg1];
    if (index < [workingList count]-1) {
      [workingList insertNode:[[%c(ANPlaceHolderIcon) alloc] init] atIndex:index];

    }
  }
  %orig;
}
/*
- (void)didSaveIconState:(id)arg1 {
  %orig;
  //ANLog(@"about to save %@",NSStringFromClass([[arg1 iconState] class]));
  if (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/Anchor2.0/current"]) {
    [[NSFileManager defaultManager] createDirectoryAtPath:@"var/mobile/Library/Preferences/Anchor2.0/current" withIntermediateDirectories:YES attributes:nil error:nil];
  }
  NSString *key = nil;
  ([(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation] == 3 || [(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation] == 4)?key = @"layoutLandscape.plist":key = @"layoutPortrait.plist";
  [[arg1 iconState] writeToFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/Anchor2.0/current/%@",key] atomically:YES];
  ANLog(@"writing state");
}
*/
- (void)iconHandleLongPress:(id)arg1 {
  SBIconView *view = arg1;
  if (![view.icon isKindOfClass:[%c(ANPlaceHolderIcon) class]]) {
    %orig;
  }
}
- (void)setIsEditing:(_Bool)arg1 withFeedbackBehavior:(id)arg2 {
  %orig;
  if (wasEditing) {
    if (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/Anchor2.0/current"]) {
      [[NSFileManager defaultManager] createDirectoryAtPath:@"var/mobile/Library/Preferences/Anchor2.0/current" withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *key = nil;
    ([(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation] == 3 || [(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation] == 4)?key = @"layoutLandscape.plist":key = @"layoutPortrait.plist";
    [[[self model] iconState] writeToFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/Anchor2.0/current/%@",key] atomically:YES];
    ANLog(@"writing state");
  }
  
  (arg1)?wasEditing = YES : wasEditing = NO;
}
- (void)setIsEditing:(BOOL)arg1 {
  %orig;
  if (wasEditing) {
    if (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/Anchor2.0/current"]) {
      [[NSFileManager defaultManager] createDirectoryAtPath:@"var/mobile/Library/Preferences/Anchor2.0/current" withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *key = nil;
    ([(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation] == 3 || [(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation] == 4)?key = @"layoutLandscape.plist":key = @"layoutPortrait.plist";
    [[[self model] iconState] writeToFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/Anchor2.0/current/%@",key] atomically:YES];
    ANLog(@"writing state");
  }
  
  (arg1)?wasEditing = YES : wasEditing = NO;
}
//
//
//
/*holy s** this worked, seperate layouts for landscape and portrait*/
- (void)_willRotateToInterfaceOrientation:(NSInteger)arg1 duration:(CGFloat)arg2 {
  %orig;
  if (rotation()) {
    NSString *key = nil;
    (arg1 == 3 || arg1 == 4)?key = @"layoutLandscape.plist":key = @"layoutPortrait.plist";
    NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/Anchor2.0/current/%@",key];
    AnchorLayoutRotationController *rotationController = [AnchorLayoutRotationController sharedInstance];
    [rotationController changeLayout:[NSDictionary dictionaryWithContentsOfFile:path]];


    /*
    dispatch_async(rotationQ,^{
      NSInteger index = [[%c(SBIconController) sharedInstance] _rootFolderController].currentPageIndex;
      NSString *key = nil;
      (arg1 == 3 || arg1 == 4)?key = @"layoutLandscape.plist":key = @"layoutPortrait.plist";
      NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/Anchor2.0/current/%@",key];
      NSDictionary *importedState = [NSDictionary dictionaryWithContentsOfFile:path];
      ANLog(@"ipad no show this");
      dispatch_async(dispatch_get_main_queue(), ^{
        if(importedState)[[%c(ISIconSupport) sharedInstance] repairAndReloadIconState:importedState];
      
        NSUInteger count = [[%c(SBIconController) sharedInstance] _rootFolderController].iconListViewCount;
        if (index < count) {
          [[%c(SBIconController) sharedInstance] scrollToIconListAtIndex:index animate:NO];
        }
        else {
          [[%c(SBIconController) sharedInstance] scrollToIconListAtIndex:count-1 animate:NO];
        }
      });
    });*/
  }
}
- (void)willRotateToInterfaceOrientation:(NSInteger)arg1 duration:(CGFloat)arg2 {
  %orig;
  if (rotation()) {
    NSString *key = nil;
    (arg1 == 3 || arg1 == 4)?key = @"layoutLandscape.plist":key = @"layoutPortrait.plist";
    NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/Anchor2.0/current/%@",key];
    AnchorLayoutRotationController *rotationController = [AnchorLayoutRotationController sharedInstance];
    [rotationController changeLayout:[NSDictionary dictionaryWithContentsOfFile:path]];
    /*
    dispatch_async(rotationQ,^{
      NSInteger index = [[%c(SBIconController) sharedInstance] _rootFolderController].currentPageIndex;
      NSString *key = nil;
      (arg1 == 3 || arg1 == 4)?key = @"layoutLandscape.plist":key = @"layoutPortrait.plist";
      NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/Anchor2.0/current/%@",key];
      NSDictionary *importedState = [NSDictionary dictionaryWithContentsOfFile:path];
      ANLog(@"ipad no show this");
      dispatch_async(dispatch_get_main_queue(), ^{
        if(importedState)[[%c(ISIconSupport) sharedInstance] repairAndReloadIconState:importedState];
      
        NSUInteger count = [[%c(SBIconController) sharedInstance] _rootFolderController].iconListViewCount;
        if (index < count) {
          [[%c(SBIconController) sharedInstance] scrollToIconListAtIndex:index animate:NO];
        }
        else {
          [[%c(SBIconController) sharedInstance] scrollToIconListAtIndex:count-1 animate:NO];
        }
      });
    });*/
  }
}
//
//
//
- (void)_closeFolderController:(id)arg1 animated:(BOOL)arg2 withCompletion:(id)arg3 {
  if([self openFolder]) {
    oldListView = [[self _rootFolderController] iconListViewContainingIcon:((SBFolder *)[self openFolder]).icon];
    oldIndex = -1;
    ANLog(@"remove blanks for cloing of folder");

    %orig;
    //[self insertIcon:[self grabbedIcon] intoListView:oldListView iconIndex:0 moveNow:YES];
    for (SBIconListView *listview in [(SBFolderView *)[arg1 contentView] iconListViews]) {
      NSInteger lastReal = -1;
      SBIconIndexMutableList *list = MSHookIvar<SBIconIndexMutableList *>([listview model], "_icons");
      for (SBIcon *icon in [listview icons]) {
        if(![icon isKindOfClass:[%c(ANPlaceHolderIcon) class]] && icon != [self grabbedIcon])lastReal = [[listview icons] indexOfObject:icon];
      }
      ANLog(@"last real %ld", (long)lastReal);
      while ([[listview icons] count] > lastReal+1) {
        ANLog(@"can i do this?");
        id node = [list nodeAtIndex:[[listview icons] count]-1];
        if ([node isKindOfClass:[%c(ANPlaceHolderIcon) class]]) {
          
          [list removeNode:node];
          [node release];

         }
        else {
          ANLog(@"stopped removing icons for %@", NSStringFromClass([node class]));
          break;
        }
      }
    }
    
    ANLog(@"close folder controller");
}
  
}
- (void)setGrabbedIcon:(id)arg1 {
  if (arg1) {
    ANLog(@"YES ICON");
    if (![self _openFolderController]) {
      oldListView = [[self _rootFolderController] iconListViewContainingIcon:arg1];
      oldIndex = [[oldListView icons] indexOfObject:arg1];
      
    }
    else {
      oldListView = [[self _openFolderController] currentIconListView];
      oldIndex = [[oldListView icons] indexOfObject:arg1];
      for (SBIconListView *listview in [[[self _openFolderController] contentView] iconListViews]) {
        if (![listview isKindOfClass:[%c(SBDockIconListView) class]]) {
          SBIconIndexMutableList *list = MSHookIvar<SBIconIndexMutableList *>([listview model], "_icons");
          while ([list count] < folderMax) {
              [list addNode:[[%c(ANPlaceHolderIcon) alloc] init]];

          }
        }
      }
    }
    for (SBIconListView *listview in [[[self _rootFolderController] contentView] iconListViews]) {
      if (![listview isKindOfClass:[%c(SBDockIconListView) class]]) {
	       SBIconIndexMutableList *list = MSHookIvar<SBIconIndexMutableList *>([listview model], "_icons");
	       while ([list count] < max) {
	          [list addNode:[[%c(ANPlaceHolderIcon) alloc] init]];

         }
      }
    }
    %orig;
  }
  else {
    ANLog(@"NO ICON");
    %orig;
    ANLog(@"just checking");
    NSMutableArray *arrayOfArrays = [[NSMutableArray alloc] init];
    if ([self _rootFolderController])[arrayOfArrays addObject:[[[self _rootFolderController] contentView] iconListViews]];
    if ([self _openFolderController])[arrayOfArrays addObject:[[[self _openFolderController] contentView] iconListViews]];
    for (NSArray *arrayOfListViews in arrayOfArrays) {
      for (SBIconListView *listview in arrayOfListViews) {
        ANLog(@"removing unneccesarries");
        NSInteger lastReal = -1;
        SBIconIndexMutableList *list = MSHookIvar<SBIconIndexMutableList *>([listview model], "_icons");
        for (SBIcon *icon in [listview icons]) {
	       if(![icon isKindOfClass:[%c(ANPlaceHolderIcon) class]])lastReal = [[listview icons] indexOfObject:icon];
        }
        while ([[listview icons] count] > lastReal+1) {
	       id node = [list nodeAtIndex:[[listview icons] count]-1];
	       if ([node isKindOfClass:[%c(ANPlaceHolderIcon) class]]) {
            //ANLog(@"node removal");
	         [list removeNode:node];
	         [node release];

	       }
	       else {
	         break;
	       }
        }
      }
    }
    ANLog(@"clean up");
    [arrayOfArrays release];
    arrayOfArrays = nil;
    oldListView = nil;
    oldIndex = -2;
    ANLog(@"done");
  }
}
- (id)insertIcon:(id)arg1 intoListView:(id)arg2 iconIndex:(NSInteger)arg3 moveNow:(BOOL)arg4 {
  SBIconIndexMutableList *oldList;
  if(oldListView != nil)oldList = MSHookIvar<SBIconIndexMutableList *>([oldListView model], "_icons");
  SBIconIndexMutableList *newList = MSHookIvar<SBIconIndexMutableList *>([arg2 model], "_icons");
  ANLog(@"1023 %@ %lld",NSStringFromClass([oldListView class]), (long long)oldIndex);
  if (arg3 != oldIndex && oldIndex >= 0 && ![oldListView isKindOfClass:[%c(SBDockIconListView) class]] && arg2 == oldListView) {
    ANLog(@"1024->");
    if([oldList count] >= oldIndex+1) {
      [oldList insertNode:[[%c(ANPlaceHolderIcon) alloc] init] atIndex:oldIndex];

    }
    ANLog(@"1025->>");
    if ([oldList count] >= arg3+1 && [[oldList nodeAtIndex:arg3] isKindOfClass:[%c(ANPlaceHolderIcon) class]]) {
      ANLog(@"1026");
      id node = [oldList nodeAtIndex:arg3];
      ANLog(@"1027");
      [oldList removeNode:node];
      ANLog(@"1028");
      [node release];

      ANLog(@"1029");
    }
    else {
      ANLog(@"1030");
      if ([oldList count] >= oldIndex+1){
        ANLog(@"1031");
        id node = [oldList nodeAtIndex:oldIndex];
        ANLog(@"1032");
        [oldList removeNode:node];
        ANLog(@"1033");
        [node release];

        ANLog(@"1034");
      }
      else {
        ANLog(@"1035");
      }
    }
  }
  else if (![oldListView isKindOfClass:[%c(SBDockIconListView) class]] && oldIndex >= 0) {
    if([oldList count] >= oldIndex+1) {
      [oldList insertNode:[[%c(ANPlaceHolderIcon) alloc] init] atIndex:oldIndex];

    }
    ANLog(@"thus us %@",[NSNumber numberWithInteger:oldIndex]);
    if(arg3 < [[arg2 icons] count] && [[newList nodeAtIndex:arg3] isKindOfClass:[%c(ANPlaceHolderIcon) class]]) {
      id node = [newList nodeAtIndex:arg3];
      [newList removeNode:node];
      [node release];

    }
    
  }
  
  else if (oldIndex != -1 && oldListView != nil){
    ANLog(@"DOCK %lld", (long long)[newList count]);

    if([newList count]-1 >= arg3 && [[newList nodeAtIndex:arg3] isKindOfClass:[%c(ANPlaceHolderIcon) class]]) {
      ANLog(@"remove");
      id node = [newList nodeAtIndex:arg3];
      [newList removeNode:node];
      [node release];

    }
  }

  oldListView = arg2;
  oldIndex = arg3;
  return %orig;
}
- (void)addIcons:(id)arg1 intoFolderIcon:(id)arg2 animated:(BOOL)arg3 openFolderOnFinish:(BOOL)arg4 complete:(id)arg5 {
  %orig;
  SBIconIndexMutableList *list = MSHookIvar<SBIconIndexMutableList *>([oldListView model], "_icons");
  if(arg2 && [list count] >= oldIndex+1 && oldIndex >= 0 && ![oldListView isKindOfClass:[%c(SBDockIconListView) class]]) {
    [list insertNode:[[%c(ANPlaceHolderIcon) alloc] init] atIndex:oldIndex];

    ANLog(@"JU");
  }
}
- (void)uninstallIcon:(id)arg1 {
    SBIconListView *listview;
    NSInteger index;
    if (arg1){
      SBFolderController *controller = nil;
      if([self _openFolderController]) {
        controller = [self _openFolderController];
      }
      else {
        controller = [self _rootFolderController];
      }
      listview = [controller iconListViewContainingIcon:arg1];
      index = [[listview icons] indexOfObject:arg1];
      ANLog(@"obtained info for deleted icon");
    }
    %orig;
    ANLog(@"icon deleted icon");
    if (arg1 && ![listview isKindOfClass:[%c(SBDockIconListView) class]]) {
      SBIconIndexMutableList *list = MSHookIvar<SBIconIndexMutableList *>([listview model], "_icons");
      if([list count] > index+1) {
        [list insertNode:[[%c(ANPlaceHolderIcon) alloc] init] atIndex:index];

      }
      ANLog(@"placeholder put in for icon");
    }
    }
%end
%hook SBRootIconListView
- (void)setOrientation:(NSInteger)arg1 {
  if (arg1 == 1){
	 //ANLog(@"write dimmensions to file for rootview");
	 NSInteger col = [self iconColumnsForCurrentOrientation];
	 NSInteger row = [self iconRowsForCurrentOrientation];
	 max = row*col;
  }
  %orig;
}
%end
%hook SBFolderIconListView
- (void)setOrientation:(NSInteger)arg1 {
  if (arg1 == 1){
   //ANLog(@"write dimmensions for folderview");
   NSInteger col = [self iconColumnsForCurrentOrientation];
   NSInteger row = [self iconRowsForCurrentOrientation];
   folderMax = row*col;
  }
  %orig;
}
%end

%hook SBIconViewMap
- (void)recycleViewForIcon:(id)arg1 {
  if (![arg1 isKindOfClass:[%c(ANPlaceHolderIcon) class]]) {
    %orig(arg1);
  }
}
- (void)_recycleIconView:(id)view {
  if (![((SBIconView *)view).icon isKindOfClass:[%c(ANPlaceHolderIcon) class]]) {
    %orig;
  }
}
- (id)iconViewForIcon:(id)arg1 {
  if (![arg1 isKindOfClass:[%c(ANPlaceHolderIcon) class]]) {
    return %orig(arg1);
  }
  else {
    return nil;
  }
}
- (id)_iconViewForIcon:(id)arg1 {
  if (![arg1 isKindOfClass:[%c(ANPlaceHolderIcon) class]]) {
    return %orig(arg1);
  }
  else {
    return nil;
  }
}
-(void)_observeIconAndCacheIfNecessary:(id)arg1 {
  if (![arg1 isKindOfClass:[%c(ANPlaceHolderIcon) class]]) {
    %orig;
  }
}
-(void)node:(id)arg1 didAddContainedNodeIdentifiers:(id)arg2 {
 if (![arg1 isKindOfClass:[%c(ANPlaceHolderIcon) class]]) {
    %orig;
  }
}
-(void)node:(id)arg1 didRemoveContainedNodeIdentifiers:(id)arg2 {
 if (![arg1 isKindOfClass:[%c(ANPlaceHolderIcon) class]]) {
    %orig;
  }
}
-(void)_addIconView:(id)arg1 forIcon:(id)arg2 {
  if ([arg2 isKindOfClass:[%c(ANPlaceHolderIcon) class]]) {
    arg1 = nil;
  }
  %orig(arg1,arg2);
}
-(void)_cacheImagesForIcon:(id)arg1 {
  if (![arg1 isKindOfClass:[%c(ANPlaceHolderIcon) class]]) {
    %orig;
  }
}
-(id)extraIconViewForIcon:(id)arg1 {
  if (![arg1 isKindOfClass:[%c(ANPlaceHolderIcon) class]]) {
    return %orig(arg1);
  }
  else {
    return nil;
  }
}
%end
//new stuff for actually saving in the right place, no longer preferences but now in the icon lists storage place, should use icon support now
%hook SBIconModel
- (id)leafIconForIdentifier:(id)arg1 {
  //ANLog(@"get icon for: %@", arg1);
  if ([arg1 isEqual:@"com.broganminer.anchor"]) {
    //ANLog(@"load");
    return nil;
  }
  else {
    return %orig;
  }
}
%end
%hook SBIconStateArchiver
+ (id)_iconFromRepresentation:(id)arg1 withContext:(id)arg2 {
  if ([arg1 isEqual:@"com.broganminer.anchor"]) {

    return [[%c(ANPlaceHolderIcon) alloc] init];
  }
  else {
    return %orig;
  }
}
%end
%end

static void respring(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo){
  [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}
static void reset(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo){

  NSDictionary *importedState = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/SpringBoard/IconState.plist"];
  [[%c(ISIconSupport) sharedInstance] repairAndReloadIconState:importedState];
}
static void updateLayout(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo){
  NSString *key = nil;
  if ([(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation] == 3 || [(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation] == 4) {
    key = @"layoutLancape.plist";
  }
  else {
    key = @"layoutPortrait.plist";
  }
  NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/Anchor2.0/current/%@",key];
  NSDictionary *importedState = [NSDictionary dictionaryWithContentsOfFile:path];
  if(importedState){
    //[[%c(ISIconSupport) sharedInstance] repairAndReloadIconState:importedState];
    [[AnchorLayoutRotationController sharedInstance] changeLayout:importedState];
  }
  ANLog(@"updating imported state");
}
%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (respring), CFSTR("com.broganminer.anchor.respring"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (reset), CFSTR("com.broganminer.anchor.reset"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (updateLayout), CFSTR("com.broganminer.anchor.updatelayout"), NULL, CFNotificationSuspensionBehaviorCoalesce);

  
  if(enable()) {
    %init(anchor);
  }
}