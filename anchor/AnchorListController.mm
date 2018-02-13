#import "AnchorListController.h"
static PSSpecifier *specForAV = nil;
static id valForAV = nil;
static BOOL dumb = YES;
static UINavigationBar *navBartard;
@implementation AnchorListController

- (id)specifiers {
  if(_specifiers == nil) {
    NSMutableArray *newSpecifiers = [[NSMutableArray alloc] init];
    [newSpecifiers addObject:[self createSpecifierWithCell:PSGroupCell customClass:nil usingDefault:nil label:@"" key:nil]];
    [newSpecifiers addObject:[self createSpecifierWithCell:PSGroupCell customClass:nil usingDefault:nil label:@"" key:nil]];
    PSSpecifier *grp = [self createSpecifierWithCell:PSGroupCell customClass:nil usingDefault:nil label:@"" key:nil];
    [grp setProperty:@"Disabling 'Landscape Layout' will disable separate layouts based on orientation. This will reduce the time it takes for your device to rotate." forKey:@"footerText"];
    [newSpecifiers addObject:grp];

    [newSpecifiers addObject:[self createSpecifierWithCell:PSSwitchCell customClass:@"AnchorSwitch" usingDefault:@YES label:@"Enabled" key:@"enable"]];
    [newSpecifiers addObject:[self createSpecifierWithCell:PSSwitchCell customClass:@"AnchorSwitch" usingDefault:@YES label:@"Landscape Layout" key:@"rotation"]];
    [newSpecifiers addObject:[self createSpecifierWithCell:PSGroupCell customClass:nil usingDefault:nil label:@"Layouts" key:nil]];
    
    PSSpecifier *lastGroup = [self createSpecifierWithCell:PSGroupCell customClass:nil usingDefault:nil label:@"" key:nil];
    [lastGroup setProperty:@"Created By Brogan Miner" forKey:@"footerText"];
    [newSpecifiers addObject:lastGroup];
    //[newSpecifiers addObject:[self createSpecifierWithCell:PSGroupCell customClass:nil usingDefault:nil label:@"" key:nil]];
    PSSpecifier *saveCell = [self createSpecifierWithCell:PSButtonCell customClass:@"AnchorSave" usingDefault:nil label:@"Save Current Layout" key:nil];
    [saveCell setButtonAction:@selector(save)];
    [newSpecifiers addObject:saveCell];

    PSSpecifier *resetCell = [self createSpecifierWithCell:PSButtonCell customClass:@"AnchorResetAll" usingDefault:nil label:@"Reset" key:nil];
    [resetCell setButtonAction:@selector(reset)];
    [newSpecifiers addObject:resetCell];
    PSSpecifier *helpCell = [self createSpecifierWithCell:PSButtonCell customClass:@"AnchorSave" usingDefault:nil label:@"Help" key:nil];
    [helpCell setButtonAction:@selector(help)];
    [newSpecifiers addObject:helpCell];
     

    _specifiers = [newSpecifiers copy];
    [newSpecifiers release];
  }
  return _specifiers;
}
- (void)reloadSpecifiers {
  [super reloadSpecifiers];
  [self loadExtraCells];
}
- (void)help {
  if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
    UIAlertView *alertForSwitch = [[UIAlertView alloc] initWithTitle:@"Anchor" message:@"To enable or disable the tweak hit the switch at the top of the page. Toggling this switch will require a respring. To save your current layout in either orientation (Portrait/Landscape) tap the save layout button and give it a name. To reset your current layout hit reset at the bottom of the page. To delete a layout swipe left on a displayed layout." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save Portrait",@"Save Landscape",nil];
    [alertForSwitch show];
    [alertForSwitch release];
  }
  else {
    UIAlertController *alertControl = [objc_getClass("UIAlertController") alertControllerWithTitle:@"Anchor" message:@"To enable or disable the tweak hit the switch at the top of the page. Toggling this switch will require a respring. To save your current layout in either orientation (Portrait/Landscape) tap the save layout button and give it a name. To reset your current layout hit reset at the bottom of the page. To delete a layout swipe left on a displayed layout." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionR = [objc_getClass("UIAlertAction") actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){  
      [alertControl dismissViewControllerAnimated:YES completion:^{
        [alertControl release];
      }];
    }];
    [alertControl addAction:actionR];
    [(UIViewController *)self presentViewController:alertControl animated:YES completion:nil];
    alertControl.view.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
  }
}
- (void)save {
  if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
    UIAlertView *alertForSwitch = [[UIAlertView alloc] initWithTitle:@"Anchor" message:@"Please type a name then select which layout to save." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save Portrait",@"Save Landscape",nil];
    alertForSwitch.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertForSwitch.tag = 4;
    [alertForSwitch show];
    [alertForSwitch release];
  }
  else {
    UIAlertController *alertControl = [objc_getClass("UIAlertController") alertControllerWithTitle:@"Anchor" message:@"Please type a name then select which layout to save." preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addTextFieldWithConfigurationHandler:^(UITextField *textField) {
      textField.placeholder = @"Name";
    }];
    UIAlertAction *actionR = [objc_getClass("UIAlertAction") actionWithTitle:@"Save Portrait" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){  
      [alertControl dismissViewControllerAnimated:YES completion:^{
        [alertControl release];
      }];
      [self save:((UITextField *)alertControl.textFields[0]).text asLandscape:NO];
    }];
    UIAlertAction *actionRL = [objc_getClass("UIAlertAction") actionWithTitle:@"Save Landscape" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){  
      [alertControl dismissViewControllerAnimated:YES completion:^{
        [alertControl release];
      }];
      [self save:((UITextField *)alertControl.textFields[0]).text asLandscape:YES];
    }];
    UIAlertAction *actionC = [objc_getClass("UIAlertAction") actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){  
      [alertControl dismissViewControllerAnimated:YES completion:^{
      [alertControl release];
      }];
    }];
    [alertControl addAction:actionR];
    [alertControl addAction:actionRL];
    [alertControl addAction:actionC];
    [(UIViewController *)self presentViewController:alertControl animated:YES completion:nil];
    alertControl.view.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
  }
}
- (void)save:(NSString *)name asLandscape:(BOOL)l {
  NSString *key;
  if (!l) {
    key = @"layoutPortrait.plist";
  }
  else {
    key = @"layoutLandscape.plist";
  }
  NSData *dataFromCurrent = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/Anchor2.0/current/%@",key]];
  if(name)[dataFromCurrent writeToFile:[NSString stringWithFormat:@"var/mobile/Library/Preferences/Anchor2.0/layouts/%@.plist",name] atomically:YES];
  [self loadExtraCells];
}
- (id)navigationItem {
    UINavigationItem *item = [super navigationItem];
    item.titleView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    return item;
}
- (void)convert {
  NSMutableDictionary *importedState = [[NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/SpringBoard/IconState.plist"] mutableCopy];
  NSError *error;
  NSArray *pathC = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Library/Preferences/Anchor1.1/Pages/" error:&error];
  NSMutableArray *pages = [[importedState objectForKey:@"iconLists"] mutableCopy];
  for (NSString *item in pathC) {
    if ([item rangeOfString:@".plist"].location != NSNotFound) {
      NSInteger objectIndex = [[item stringByReplacingOccurrencesOfString:@".plist" withString:@""] integerValue];
      if ([pages count] > objectIndex) {
        NSArray *iconsToPlace = [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/Anchor1.1/Pages/%@",item]];
        NSMutableArray *page = [[[importedState objectForKey:@"iconLists"] objectAtIndex:objectIndex] mutableCopy];
        for (NSNumber *i in iconsToPlace) {
          if ([page count] > [i integerValue])[page insertObject:@"com.broganminer.anchor" atIndex:[i integerValue]];
        }
        if ([pages count] > objectIndex) {
          [pages removeObjectAtIndex:objectIndex];
          [pages insertObject:page atIndex:objectIndex];
        }
        [page release];
      }
    }
  }
  [importedState setObject:pages forKey:@"iconLists"];
  [pages release];
  NSString *name = @"Anchor 1.1 layout";
  [importedState writeToFile:[NSString stringWithFormat:@"var/mobile/Library/Preferences/Anchor2.0/layouts/%@.plist",name] atomically:YES];
  [importedState release];
  [[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Library/Preferences/Anchor1.1/" error:nil];
  [self loadExtraCells];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (dumb) {
  dumb = NO;
  [[UIApplication sharedApplication] keyWindow].tintColor = [UIColor whiteColor];
  UINavigationBar *navbar;
  if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
    navbar = [[[[self rootController] rootListController] navigationController] navigationBar];
  }
  else {
    navbar = [[self rootController] navigationBar];
  }
  navBartard = navbar;
  navbar.translucent = NO;
  navbar.barTintColor = [UIColor colorWithRed:63.f/255.f green:180.f/255.f blue:212.f/255.f alpha:1];
  _gif = [[UIImageView alloc] initWithImage:[UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:@"file:/Library/PreferenceBundles/anchor.bundle/anchorgif.gif"]]];
  _animated = [[UIView alloc] initWithFrame:CGRectMake(navbar.frame.size.width/2 - 50,-50,navbar.frame.size.width/2 + 50,44)];
  _gif.frame = CGRectMake(0,0,50,42);
  _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-(_animated.frame.size.width-50),0,(_animated.frame.size.width-50),44)];
  _titleLabel.text = @"Anchor";
  _titleLabel.textColor = [UIColor whiteColor];
  _titleLabel.textAlignment = NSTextAlignmentCenter;
  _titleLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:32];
  _textContainer = [[UIView alloc] initWithFrame:CGRectMake(20,0,(_animated.frame.size.width-50),44)];
  _textContainer.clipsToBounds = YES;
  CAGradientLayer *mask = [CAGradientLayer layer];
  mask.frame = _textContainer.frame;
  mask.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor,(id)[UIColor whiteColor].CGColor,nil];
  mask.startPoint = CGPointMake(0.0,1);
  mask.endPoint = CGPointMake(0.5,1);
  _textContainer.layer.mask = mask;
  [_textContainer addSubview:_titleLabel];
  [_animated addSubview:_gif];
  [_animated addSubview:_textContainer];
  [navbar addSubview:_animated];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
  [UIView animateKeyframesWithDuration:1.0 delay:0.0 options:nil animations:^{
    [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.3 animations:^{
      _animated.frame = CGRectMake(_animated.frame.origin.x,0,_animated.frame.size.width,_animated.frame.size.height);
    }];
    [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.7 animations:^{
      _titleLabel.frame = CGRectMake(0,0,(_animated.frame.size.width-50),44);
    }];
  } completion:nil];
  [self performSelector:@selector(animateText) withObject:nil afterDelay:0.3f];
  }
  [self loadExtraCells];
}

