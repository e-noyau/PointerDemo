#import "StarPath.h"

UIBezierPath *StarPath(CGSize size) {
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
