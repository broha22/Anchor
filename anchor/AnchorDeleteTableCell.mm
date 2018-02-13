#import "AnchorListController.h"
@implementation AnchorDeleteTableCell

- (id)initWithStyle:(NSInteger)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3{
  self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
  if(self) {
    _specifier = arg3;
    _swipeDelete = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showDelete)];
    _swipeDelete.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:_swipeDelete];
    _tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hitLink)];
    [self addGestureRecognizer:_tapped];
  }
  return self;
}

- (void)showDelete {
  if(!_deleteVisible) {
    _deleteButton = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width,0,0,self.frame.size.height)];
    _deleteButton.backgroundColor = [UIColor colorWithRed:63.f/255.f green:180.f/255.f blue:212.f/255.f alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,_deleteButton.frame.size.height)];
    label.text = @"Reset";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    _deleteButton.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(intermission)];
    [_deleteButton addGestureRecognizer:tapGesture];
    [_deleteButton addSubview:label];
    [self addSubview:_deleteButton];
    _deleteVisible = YES;
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationCurveEaseIn animations:^{
	self.frame = CGRectMake(self.frame.origin.x-100,self.frame.origin.y,self.frame.size.width+100,self.frame.size.height);
	_deleteButton.frame = CGRectMake(self.frame.size.width-100,0,100,self.frame.size.height);
      }
      completion:^(BOOL finnished){
    }];
    self.enabled = NO;
  }
}

- (void)intermission {
  if(SYSTEM_VERSION_LESS_THAN(@"8.0")) {
  UIAlertView *alertForSwitch = [[UIAlertView alloc] initWithTitle:@"Reset Page?" message:@"Resetting this page will delete your current layout." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Reset",nil];
  alertForSwitch.tag = 1;
  [alertForSwitch show];
  [alertForSwitch release];
  }
  else {
  UIAlertController *alertControl = [objc_getClass("UIAlertController") alertControllerWithTitle:@"Reset Page?" message:@"Resetting this page will delete your current layout." preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *actionYES = [objc_getClass("UIAlertAction") actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
    [self deleteCell:YES];
    [alertControl dismissViewControllerAnimated:YES completion:^{
    [alertControl release];
    }];
  }];
  UIAlertAction *actionNO = [objc_getClass("UIAlertAction") actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){  
    [alertControl dismissViewControllerAnimated:YES completion:^{
    [alertControl release];
    }];
  }];
  [alertControl addAction:actionYES];
  [alertControl addAction:actionNO];
  alertControl.view.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
  [(UIViewController *)[_specifier target] presentViewController:alertControl animated:YES completion:nil];
  }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == 1) {
    if (buttonIndex == 1)[self deleteCell:YES];
  }
}
- (void)deleteCell:(BOOL)next {  
  [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"var/mobile/Library/Preferences/Anchor1.1/Pages/%@",[_specifier propertyForKey:@"fileName"]] error:nil];
  CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"com.broganminer.anchor.reset", NULL, NULL, TRUE);
  if(next)[self hitLink];
}

- (void)hitLink {
  if (_deleteVisible) {
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationCurveEaseIn animations:^{
	self.frame = CGRectMake(self.frame.origin.x+100,self.frame.origin.y,self.frame.size.width-100,self.frame.size.height);
	_deleteButton.frame = CGRectMake(self.frame.size.width,0,0,self.frame.size.height);
      }
      completion:^(BOOL finnished){
	[_deleteButton removeFromSuperview];
	[_deleteButton release];
	_deleteButton = nil;
	_deleteVisible = NO;
     }];
  }
  else {
    [self launchEditView];
  }
}