- (void)animateText {
  NSTimeInterval duration = 1.0;
  [CATransaction begin];
  [CATransaction setValue:[NSNumber numberWithFloat:duration] forKey:kCATransactionAnimationDuration];
  ((CAGradientLayer *)_textContainer.layer.mask).endPoint = CGPointMake(0.0, 1);
  [CATransaction commit];
}

- (void)viewWillDisappear:(BOOL)animated {
  dumb = YES;
  [_animated removeFromSuperview];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
  [[UIApplication sharedApplication] keyWindow].tintColor = nil;
  UINavigationBar *navbar = navBartard;
  navbar.translucent = YES;  
  navbar.barTintColor = nil;
  [super viewWillDisappear:animated];

}
- (void)loadExtraCells {
  dispatch_async(dispatch_get_main_queue(), ^(void){
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/Anchor2.0/layouts"]) {
      NSArray *layouts = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Library/Preferences/Anchor2.0/layouts/" error:nil];
      for (NSString *fileName in layouts) {
        BOOL shouldAdd = YES;
        for (PSSpecifier *specifier in _specifiers) {
          if ([[specifier propertyForKey:@"fileName"] isEqual:fileName]) {
            shouldAdd = NO;
            break;
          }
        }
        if ([fileName rangeOfString:@".plist"].location != NSNotFound && shouldAdd) {
          PSSpecifier *specForList = [self createSpecifierWithCell:PSButtonCell customClass:@"AnchorDeletable" usingDefault:nil label:[fileName stringByReplacingOccurrencesOfString:@".plist" withString:@""] key:nil];
          [specForList setProperty:fileName forKey:@"fileName"];
          [specForList setButtonAction:@selector(selectedLayout:)];
          [self insertSpecifier:specForList atIndex:6];
        }
      }
    }
    else {
      [[NSFileManager defaultManager] createDirectoryAtPath:@"var/mobile/Library/Preferences/Anchor2.0/layouts" withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/Anchor1.1"]) {
      PSSpecifier *convertCell = [self createSpecifierWithCell:PSButtonCell customClass:nil usingDefault:nil label:@"Convert Anchor 1.1 Layout" key:nil];
      [convertCell setButtonAction:@selector(convert)];
      [self insertSpecifier:convertCell atIndex:6];
      //[self insertSpecifier:[self createSpecifierWithCell:PSGroupCell customClass:nil usingDefault:nil label:@"" key:nil] atIndex:5];
    }
  });
  if (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/Anchor2.0/current"]) {
    [[NSFileManager defaultManager] createDirectoryAtPath:@"var/mobile/Library/Preferences/Anchor2.0/current" withIntermediateDirectories:YES attributes:nil error:nil];
  }
}
- (void)selectedLayout:(PSSpecifier *)sender {
  if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
    UIAlertView *nAlert = [[UIAlertView alloc] initWithTitle:@"Anchor" message:@"Please select an orientation to apply the layout to." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Portrait",@"Landscape",nil];
    nAlert.tag = 3;
    [nAlert show];
    [nAlert release];
  }
  else {
    UIAlertController *alertControl = [objc_getClass("UIAlertController") alertControllerWithTitle:@"Anchor" message:@"Please select an orientation to apply the layout to." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionR = [objc_getClass("UIAlertAction") actionWithTitle:@"Portrait" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){  
      [alertControl dismissViewControllerAnimated:YES completion:^{
      [alertControl release];
      }];
      //crashes?
      [self changeLayout:self.tempFileName Landscape:NO];
    }];
    UIAlertAction *actionRL = [objc_getClass("UIAlertAction") actionWithTitle:@"Landscape" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){  
      [alertControl dismissViewControllerAnimated:YES completion:^{
      [alertControl release];
      }];
      //crashes?
      [self changeLayout:self.tempFileName Landscape:YES];
    }];
    UIAlertAction *actionC = [objc_getClass("UIAlertAction") actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){  
      [alertControl dismissViewControllerAnimated:YES completion:^{
      [alertControl release];
      }];
    }];
    [alertControl addAction:actionR];
    [alertControl addAction:actionRL];
    [alertControl addAction:actionC];
    [(UIViewController *)self presentViewController:alertControl animated:YES completion:nil];
    alertControl.view.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
  }
}
- (void)changeLayout:(NSString *)fileName Landscape:(BOOL)landscape {
  NSString *key;
  (landscape)?key = @"layoutLandscape.plist":key = @"layoutPortrait.plist";
  NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/Anchor2.0/layouts/%@",fileName];
  NSData *data = [NSData dataWithContentsOfFile:path];
  [data writeToFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/Anchor2.0/current/%@",key] atomically:YES];
  CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"com.broganminer.anchor.updatelayout", NULL, NULL, TRUE);
}
- (id)createSpecifierWithCell:(PSCellType)cell customClass:(id)CClass usingDefault:(id)defaultValue label:(id)label key:(id)key{
  PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:label target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:cell edit:nil];
  [specifier setProperty:@YES forKey:@"enabled"];
  if(defaultValue)[specifier setProperty:defaultValue forKey:@"default"];
  if(key)[specifier setProperty:@"com.broganminer.anchor" forKey:@"defaults"];
  if(key)[specifier setProperty:key forKey:@"key"];
  if (CClass)[specifier setProperty:NSClassFromString(CClass) forKey:@"cellClass"];
  return specifier;
}
- (void)setPreferenceValue:(id)val specifier:(PSSpecifier *)spec {
  if ([spec propertyForKey:@"cellClass"] == [AnchorSwitch class] && [[spec propertyForKey:@"key"] isEqual:@"enable"]) {
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
      valForAV = val;
      specForAV = spec;
      UIAlertView *alertForSwitch = [[UIAlertView alloc] initWithTitle:@"Anchor" message:@"You need to respring to enable/disable anchor" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Respring",nil];
      alertForSwitch.tag = 1;
      [alertForSwitch show];
      [alertForSwitch release];
    }
    else {
      UIAlertController *alertControl = [objc_getClass("UIAlertController") alertControllerWithTitle:@"Anchor" message:@"You need to respring to enable/disable anchor" preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *actionR = [objc_getClass("UIAlertAction") actionWithTitle:@"Respring" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){  
        [alertControl dismissViewControllerAnimated:YES completion:^{
          [alertControl release];
        }];
        [super setPreferenceValue:val specifier:spec];
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"com.broganminer.anchor.respring", NULL, NULL, TRUE);
      }];
      UIAlertAction *actionC = [objc_getClass("UIAlertAction") actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){  
        [alertControl dismissViewControllerAnimated:YES completion:^{
          [alertControl release];
        }];
        ((UISwitch *)[spec propertyForKey:@"control"]).on = !((UISwitch *)[spec propertyForKey:@"control"]).on;
      }];
      [alertControl addAction:actionR];
      [alertControl addAction:actionC];
      
      [(UIViewController *)self presentViewController:alertControl animated:YES completion:nil];
      alertControl.view.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    }
  }
  else {
    [super setPreferenceValue:val specifier:spec];
  }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == 1) {
    if (buttonIndex == 1) {
      [super setPreferenceValue:valForAV specifier:specForAV];
      CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"com.broganminer.anchor.respring", NULL, NULL, TRUE);
    }
    else {
      ((UISwitch *)[specForAV propertyForKey:@"control"]).on = !((UISwitch *)[specForAV propertyForKey:@"control"]).on;
    }
    specForAV = nil;
    valForAV = nil;
  }
  if (alertView.tag == 2) {
    if (buttonIndex == 1) {
      [self resetR];
    }
  }
  if (alertView.tag == 3) {
    if (buttonIndex == 1) {
      [self changeLayout:self.tempFileName Landscape:NO];
    }
    if (buttonIndex == 2) {
      [self changeLayout:self.tempFileName Landscape:YES];
    }
  }
  if (alertView.tag == 4) {
    if (buttonIndex == 1) {
      [self save:[alertView textFieldAtIndex:0].text asLandscape:NO];
    }
    if (buttonIndex == 2) {
      [self save:[alertView textFieldAtIndex:0].text asLandscape:YES];
    }
  }
}

