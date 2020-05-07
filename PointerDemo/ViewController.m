#import "ViewController.h"

#import "ExplainMeButton.h"
#import "PointerStyle.h"

@interface ViewController ()
// A flat blue button with rounded corners.
+ (ExplainMeButton *)flatButtonWithTitle:(NSString *)title
                            style:(UIButtonPointerStyleProvider)provider
                            hover:(NSString *)explain;

// A round button with a (i) image inside
+ (ExplainMeButton *)infoButtonWithStyle: (UIButtonPointerStyleProvider)provider
hover:(NSString *)explain;

// Just the text.
+ (ExplainMeButton *)buttonWithTitle:(NSString *)title
                              style:(UIButtonPointerStyleProvider)provider
                              hover:(NSString *)explain;

// With an image as well.
+ (ExplainMeButton *)decoratedButtonWithTitle:(NSString *)title
                                 style:(UIButtonPointerStyleProvider)provider
                                 hover:(NSString *)explain;

+ (ExplainMeButton *)disabledButton;

@end


@implementation ViewController

// Returns a flat blue button with rounded corners.
+ (ExplainMeButton *)flatButtonWithTitle:(NSString *)title
                            style:(UIButtonPointerStyleProvider)provider
                            hover:(NSString *)explain {
  ExplainMeButton* flatButton = [ExplainMeButton buttonWithType:UIButtonTypeSystem];
  [flatButton setTitle:title forState:UIControlStateNormal];
  flatButton.explain = explain;
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
  if (provider)
    flatButton.pointerStyleProvider = provider;
  return flatButton;
}

+ (ExplainMeButton *)infoButtonWithStyle:(UIButtonPointerStyleProvider)provider
hover:(NSString *)explain {
  ExplainMeButton *info = [ExplainMeButton buttonWithType:UIButtonTypeInfoLight];
  info.explain = explain;
  info.pointerInteractionEnabled = YES;
  if (provider)
    info.pointerStyleProvider = provider;
  return info;
}

+ (ExplainMeButton *)buttonWithTitle:(NSString *)title
                        style:(UIButtonPointerStyleProvider)provider
                        hover:(NSString *)explain {
  ExplainMeButton *button = [ExplainMeButton buttonWithType:UIButtonTypeSystem];
  [button setTitle:title forState:UIControlStateNormal];
  button.explain = explain;
  button.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
  button.pointerInteractionEnabled = YES;
  if (provider)
    button.pointerStyleProvider = provider;
  return button;
}

+ (ExplainMeButton *)decoratedButtonWithTitle:(NSString *)title
                                 style:(UIButtonPointerStyleProvider)provider
                                 hover:(NSString *)explain {
  ExplainMeButton *custom = [ExplainMeButton buttonWithType:UIButtonTypeSystem];
  [custom setTitle:title forState:UIControlStateNormal];
  [custom setImage:[UIImage systemImageNamed:@"pencil.tip"]
          forState:UIControlStateNormal];
  custom.explain = explain;
  custom.pointerInteractionEnabled = YES;
  custom.pointerStyleProvider = provider;
  return custom;
}

+ (ExplainMeButton *)disabledButton {
  ExplainMeButton *button = [ExplainMeButton buttonWithType:UIButtonTypeSystem];
  [button setTitle:@""
          forState:UIControlStateNormal];
  button.explain = @"";
  button.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
  button.pointerInteractionEnabled = YES;
  button.enabled = NO;
  return button;

}

