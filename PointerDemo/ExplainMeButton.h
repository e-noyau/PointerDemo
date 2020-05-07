#import <UIKit/UIKit.h>

// A button with an optional "explaining" text field where an text can be
// written when a mouse hover on the button.
@interface ExplainMeButton : UIButton
@property(nonatomic) NSString *explain;
@property(nonatomic) UILabel *explainTarget;
@end