- (void)reset {
  if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
    UIAlertView *alertForSwitch = [[UIAlertView alloc] initWithTitle:@"Anchor" message:@"Are you sure you want to delete your current layout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    alertForSwitch.tag = 2;
    [alertForSwitch show];
    [alertForSwitch release];
  }
  else {
    UIAlertController *alertControl = [objc_getClass("UIAlertController") alertControllerWithTitle:@"Anchor" message:@"Are you sure you want to delete your current layout?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionR = [objc_getClass("UIAlertAction") actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){  
      [alertControl dismissViewControllerAnimated:YES completion:^{
      [alertControl release];
      }];
      [self resetR];
    }];
    UIAlertAction *actionC = [objc_getClass("UIAlertAction") actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){  
      [alertControl dismissViewControllerAnimated:YES completion:^{
      [alertControl release];
      }];
    }];
    [alertControl addAction:actionR];
    [alertControl addAction:actionC];
    [(UIViewController *)self presentViewController:alertControl animated:YES completion:nil];
    alertControl.view.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
  }
  
}
- (void)resetR {
  [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"layoutLancape" inDomain:@"com.broganminer.anchor"];
  [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"layoutPortrait" inDomain:@"com.broganminer.anchor"];
  [[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Library/Preferences/Anchor2.0/current" error:NULL];
  [[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Library/SpringBoard/IconSupportState.plist" error:NULL];
  [[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Library/SpringBoard/DesiredIconSupportState.plist" error:NULL];
  CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"com.broganminer.anchor.reset", NULL, NULL, TRUE);
}
- (void)dealloc {
  [_gif release];
  _gif = nil;
  [_textContainer release];
  _textContainer = nil;
  [_titleLabel release];
  _titleLabel = nil;
  [_animated release];
  _animated = nil;
  [super dealloc];
}

@end
// vim:ft=objc
