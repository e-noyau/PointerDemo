#import "PointerStyle.h"

#import "StarPath.h"

// Give this app a little bit of star feel.
static UIPointerShape *StarPointer(CGSize size) {
  return [UIPointerShape shapeWithPath:StarPath(size)];
}

UIButtonPointerStyleProvider StyleLiftedDefaultShape(void) {
  return ^UIPointerStyle*(
      UIButton* button,
      __unused UIPointerEffect* proposedEffect,
      UIPointerShape* proposedShape) {
    UITargetedPreview* preview = [[UITargetedPreview alloc] initWithView:button];
    UIPointerLiftEffect* effect = [UIPointerLiftEffect effectWithPreview:preview];
    return [UIPointerStyle styleWithEffect:effect shape:proposedShape];
  };
}

UIButtonPointerStyleProvider StyleLiftedRoundedShape(RectSource source) {
  return ^UIPointerStyle*(
      UIButton* button,
      __unused UIPointerEffect* proposedEffect,
      __unused UIPointerShape* proposedShape) {
    UIView *sourceView = source == RectSourceImage? button.imageView : button;
    UITargetedPreview* preview = [[UITargetedPreview alloc] initWithView:sourceView];
    UIPointerLiftEffect* effect = [UIPointerLiftEffect effectWithPreview:preview];
    CGRect rect = sourceView.frame;
    CGFloat radius = button.layer.cornerRadius;
    if (source == RectSourceButtonCircle) {
      CGFloat minSize = MIN(rect.size.height, rect.size.width);
      rect = CGRectInset(rect,
                         (rect.size.width - minSize) / 2,
                         (rect.size.height - minSize) / 2);
      radius = minSize / 2;
    }
    UIPointerShape *shape =
      [UIPointerShape shapeWithRoundedRect:rect
                              cornerRadius:radius];
    return [UIPointerStyle styleWithEffect:effect shape:shape];
  };
}

UIButtonPointerStyleProvider StyleStarShape(void) {
  return ^UIPointerStyle*(
      UIButton* button,
      UIPointerEffect* proposedEffect,
      __unused UIPointerShape* proposedShape) {
    CGRect rect = button.frame;
    return [UIPointerStyle
        styleWithEffect:proposedEffect
                  shape:StarPointer(rect.size)];
  };
}

UIButtonPointerStyleProvider StyleHover(void) {
  return ^UIPointerStyle*(
      UIButton* button,
      __unused UIPointerEffect* proposedEffect,
      __unused UIPointerShape* proposedShape) {
    UITargetedPreview* preview = [[UITargetedPreview alloc] initWithView:button];
    UIPointerHoverEffect* effect = [UIPointerHoverEffect effectWithPreview:preview];
    return [UIPointerStyle styleWithEffect:effect shape:nil];
  };
}

UIButtonPointerStyleProvider StyleHoverStarShape(void) {
  return ^UIPointerStyle*(
      UIButton* button,
      __unused UIPointerEffect* proposedEffect,
      __unused UIPointerShape* proposedShape) {
    UIPreviewParameters *parameters = [[UIPreviewParameters alloc] init];
    parameters.visiblePath = [UIBezierPath bezierPathWithRect:
                              CGRectInset(button.bounds, -20, -20)];
    parameters.backgroundColor = [UIColor redColor];  // No effect

    UITargetedPreview* preview =
        [[UITargetedPreview alloc] initWithView:button
                                     parameters:parameters];

    UIPointerHoverEffect* effect =
        [UIPointerHoverEffect effectWithPreview:preview];
    effect.preferredTintMode = UIPointerEffectTintModeNone;
    effect.prefersShadow = NO;
    effect.prefersScaledContent = YES;

    UIPointerShape *shape = StarPointer(CGSizeMake(20,20));

    return [UIPointerStyle styleWithEffect:effect shape:shape];
  };
}

UIButtonPointerStyleProvider StyleHighlightDefaultShape(void) {
  return ^UIPointerStyle*(
      UIButton* button,
      __unused UIPointerEffect* proposedEffect,
      UIPointerShape* proposedShape) {
    UITargetedPreview* preview = [[UITargetedPreview alloc] initWithView:button];
    UIPointerHighlightEffect* effect =
        [UIPointerHighlightEffect effectWithPreview:preview];
    return [UIPointerStyle styleWithEffect:effect shape:proposedShape];
  };
}

UIButtonPointerStyleProvider StyleHighlightImageOnly(void) {
  return ^UIPointerStyle*(
      UIButton* button,
      __unused UIPointerEffect* proposedEffect,
      __unused UIPointerShape* proposedShape) {
    UITargetedPreview* preview =
        [[UITargetedPreview alloc] initWithView:button.imageView];
    UIPointerHighlightEffect* effect =
        [UIPointerHighlightEffect effectWithPreview:preview];
    UIPointerShape *shape = StarPointer(button.imageView.frame.size);
    return [UIPointerStyle styleWithEffect:effect shape:shape];
  };
}
