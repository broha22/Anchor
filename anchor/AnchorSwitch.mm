#import "AnchorListController.h"
@implementation AnchorSwitch
- (id)initWithStyle:(NSInteger)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3{
    self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
    if (self) {
    }
    return self;
}
- (void)layoutSubviews {
  [super layoutSubviews];
  ((UITableViewCell *)self).accessoryView.tintColor = [UIColor colorWithRed:63.f/255.f green:180.f/255.f blue:212.f/255.f alpha:1];
  ((UISwitch *)((UITableViewCell *)self).accessoryView).onTintColor = [UIColor colorWithRed:63.f/255.f green:180.f/255.f blue:212.f/255.f alpha:1];
}
@end