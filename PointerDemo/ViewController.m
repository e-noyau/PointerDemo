#import "ViewController.h"

static UIBezierPath *star(CGSize size) {
  CGFloat dimension = MAX(size.width, size.height);
  CGFloat cornerRadius = dimension / 20;
  CGFloat rotation = 54;
  
  CGPoint center = { size.width / 2, size.height / 2 };
  CGFloat radius = dimension / 2;
  CGFloat rn = radius - cornerRadius;

  UIBezierPath *path = [[UIBezierPath alloc] init];
  for (int i = 0; i < 5; ++i) {
    CGPoint cc = {
      .x = center.x + rn * cos(rotation * M_PI / 180),
      .y = center.y + rn * sin(rotation * M_PI / 180)
    };

    CGPoint p = {
      .x = cc.x + cornerRadius * cos((rotation - 72) * M_PI / 180),
      .y = cc.y + cornerRadius * sin((rotation - 72) * M_PI / 180)
    };

    if (!i) {
      [path moveToPoint:p];
    } else {
      [path addLineToPoint:p];
    }

    [path addArcWithCenter:cc
                    radius:cornerRadius
                startAngle:(rotation - 72) * M_PI / 180
                  endAngle:(rotation + 72) * M_PI / 180
                 clockwise:YES];

    // Repeat 5 times.
    rotation += 144;
  }
  [path closePath];

  return path;
}

static UIPointerShape *starPointer(CGSize size) {
  return [UIPointerShape shapeWithPath:star(size)];
}

struct ButtonConfig {
  NSString *title;
  UIButtonPointerStyleProvider block;
};

const struct ButtonConfig configs[] = {
  {
    .title = @"Default",
    .block = nil,
  },
  {
    .title = @"Lifted",
    .block = ^UIPointerStyle*(UIButton* button, UIPointerEffect* __,
                       UIPointerShape* proposedShape) {
      UITargetedPreview* preview =
          [[UITargetedPreview alloc] initWithView:button];
      UIPointerLiftEffect* effect =
          [UIPointerLiftEffect effectWithPreview:preview];
      return [UIPointerStyle styleWithEffect:effect shape:proposedShape];
    },
  },
  {
    .title = @"Star Shaped",
    .block = ^UIPointerStyle*(UIButton* button, UIPointerEffect* proposedEffect,
                         UIPointerShape* __) {
      CGRect rect = button.frame;
      return [UIPointerStyle
          styleWithEffect:proposedEffect
                    shape:starPointer(rect.size)];
    },
  },
  {
    .title = @"Hover",
    .block = ^UIPointerStyle*(UIButton* button, UIPointerEffect* proposedEffect,
                       UIPointerShape* proposedShape) {
      UITargetedPreview* preview =
          [[UITargetedPreview alloc] initWithView:button];
      UIPointerHoverEffect* effect =
          [UIPointerHoverEffect effectWithPreview:preview];
      return [UIPointerStyle
          styleWithEffect:effect
                    shape:nil];  // Not setting it to nil makes it jump around!
    },
  },
  {
    .title = @"Funky Hover",
    .block = ^UIPointerStyle*(UIButton* button, UIPointerEffect* __,
                          UIPointerShape* proposedShape) {
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
      effect.prefersShadow = YES;
      effect.prefersScaledContent = YES;

      UIPointerShape *shape = starPointer(CGSizeMake(20,20));

      return [UIPointerStyle styleWithEffect:effect shape:shape];
    },
  },

};


@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  UIStackView *stackView = [[UIStackView alloc] init];
  stackView.axis = UILayoutConstraintAxisVertical;
  stackView.distribution = UIStackViewDistributionEqualSpacing;
  stackView.alignment = UIStackViewAlignmentCenter;
  stackView.spacing = 42;

  for (int ii = 0; ii < sizeof(configs) / sizeof(struct ButtonConfig); ++ii) {
    UIStackView *sub = [[UIStackView alloc] init];
    sub.distribution = UIStackViewDistributionEqualSpacing;
    sub.alignment = UIStackViewAlignmentCenter;
    sub.spacing = 42;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:configs[ii].title forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    button.pointerInteractionEnabled = YES;
    button.pointerStyleProvider = configs[ii].block;
    [sub addArrangedSubview:button];
    
    UIButton *info = [UIButton buttonWithType:UIButtonTypeInfoLight];
    info.pointerInteractionEnabled = YES;
    info.pointerStyleProvider = configs[ii].block;
    [sub addArrangedSubview:info];

    [stackView addArrangedSubview:sub];
    stackView.translatesAutoresizingMaskIntoConstraints = false;
  }
  
  [self.view addSubview:stackView];
  
  stackView.translatesAutoresizingMaskIntoConstraints = false;
  [stackView.centerXAnchor
      constraintEqualToAnchor:self.view.centerXAnchor].active = true;
  [stackView.centerYAnchor
      constraintEqualToAnchor:self.view.centerYAnchor].active = true;
}


@end
