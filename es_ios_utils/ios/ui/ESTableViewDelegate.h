#import <Foundation/Foundation.h>

@protocol ESTableViewDelegate<NSObject>
  #pragma mark - Data
    @required
      -(id)objectFor:(NSIndexPath*)ip;
      -(int)numberOfRowsInSection:(int)s;
    @optional
      // Either sectionTitles or numberOfSections and esTitleForSection must be implemented
      -(NSArray*)sectionTitles;
      -(int)numberOfSections;
      -(NSString*)esTitleForSection:(int)s; // renamed with es prefix to avoid validation warnings about a conflict with an apple private method

  #pragma mark - View
    @required
      -(UITableViewCell*)createCell;
      -(void)updateCell:(UITableViewCell*)c for:(id)o;
    @optional
      -(float)heightForSelectedState;

  #pragma mark - Events
    @optional
      -(void)didSelectRowAt:(NSIndexPath*)ip;
      -(void)didSelectRowAt:(NSIndexPath*)ip for:(id)o;
      -(void)didDeselectRowAt:(NSIndexPath*)indexPath;
@end
