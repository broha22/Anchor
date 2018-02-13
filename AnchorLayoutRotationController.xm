#import "AnchorLayoutRotationController.h"
static AnchorLayoutRotationController *shared;
@implementation AnchorLayoutRotationController
+ (id)sharedInstance {
	if (shared==nil) {
		shared=[[AnchorLayoutRotationController alloc] init];
		shared.changedIndexes = [[NSMutableArray alloc] init];
	}
	return shared;
}
- (void)changeLayout:(NSDictionary *)layout {
	//[self.iconLists release];
	self.iconLists = [layout objectForKey:@"iconLists"];
	[self.changedIndexes removeAllObjects];
	NSInteger cI = 0;
	SBIconListView *dockList = [[[%c(SBIconController) sharedInstance] _rootFolderController] dockListView];
	/*for (SBIcon *icon in [dockList icons]) {
		[dockList removeIcon:icon];
	}*/
	self.iconModel = [[%c(SBIconController) sharedInstance] model];
	for (NSString *iconID in [layout objectForKey:@"buttonBar"]) {
		
		SBIcon *icon = [self.iconModel leafIconForIdentifier:iconID];
		if(icon) {
			if([[dockList icons] count] > cI) {
				SBIcon *oldIcon = [[dockList icons] objectAtIndex:cI];

				[dockList removeIcon:oldIcon];
			
				if(icon != oldIcon) {
					[[[[[%c(SBIconController) sharedInstance] _rootFolderController] iconListViews] lastObject] insertIcon:oldIcon atIndex:0 moveNow:YES];
				}
			}

			[dockList insertIcon:icon atIndex:cI moveNow:YES];
			cI++;
		}
		
		if ([dockList isFull]) {
			break;
			cI = 0;
		}
	}
	[self updateLayoutAtIndex:[[%c(SBIconController) sharedInstance] _rootFolderController].currentPageIndex];
	[self updateLayoutAtIndex:[[%c(SBIconController) sharedInstance] _rootFolderController].currentPageIndex-1];
	[self updateLayoutAtIndex:[[%c(SBIconController) sharedInstance] _rootFolderController].currentPageIndex+1];
}
- (void)updateLayoutAtIndex:(NSInteger)index {

	if(index < 0 || [self.changedIndexes indexOfObject:[NSNumber numberWithInteger:index]] != NSNotFound) {
		return;
	}
	ANLog(@"JIJSKNL %ld",(long)index);

	[self.changedIndexes addObject:[NSNumber numberWithInteger:index]];
	NSArray *listViews = [[[%c(SBIconController) sharedInstance] _rootFolderController] iconListViews];
	if (index >= 0 && index < [self.iconLists count]) {
		while (index > [listViews count]) {
			[[[%c(SBIconController) sharedInstance] _rootFolderController] addEmptyListView];
		}
		if (index < [listViews count]) {
			SBIconListView *listToChange = [listViews objectAtIndex:index];

			NSInteger cI = 0;
			for (NSObject *iconID in [self.iconLists objectAtIndex:index]) {
				ANLog(@"%@",iconID);
				if ([iconID isKindOfClass:[NSDictionary class]]) {
					//create folder
					id folder = [[%c(SBIconController) sharedInstance] createNewFolderFromRecipientIcon:nil grabbedIcon:nil];
					((SBFolder *)folder).displayName = [(NSDictionary *)iconID objectForKey:@"displayName"];
					SBFolderController *folderController = [[[[%c(SBIconController) sharedInstance] controllerClassForFolder:folder] alloc] initWithFolder:folder orientation:[[%c(SBIconController) sharedInstance] orientation] viewMap:[[%c(SBIconController) sharedInstance] _rootFolderController].viewMap];
					//ANLog(@"ANCHOR - %@", NSStringFromClass([folder class]));
					//
					for (int i = 0; i < [[(NSDictionary *)iconID objectForKey:@"iconLists"] count]; i++) {
						[folderController addEmptyListView];
						int w = 0;
						for (NSString *name in [[(NSDictionary *)iconID objectForKey:@"iconLists"] objectAtIndex:i]) {
							SBIcon *icon = [self.iconModel leafIconForIdentifier:name];
							if (icon) {
								ANLog(@"POOP");
								[[[folderController iconListViews] objectAtIndex:i] insertIcon:icon atIndex:w moveNow:YES];
							}
							w++;
						}
						
					}
					SBIcon *icon = [[%c(SBFolderIcon) alloc] initWithFolder:folder];
					((SBFolder *)folder).icon = [icon retain];
					SBIcon *oldIcon = [[listToChange icons] objectAtIndex:cI];
					[listToChange removeIcon:oldIcon];
					if(icon != oldIcon && ![icon isKindOfClass:[%c(SBFolderIcon) class]]) {
						[[[[[%c(SBIconController) sharedInstance] _rootFolderController] iconListViews] lastObject] insertIcon:oldIcon atIndex:0 moveNow:YES];
					}
					
					[listToChange insertIcon:((SBFolder *)folder).icon atIndex:cI moveNow:YES];
				}
				else {
					SBIcon *icon = [self.iconModel leafIconForIdentifier:(NSString *)iconID];
					if(icon) {
						if([[listToChange icons] count] > cI) {
							SBIcon *oldIcon = [[listToChange icons] objectAtIndex:cI];
							[listToChange removeIcon:oldIcon];
						
							if(icon != oldIcon) {
								[[[[[%c(SBIconController) sharedInstance] _rootFolderController] iconListViews] lastObject] insertIcon:oldIcon atIndex:0 moveNow:YES];
							}
						}
						[listToChange insertIcon:icon atIndex:cI moveNow:YES];
					}
					else {
						[listToChange insertIcon:[[%c(ANPlaceHolderIcon) alloc] init] atIndex:cI moveNow:YES];
					}
				}


				cI++;
				if (cI >= [listToChange iconColumnsForCurrentOrientation] * [listToChange iconRowsForCurrentOrientation]) {
					break;
				}
			}
		}
	}
	//if the new icon layout has less lists than the old one we need to delete the extra ones
	else if (index >= [self.iconLists count] && index < [listViews count]) {
		SBIconListView *listToChange = [listViews objectAtIndex:index];
		for (SBIcon *icon in [listToChange icons]) {
			[listToChange removeIcon:icon];
		}
		//recursive because we cant scroll
		[self updateLayoutAtIndex:index+1];
	}
}
- (void)dealloc {
	[self.changedIndexes release];
	[super dealloc];
}
@end