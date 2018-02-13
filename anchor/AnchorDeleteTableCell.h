@interface AnchorDeleteTableCell : PSTableCell <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning> {
  UISwipeGestureRecognizer *_swipeDelete;
  UITapGestureRecognizer *_tapped;
  BOOL _deleteVisible;
  UIView *_deleteButton;
  PSSpecifier *_specifier;
  UIViewController *_editController;
}
- (id)viewControllerForEditView;
- (void)launchEditView;
- (void)deleteCell:(BOOL)next;
- (id)initWithStyle:(NSInteger)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3;
@end