+ (NSArray<NSArray<ExplainMeButton*>*>*)model {
  NSString *wowString =
    @"These three 'Wow!' buttons are all identical. The exact same code "
    @"creates them, the only difference is their width. And the pointer effect "
    @"is affected by the size. The top button on an iPad in portrait mode is "
    @"the intended effect. The hover is not what is intended.";

  return @[
    @[
      [self buttonWithTitle:@"Default"
                      style:nil
                      hover:
       @"Simple default effect of a highlight with a rounded rect around the "
       @"label, ideal for buttons with no background."],
      [self flatButtonWithTitle:@"Default"
                          style:nil
                          hover:
       @"If a background color is present, the highlight loses its rounded "
       @"rect and gets a square, still only around the label."],
      [self infoButtonWithStyle:nil hover:
       @"This 'typeinfolight' button is getting a circular hover, but the "
       @"circular gray highlight is calculated based on the width…"],
    ],
    @[
      [self buttonWithTitle:@"Star Shape"
                      style:StyleStarShape()
                      hover:
       @"This effect keeps the default effect and only replaces the shape by a "
       @"star. this one is the default highlight, with the button morphing "
       @"into a star."],
      [self flatButtonWithTitle:@"Starry!" style:StyleStarShape() hover:
       @"Same here, reshaping the highlight as a star."],
      [self infoButtonWithStyle:StyleStarShape() hover:
       @"Using the right sized shape makes this more interesting to look at."],
    ],
    @[
      [self buttonWithTitle:@"Lifted Default Shape"
                      style:StyleLiftedDefaultShape()
                      hover:
       @"The somewhat expected effect, with the button lifting and a shadow."],
      [self flatButtonWithTitle:@"Failed lift!"
                          style:StyleLiftedDefaultShape()
                          hover:
       @"Here the lift failed, and the button is doing a highlight instead."],
      [self infoButtonWithStyle:StyleLiftedDefaultShape()
                          hover:
       @"This button doesn't like the lift, and does an unexpected hover "
       @"instead."],
    ],
    @[
      [self buttonWithTitle:@"Lifted Rounded Shape"
                      style:StyleLiftedRoundedShape(RectSourceButton)
                      hover:
       @"Not really a difference with the previous one."],
      [self flatButtonWithTitle:@"Buggy!"
                          style:StyleLiftedRoundedShape(RectSourceButton)
                          hover:
       @"Here we hit an issue. The desired lift is not happening, and it "
       @"is replaced by a hover, lifting the button, but keeping the pointer "
       @"alive."],
      [self infoButtonWithStyle:StyleLiftedRoundedShape(RectSourceButtonCircle)
                          hover:
       @"Finally, a proper lift. As this button is not square the shaping of "
       @"the pointer need to be done via code."],
    ],
    @[
      [self buttonWithTitle:@"Hover" style:StyleHover() hover:
       @"What is more boring than a hover? Another hover…"],
      [self flatButtonWithTitle:@"boring" style:StyleHover() hover:
       @"What is more boring than a hover? Another hover…"],
      [self infoButtonWithStyle:StyleHover() hover:
       @"What is more boring than a hover? Another hover…"],
    ],
    @[ [[self class] disabledButton] ],
    @[
        [self decoratedButtonWithTitle:@"Snap to image"
                                 style:StyleHighlightImageOnly()
                                 hover:
         @"A little jarring, jumping away from where you are to there and "
         @"back again."],
    ],
    @[ [[self class] disabledButton], ],
    @[
      [[self class] disabledButton],
      [[self class] disabledButton],
      [self flatButtonWithTitle:@"Wow!"
                          style:StyleLiftedRoundedShape(RectSourceButton)
                          hover:wowString],
      [[self class] disabledButton],
      [[self class] disabledButton],
    ],
    @[
      [[self class] disabledButton],
      [self flatButtonWithTitle:@"Wow!"
                          style:StyleLiftedRoundedShape(RectSourceButton)
                          hover:wowString],
      [self flatButtonWithTitle:@"Wow!"
                          style:StyleLiftedRoundedShape(RectSourceButton)
                          hover:wowString],
      [[self class] disabledButton],
    ],
  ];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  
  // A big vertical stack view hold a few horizontal stack views with three
  // buttons each, in different forms.
  UIStackView *stackView = [[UIStackView alloc] init];
  stackView.translatesAutoresizingMaskIntoConstraints = NO;
  stackView.axis = UILayoutConstraintAxisVertical;
  stackView.alignment = UIStackViewAlignmentCenter;
  stackView.spacing = 20;
  stackView.layoutMarginsRelativeArrangement = YES;
  stackView.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(0, 0, 10, 0);

  [self.view addSubview:stackView];
  
  UILabel *label = [[UILabel alloc] init];
  label.text = @"placeholder";
  label.numberOfLines = 0;
  label.lineBreakMode = NSLineBreakByWordWrapping;
  label.textAlignment = NSTextAlignmentCenter;
  [stackView addArrangedSubview:label];

  for (NSArray<ExplainMeButton *> *buttons in [[self class] model]) {
    UIStackView *sub = [[UIStackView alloc] init];
    sub.translatesAutoresizingMaskIntoConstraints = NO;
    sub.distribution = UIStackViewDistributionFillEqually;
    sub.alignment = UIStackViewAlignmentCenter;
    sub.spacing = 42;

    for (ExplainMeButton *button in buttons) {
      button.explainTarget = label;
      [sub addArrangedSubview:button];
    }
    [stackView addArrangedSubview:sub];
    
    [NSLayoutConstraint activateConstraints:@[
      [sub.leadingAnchor
       constraintEqualToAnchor:stackView.leadingAnchor],
      [sub.trailingAnchor
          constraintEqualToAnchor:stackView.trailingAnchor],
    ]];
  }
  
  [NSLayoutConstraint activateConstraints:@[
    [stackView.leadingAnchor
     constraintEqualToAnchor:self.view.leadingAnchor],
    [stackView.trailingAnchor
        constraintEqualToAnchor:self.view.trailingAnchor],
    [stackView.bottomAnchor constraintLessThanOrEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
    [stackView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
  
    [NSLayoutConstraint constraintWithItem:label
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeHeight
                                multiplier:.15
                                  constant:0],
  ]];
}


@end
