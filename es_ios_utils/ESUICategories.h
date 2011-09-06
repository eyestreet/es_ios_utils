#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// The class is here to force the linker to load categories
@interface ESUICategories : NSObject
@end

typedef void(^ESUICellBlock)(UITableViewCell*);
typedef void(^ESUIIndexPathBlock)(NSIndexPath*);

@interface NSNotification(ESUtils)
    //For UIKeyboard* notifications, otherwise an exception is raised.
    //Use convertRect:fromView: or convertRect:fromWindow: to rotate to current orientation
    @property(readonly) CGSize keyboardSize;
@end


@interface UIActionSheet(ESUtils)
  -(void)cancel:(BOOL)animated;
  -(void)cancel;
@end


@interface UIAlertView(ESUtils)
    +(UIAlertView*)createAndShowWithTitle:(NSString*)title message:(NSString*)message buttonTitle:(NSString*)button;
@end


@interface UIBarButtonItem(ESUtils)
    +(UIBarButtonItem*)barButtonItemWithCustomView:(UIView*)v;
    +(UIBarButtonItem*)barButtonItemWithTitle:(NSString*)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
    +(UIBarButtonItem*)barButtonItemWithBarButtonSystemItem:(UIBarButtonSystemItem)item target:(id)target action:(SEL)action;
@end


@interface UIDevice(ESUtils)
+(BOOL)isPad;
+(BOOL)isPhone;
@end


@interface UILabel(ESUtils)
    +(UILabel*)labelWithText:(NSString*)text;
    +(UILabel*)labelWithBoldText:(NSString*)text;
@end


@interface UINavigationController(ESUtils)
    +(UINavigationController*)navigationControllerWithRootViewController:(UIViewController*)vc;
@end


@interface UINavigationItem(ESUtils)
    -(void)configureWithTitle:(NSString*)title leftItem:(UIBarButtonItem*)left rightItem:(UIBarButtonItem*)right;
    -(void)setRightBarButtonItems:(NSArray*)items;
@end


@interface UIPopoverController(ESUtils)
    +(UIPopoverController*)popoverControllerWithContentViewController:(UIViewController *)viewController;
    +(UIPopoverController*)popoverControllerWithNavigationAndContentViewController:(UIViewController*)viewController;
@end


@interface UITableViewCell(ESUtils)
    +(UITableViewCell*)cellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier;
@end

@interface UIToolbar(ESUtils)
    +(UIToolbar*)toolbarWithItems:(NSArray*)items;
@end

@interface UIView(ESUtils)
    // These sizing convenience methods manipulate the frame.
    @property(assign) float   width;
    @property(assign) float   height;
    @property(assign) float   x;
    @property(assign) float   y;
    @property(assign) CGSize  size;
    @property(assign) CGPoint origin;

    @property(nonatomic, readonly) BOOL isInPopover;

    -(void)replaceInSuperviewWith:(UIView*)v;
@end

@interface UIViewController(ESUtils)
    //Passed Apple's review. Prefixed with a $ to indicate undocumented api and to prevent conflict with key.
    @property(nonatomic, readonly) UIPopoverController *$popoverController;
    
    // Forces without using a private api.
    -(void)forcePortrait;

    //If iPad, use popover, else push
    -(void)popOrDismiss;
    -(void)popoverFromBarButtonItem:(UIBarButtonItem*)button;
    -(void)pushOrPopoverInViewController:(UIViewController*)parent fromBarButtonItem:(UIBarButtonItem*)button;
    -(void)pushOrPopoverInViewController:(UIViewController*)parent from:(CGRect)r;
    -(void)pushOrPopoverInViewController:(UIViewController*)parent from:(CGRect)r permittedArrowDirections:(UIPopoverArrowDirection)directions;
    @property(nonatomic, readonly) UIWindow* window;
@end

@interface UITextField (ESUtils)
    // Passed Apple's review.
    @property(assign) UIColor *placeholderColor;

    // Call in viewWillAppear to vertially center.
    // Reset in textFieldShouldClear: and shouldChangeCharactersInRange to prevent resetting.
    @property(assign) UIFont  *placeholderFont;
@end

@interface UITableView(ESUtils)
@property(readonly) BOOL isEmpty;
@property(readonly) BOOL isNotEmpty;
    -(UITableViewCell*)cellForRow:(int)r inSection:(int)s;
    -(UITableViewCell*)cellForRow:(int)r;
    -(void)doForEachCellInSection:(int)s action:(ESUICellBlock)action;
    -(void)doForEachIndexPathInSection:(int)s action:(ESUIIndexPathBlock)action;
    -(void)insertRowAtIndexPath:(NSIndexPath*)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
    -(void)insertRow:(int)r inSection:(int)s withRowAnimation:(UITableViewRowAnimation)animation;
    -(void)insertRow:(int)r withRowAnimation:(UITableViewRowAnimation)animation;
    -(void)insertSection:(int)s withRowAnimation:(UITableViewRowAnimation)a;
    -(void)scrollToRow:(int)r inSection:(int)s atScrollPosition:(UITableViewScrollPosition)p animated:(BOOL)a;
    -(void)scrollToRow:(int)r atScrollPosition:(UITableViewScrollPosition)p animated:(BOOL)a;
    -(void)deleteRowAtIndexPath:(NSIndexPath*)i withRowAnimation:(UITableViewRowAnimation)a;
    -(void)deleteRow:(int)r inSection:(int)s withRowAnimation:(UITableViewRowAnimation)a;
    -(void)deleteRow:(int)r withRowAnimation:(UITableViewRowAnimation)a;
    -(void)deleteSection:(int)s withRowAnimation:(UITableViewRowAnimation)a;
@end

@interface UIWindow(ESUtils)
    @property(nonatomic, readonly) BOOL isDisplayingAlert;
@end