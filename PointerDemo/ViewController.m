#import "ViewController.h"

static UIBezierPath *star(CGSize size) {
  CGFloat dimension = MIN(size.width, size.height) * 1.3;
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
    .block = ^UIPointerStyle*(
        UIButton* button,
        __unused UIPointerEffect* proposedEffect,
        UIPointerShape* proposedShape) {
      UITargetedPreview* preview =
          [[UITargetedPreview alloc] initWithView:button];
      UIPointerLiftEffect* effect =
          [UIPointerLiftEffect effectWithPreview:preview];
      return [UIPointerStyle styleWithEffect:effect shape:nil];
    },
  },
  {
    .title = @"Star Shaped",
    .block = ^UIPointerStyle*(
        UIButton* button,
        UIPointerEffect* proposedEffect,
        __unused UIPointerShape* proposedShape) {
      CGRect rect = button.frame;
      return [UIPointerStyle
          styleWithEffect:proposedEffect
                    shape:starPointer(rect.size)];
    },
  },
  {
    .title = @"Hover",
    .block = ^UIPointerStyle*(
        UIButton* button,
        __unused UIPointerEffect* proposedEffect,
        __unused UIPointerShape* proposedShape) {
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
    .block = ^UIPointerStyle*(
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
      effect.prefersShadow = YES;
      effect.prefersScaledContent = YES;

      UIPointerShape *shape = starPointer(CGSizeMake(20,20));

      return [UIPointerStyle styleWithEffect:effect shape:shape];
    },
  },

};


@implementation ViewController

// Returns a flat blue button with rounded corners.
+ (UIButton *)flatButton {
  UIButton* flatButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [flatButton setTitle:@"Enable AutoFill…!"
                       forState:UIControlStateNormal];
  flatButton.contentEdgeInsets =
      UIEdgeInsetsMake(17, 20, 17, 20);
  [flatButton setBackgroundColor:[UIColor colorNamed:@"blue_color"]];
  UIColor* titleColor = [UIColor colorNamed:@"solid_button_text_color"];
  [flatButton setTitleColor:titleColor forState:UIControlStateNormal];
  flatButton.titleLabel.font =
      [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
  flatButton.layer.cornerRadius = 13;
  flatButton.titleLabel.adjustsFontForContentSizeCategory = NO;
  flatButton.translatesAutoresizingMaskIntoConstraints = NO;
  flatButton.pointerInteractionEnabled = YES;
  flatButton.pointerStyleProvider = ^UIPointerStyle*(
      UIButton* button, UIPointerEffect* proposedEffect,
      __unused UIPointerShape* proposedShape) {
    return [UIPointerStyle styleWithEffect:proposedEffect shape:nil];
  };
  return flatButton;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // A big vertical stack view hold a few horizontal stack views with three
  // buttons each, in different forms.
  UIStackView *stackView = [[UIStackView alloc] init];
  stackView.axis = UILayoutConstraintAxisVertical;
  stackView.distribution = UIStackViewDistributionFillEqually;
  stackView.alignment = UIStackViewAlignmentCenter;
  stackView.spacing = 7;
  [self.view addSubview:stackView];

  for (int ii = 0; ii < sizeof(configs) / sizeof(struct ButtonConfig); ++ii) {
    UIStackView *sub = [[UIStackView alloc] init];
    sub.distribution = UIStackViewDistributionFillEqually;
    sub.alignment = UIStackViewAlignmentCenter;
    sub.spacing = 42;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:configs[ii].title forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    button.pointerInteractionEnabled = YES;
    button.pointerStyleProvider = configs[ii].block;
    [sub addArrangedSubview:button];
    
    UIButton* primaryActionButton = [[self class] flatButton];
    [primaryActionButton setTitle:@"Action!"
                         forState:UIControlStateNormal];
    primaryActionButton.pointerStyleProvider = configs[ii].block;
    [sub addArrangedSubview:primaryActionButton];

    UIButton *info = [UIButton buttonWithType:UIButtonTypeInfoLight];
    info.pointerInteractionEnabled = YES;
    info.pointerStyleProvider = configs[ii].block;
    [sub addArrangedSubview:info];

    [stackView addArrangedSubview:sub];
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    
    [NSLayoutConstraint activateConstraints:@[
      [sub.leadingAnchor
       constraintEqualToAnchor:stackView.leadingAnchor],
      [sub.trailingAnchor
          constraintEqualToAnchor:stackView.trailingAnchor],
    ]];

  }
  
  // How to use a subview as a target
  UIButton *custom = [UIButton buttonWithType:UIButtonTypeSystem];
  [custom setTitle:@"Snap on image" forState:UIControlStateNormal];
  [custom setImage:[UIImage systemImageNamed:@"pencil.tip"]
          forState:UIControlStateNormal];
  custom.pointerInteractionEnabled = YES;
  custom.pointerStyleProvider = ^UIPointerStyle*(
      UIButton* button,
      __unused UIPointerEffect* proposedEffect,
      __unused UIPointerShape* proposedShape) {
    
    UITargetedPreview* preview =
        [[UITargetedPreview alloc] initWithView:button.imageView];
    UIPointerHighlightEffect* effect =
        [UIPointerHighlightEffect effectWithPreview:preview];
    UIPointerShape *shape = starPointer(button.imageView.frame.size);
    return [UIPointerStyle styleWithEffect:effect shape:shape];
  };

  UIButton *yoloButton = [[self class] flatButton];
  [stackView addArrangedSubview:yoloButton];
  
  [NSLayoutConstraint activateConstraints:@[
    [NSLayoutConstraint constraintWithItem:yoloButton
     attribute:NSLayoutAttributeWidth
     relatedBy:NSLayoutRelationEqual
        toItem:stackView
     attribute:NSLayoutAttributeWidth
    multiplier:.3
      constant:0],
    [NSLayoutConstraint constraintWithItem:yoloButton
    attribute:NSLayoutAttributeHeight
                  relatedBy:NSLayoutRelationEqual
    toItem:nil
    attribute:NSLayoutAttributeNotAnAttribute
    multiplier:1.0
    constant:50.0],
  ]];

  UIButton *flatButton = [[self class] flatButton];

  [self.view addSubview:flatButton];

  stackView.translatesAutoresizingMaskIntoConstraints = NO;
  stackView.layoutMarginsRelativeArrangement = YES;
  stackView.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(0, 0, 10, 0);
  [NSLayoutConstraint activateConstraints:@[
    [stackView.leadingAnchor
     constraintEqualToAnchor:self.view.leadingAnchor],
    [stackView.trailingAnchor
        constraintEqualToAnchor:self.view.trailingAnchor],
    [stackView.bottomAnchor constraintLessThanOrEqualToAnchor:flatButton.topAnchor],
    [stackView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
  ]];
  
  [NSLayoutConstraint activateConstraints:@[
    [NSLayoutConstraint constraintWithItem:flatButton
     attribute:NSLayoutAttributeWidth
     relatedBy:NSLayoutRelationEqual
        toItem:stackView
     attribute:NSLayoutAttributeWidth
    multiplier:.8
      constant:0],
    [flatButton.bottomAnchor
    constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
    [flatButton.centerXAnchor constraintEqualToAnchor:stackView.centerXAnchor],
  ]];


}


@end
