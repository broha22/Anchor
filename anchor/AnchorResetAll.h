@interface AnchorResetAll : PSTableCell {
}
- (id)initWithStyle:(NSInteger)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3;
@end
@interface AnchorSave : PSTableCell {
}
- (id)initWithStyle:(NSInteger)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3;
@end
@interface AnchorDeletable : PSTableCell <UIAlertViewDelegate> {
	PSSpecifier *_specifier;
}
@property (nonatomic, assign) UISwipeGestureRecognizer *swipeDelete;
@property (nonatomic, assign) UIView *deleteButton;
@property BOOL deleteShowing;
@property SEL oldSelector;
@property (nonatomic, assign) id oldTarget;
- (id)initWithStyle:(NSInteger)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3;
@end
@interface UIView (an)
@property UIColor *interactionTintColor;
@end