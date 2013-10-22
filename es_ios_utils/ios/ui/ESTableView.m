#import "ESTableView.h"

@interface ESTableView()
  @property(strong) NSString* reuseIdentifier;
@end

@implementation ESTableView

@synthesize /*private*/ reuseIdentifier;
@synthesize esDelegate;

-(id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.delegate = self;
        self.dataSource = self;
        self.reuseIdentifier = NSString.stringWithUUID;
    }
    return self;
}

#pragma mark - Data

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if([esDelegate respondsToSelector:@selector(sectionTitles)])
        return esDelegate.sectionTitles.count;
    return esDelegate.numberOfSections;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [esDelegate numberOfRowsInSection:section];
}

-(NSString*)tableView:(UITableView*)tv titleForHeaderInSection:(NSInteger)s
{
    if([esDelegate respondsToSelector:@selector(sectionTitles)])
        return [esDelegate.sectionTitles objectAtIndex:s];
    return [esDelegate esTitleForSection:s];
}


#pragma mark - View

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)ip
{
    
    UITableViewCell* c = [self dequeueReusableCellWithIdentifier:self.reuseIdentifier] ?: esDelegate.createCell;
    [esDelegate updateCell:c for:[esDelegate objectFor:ip]];
    return c;
}

-(CGFloat)tableView:(UITableView*)tv heightForRowAtIndexPath:(NSIndexPath*)ip
{
    if([esDelegate respondsToSelector:@selector(heightForSelectedState)] && [ip isEqual:self.indexPathForSelectedRow])
       return esDelegate.heightForSelectedState;
    return self.rowHeight;
}

#pragma mark - Events

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)ip
{
    if([esDelegate respondsToSelector:@selector(didSelectRowAt:for:)])
        [esDelegate didSelectRowAt:ip for:[esDelegate objectFor:ip]];
    if([esDelegate respondsToSelector:@selector(didSelectRowAt:)])
        [esDelegate didSelectRowAt:ip];
}

-(void)tableView:(UITableView*)tableView didDeselectRowAtIndexPath:(NSIndexPath*)ip
{
    if([esDelegate respondsToSelector:@selector(didDeselectRowAt:)])
        [esDelegate didDeselectRowAt:ip];
}

@end
