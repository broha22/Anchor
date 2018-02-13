static BOOL enable(void) {
    NSNumber *enable = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enable" inDomain:@"com.broganminer.anchor"];
    return (enable)? [enable boolValue]:YES;
}
static BOOL rotation(void) {
	NSNumber *enable = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"rotation" inDomain:@"com.broganminer.anchor"];
    return (enable)? [enable boolValue]:YES;
}