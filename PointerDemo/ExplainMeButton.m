#import "ExplainMeButton.h"

@interface ExplainMeButton() {
  UIHoverGestureRecognizer *_hover;
}

// Callback from the gesture recognizer.
- (void)explain:(UIHoverGestureRecognizer *)hover;
@end

@implementation ExplainMeButton

@synthesize explainTarget = _explainTarget;

- (void)setExplainTarget:(UILabel *)explainTarget{
  _explainTarget = explainTarget;
  if (!_explainTarget && _hover) {
    [self removeGestureRecognizer:_hover];
    _hover = nil;
  }
  if (_explainTarget && !_hover) {
    _hover = [[UIHoverGestureRecognizer alloc]
        initWithTarget:self action:@selector(explain:)];
    [self addGestureRecognizer:_hover];
    
  }
}
  
- (void)explain:(UIHoverGestureRecognizer *)hover {
  switch (hover.state) {
    case UIGestureRecognizerStateBegan:
    case UIGestureRecognizerStateChanged:
      [self.explainTarget setText:self.explain];
      break;
    case UIGestureRecognizerStateEnded:
    case UIGestureRecognizerStateCancelled:
      [self.explainTarget setText:@""];
      break;
    default:
      break;
  }
}

@end
