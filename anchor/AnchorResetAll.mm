#import "AnchorListController.h"
#import <objc/message.h>
@implementation AnchorResetAll

- (id)initWithStyle:(NSInteger)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3{
  self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
  if(self) {
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  ((UITableViewCell *)self).textLabel.textColor = [UIColor redColor];
  ((UITableViewCell *)self).textLabel.textAlignment = NSTextAlignmentCenter;
  ((UITableViewCell *)self).textLabel.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
}

@end
@implementation AnchorSave

- (id)initWithStyle:(NSInteger)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3{
  self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
  if(self) {
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  //((UITableViewCell *)self).textLabel.textColor = [UIColor redColor];
  ((UITableViewCell *)self).textLabel.textAlignment = NSTextAlignmentCenter;
  ((UITableViewCell *)self).textLabel.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
}

@end
@implementation AnchorDeletable

- (id)initWithStyle:(NSInteger)arg1 reuseIdentifier:(id)arg2 specifier:(PSSpecifier *)arg3{
  self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
  if(self) {
  	_swipeDelete = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showDelete)];
    _swipeDelete.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:_swipeDelete];
    _oldTarget = [arg3 target];
    _oldSelector = [arg3 buttonAction];
    [arg3 setTarget:self];
    [arg3 setButtonAction:@selector(hit)];
    _specifier = arg3;
    //[(UIControl *)self removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
  }
  return self;
}
- (void)hit {
	if (_deleteShowing) {
		[UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationCurveEaseIn animations:^{
			self.frame = CGRectMake(self.frame.origin.x+100,self.frame.origin.y,self.frame.size.width-100,self.frame.size.height);
			_deleteButton.frame = CGRectMake(self.frame.size.width,0,0,self.frame.size.height);
      	}
      	completion:^(BOOL finnished){
			[_deleteButton removeFromSuperview];
			[_deleteButton release];
			_deleteButton = nil;
			_deleteShowing = NO;
     	}];
	}
	else {
    if([_specifier isKindOfClass:[PSSpecifier class]])((AnchorListController *)_oldTarget).tempFileName = [_specifier propertyForKey:@"fileName"];
		objc_msgSend(_oldTarget,_oldSelector);
    //NSLog(@"hi");
	}
}
- (void)showDelete {
	if (!_deleteShowing) {
		_deleteButton = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width,0,0,self.frame.size.height)];
    	_deleteButton.backgroundColor = [UIColor colorWithRed:63.f/255.f green:180.f/255.f blue:212.f/255.f alpha:1];
    	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,_deleteButton.frame.size.height)];
    	label.text = @"Delete";
    	label.textColor = [UIColor whiteColor];
    	label.textAlignment = NSTextAlignmentCenter;
    	label.userInteractionEnabled = YES;
    	_deleteButton.userInteractionEnabled = YES;
    	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(intermission)];
    	[_deleteButton addGestureRecognizer:tapGesture];
    	[_deleteButton addSubview:label];
    	[self addSubview:_deleteButton];
    	[UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationCurveEaseIn animations:^{
			self.frame = CGRectMake(self.frame.origin.x-100,self.frame.origin.y,self.frame.size.width+100,self.frame.size.height);
			_deleteButton.frame = CGRectMake(self.frame.size.width-100,0,100,self.frame.size.height);
      	}
      	completion:^(BOOL finnished){
      		_deleteShowing = YES;
    	}];
	}
}
- (void)deleteCell {
	if (_deleteShowing) {
		NSError *error;
		[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"var/mobile/Library/Preferences/Anchor2.0/layouts/%@",[_specifier propertyForKey:@"fileName"]] error:&error];
		[_oldTarget removeSpecifier:_specifier];
		//NSLog(@"oka %@",[error description]);
	}
}
- (void)intermission {
	if(SYSTEM_VERSION_LESS_THAN(@"8.0")) {
  		UIAlertView *alertForSwitch = [[UIAlertView alloc] initWithTitle:@"Anchor" message:@"Are you sure you want to delete this layout?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete",nil];
  		alertForSwitch.tag = 1;
  		[alertForSwitch show];
  		[alertForSwitch release];
  	}
  	else {
  		UIAlertController *alertControl = [objc_getClass("UIAlertController") alertControllerWithTitle:@"Anchor" message:@"Are you sure you want to delete this layout?" preferredStyle:UIAlertControllerStyleAlert];
  		UIAlertAction *actionYES = [objc_getClass("UIAlertAction") actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
    		[self deleteCell];
   	 		[alertControl dismissViewControllerAnimated:YES completion:^{
   				[alertControl release];
    		}];
  		}];
  		UIAlertAction *actionNO = [objc_getClass("UIAlertAction") actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){  
    		[self hit];
    		[alertControl dismissViewControllerAnimated:YES completion:^{
    			[alertControl release];
    			
    		}];
  		}];
  		[alertControl addAction:actionYES];
  		[alertControl addAction:actionNO];
  		
  		[(UIViewController *)_oldTarget presentViewController:alertControl animated:YES completion:nil];
  		alertControl.view.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
 	 }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == 1) {
    if (buttonIndex == 1) {
    	[self deleteCell];
    }
    else {
    	[self hit];
    }
  }
}
- (void)layoutSubviews {
  [super layoutSubviews];
  ((UITableViewCell *)self).textLabel.textColor = [UIColor blackColor];
  //((UITableViewCell *)self).textLabel.textAlignment = NSTextAlignmentCenter;
  //((UITableViewCell *)self).textLabel.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
  //[(UIControl *)self removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
  //[(UIControl *)self addTarget:self action:@selector(hit) forControlEvents:UIControlEventTouchUpInside];
}

@end