- (id)viewControllerForEditView {
  if (_editController == nil) {
    _editController = [[UIViewController alloc] init];
    CGRect parentFrame = (((UIViewController *)[_specifier target]).view).frame;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))_editController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    _editController.view.frame = CGRectMake(parentFrame.size.width/5,parentFrame.size.height/4,3*(parentFrame.size.width/5),2*(parentFrame.size.height/4));
    _editController.modalPresentationStyle =  UIModalPresentationCustom;
    if(SYSTEM_VERSION_LESS_THAN(@"8.0"))[_editController setTransitioningDelegate:self];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))_editController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
  
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width/2)-((parentFrame.size.width-40)/2),parentFrame.origin.y+70,parentFrame.size.width-40,parentFrame.size.height-100)];
    bg.backgroundColor = [UIColor colorWithRed:0.937f green:0.937f blue:0.937f alpha:1];
    bg.layer.cornerRadius = 20.0f;
    [_editController.view addSubview:bg];
  
    UIView *fakeNav = [[UIView alloc] initWithFrame:CGRectMake(0,0,bg.frame.size.width,44)];
    fakeNav.backgroundColor = [UIColor colorWithRed:63.f/255.f green:180.f/255.f blue:212.f/255.f alpha:1];
    bg.clipsToBounds = YES;
    [bg addSubview:fakeNav];
  
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,fakeNav.frame.size.width,fakeNav.frame.size.height)];
    label.textColor = [UIColor whiteColor];
    label.text = ((UITableViewCell *)self).textLabel.text;
    label.textAlignment = NSTextAlignmentCenter;
    [fakeNav addSubview:label];
  
    UIButton *done = [UIButton buttonWithType:UIButtonTypeSystem];
    [done setTitle:@"Done" forState:UIControlStateNormal];
    [done setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    done.frame = CGRectMake(fakeNav.frame.size.width-80,7,70,30);
    [done addTarget:self action: @selector(dismissEditView) forControlEvents: UIControlEventTouchUpInside];
    [fakeNav addSubview:done];
  
    UITableView *mainView = [[UITableView alloc] initWithFrame:CGRectMake(8,44,bg.frame.size.width-16,bg.frame.size.height-15) style:UITableViewStyleGrouped];
    mainView.backgroundView = nil;
    mainView.backgroundColor = [UIColor clearColor];
    mainView.delegate = self;
    mainView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainView.dataSource = self;
    mainView.showsVerticalScrollIndicator = NO;
    [bg addSubview:mainView];
  }
  return _editController;
}

- (void)launchEditView {
  [(UIViewController *)[_specifier target] presentViewController:[self viewControllerForEditView] animated:YES completion:nil];
}

- (void)dismissEditView {
  [_editController dismissViewControllerAnimated:YES completion:^{
    [_editController release];
    _editController = nil;
  }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return (section==1)? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([indexPath compare:[NSIndexPath indexPathForRow:0 inSection:0]] == NSOrderedSame) {
    return [[AnchorFakeHomeCell alloc] initWithDefaults:_specifier];
  }/*
  if ([indexPath compare:[NSIndexPath indexPathForRow:1 inSection:0]] == NSOrderedSame) {
    return [[AnchorFakeHomeCellCompany alloc] initWithDefaults];
  }*/
  else if ([indexPath compare:[NSIndexPath indexPathForRow:1 inSection:1]] == NSOrderedSame) {
    return [[AnchorPoppedButtonCell alloc] initWithStyle:1 specifier:_specifier];
  }
  else {
    return [[AnchorPoppedButtonCell alloc] initWithStyle:0 specifier:_specifier];
  }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([indexPath compare:[NSIndexPath indexPathForRow:0 inSection:0]] == NSOrderedSame) {
    return 450;
  }/*
  else if ([indexPath compare:[NSIndexPath indexPathForRow:1 inSection:0]] == NSOrderedSame) {
    return 80;
  }*/
  else {
    return 44;
  }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
            CGFloat cornerRadius = 5.f;
            cell.backgroundColor = UIColor.clearColor;
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 5, 0);
            BOOL addLine = NO;
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            } else if (indexPath.row == 0) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                    addLine = YES;
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            } else {
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            layer.path = pathRef;
            CFRelease(pathRef);
            layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;

            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+5, bounds.size.height-lineHeight, bounds.size.width-5, lineHeight);
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                [layer addSublayer:lineLayer];
            }
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
            cell.layer.masksToBounds = YES;
}
- (id)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    //controller.isPresenting = YES;
    return self;
}

- (id)animationControllerForDismissedController:(UIViewController *)dismissed {
//I will fix it later.
//    AnimatedTransitioning *controller = [[AnimatedTransitioning alloc]init];
//    controller.isPresenting = NO;
//    return controller;
    return nil;
}

- (id)interactionControllerForPresentation:(id)animator {
    return nil;
}

- (id)interactionControllerForDismissal:(id)animator {
    return nil;
}
- (NSTimeInterval)transitionDuration:(id)transitionContext {
    return 0.25f;
}

- (void)animateTransition:(id)transitionContext {
    
    UIView *inView = [transitionContext containerView];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [inView addSubview:toVC.view];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [toVC.view setFrame:CGRectMake(0, screenRect.size.height, fromVC.view.frame.size.width, fromVC.view.frame.size.height)];
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         
                         [toVC.view setFrame:CGRectMake(0, 0, fromVC.view.frame.size.width, fromVC.view.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}
@end