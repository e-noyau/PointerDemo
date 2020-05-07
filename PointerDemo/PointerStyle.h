#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RectSource) {
    RectSourceButton = 0,    // Take the button.frame
    RectSourceButtonCircle,  // Reduce to a circle
    RectSourceImage,         // use the button.imageView
} API_AVAILABLE(ios(13.4)) API_UNAVAILABLE(watchos, tvos) NS_REFINED_FOR_SWIFT;

extern UIButtonPointerStyleProvider StyleLiftedDefaultShape(void);
extern UIButtonPointerStyleProvider StyleLiftedRoundedShape(RectSource source);
extern UIButtonPointerStyleProvider StyleStarShape(void);
extern UIButtonPointerStyleProvider StyleHover(void);
extern UIButtonPointerStyleProvider StyleHoverStarShape(void);
extern UIButtonPointerStyleProvider StyleHighlightDefaultShape(void);
extern UIButtonPointerStyleProvider StyleHighlightImageOnly(void);
