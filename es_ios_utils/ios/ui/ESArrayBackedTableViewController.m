#import "ESArrayBackedTableViewController.h"

@interface ESArrayBackedTableViewController()
  @property(retain) NSMutableArray* sectionTitles;
  @property(retain) NSMutableArray* sectionData;
  @property(retain) NSArray* originalCellData;
@end

@implementation ESArrayBackedTableViewController

@synthesize cellData, textKey, detailKey;
@synthesize sectionTitles, sectionData, originalCellData;

-(BOOL)usesSections
{
    return sectionData.isNotEmpty && [sectionData.first isKindOfClass:NSArray.class];
}

-(NSMutableArray*)sectionDataFor:(int)s
{
    return [sectionData objectAtIndex:s];
}

-(id)dataAtIndexPath:(NSIndexPath*)ip
{
    if(self.usesSections)
        return [[self sectionDataFor:ip.section] objectAtIndex:ip.row];
    return [cellData objectAtIndex:ip.row];
}

-(void)convertToAlphaIndex
{
    sectionTitles = NSMutableArray.new;
    sectionData   = NSMutableArray.new;
    
    [cellData each:^(id o) {
        NSString* text = [o valueForKey:textKey];
        NSString* sectionTitle = [text substringToIndex:1];
        if(![sectionTitle isEqualToString:sectionTitles.last])
        {
            [sectionTitles addObject:sectionTitle];
            [sectionData addObject:NSMutableArray.new];
        }
        NSMutableArray* section = sectionData.last;
        [section addObject:o];
    }];
}

-(void)configureCellForData:(id)o
{
    int i = [self.cellData indexOfObject:o];
    UITableViewCell* c = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    [self configureCell:c withData:o];
}

-(void)configureCell:(UITableViewCell*)c withData:(id)o
{
    c.textLabel.text       = [o valueForKey:textKey];
    c.detailTextLabel.text = [o valueForKey:detailKey];
}

-(void)didSelectCellWithData:(id)o { }


#pragma mark - Table view data source

-(int)numberOfSectionsInTableView:(UITableView*)tv
{
    return self.usesSections ? sectionData.count : 1;
}

-(NSString*)tableView:(UITableView*)tv titleForHeaderInSection:(int)s
{
    return self.usesSections ? [sectionTitles objectAtIndex:s] : nil;
}

-(int)tableView:(UITableView*)tv numberOfRowsInSection:(int)s
{
    return self.usesSections ? [self sectionDataFor:s].count : cellData.count;
}

-(UITableViewCell*)tableView:(UITableView*)tv cellForRowAtIndexPath:(NSIndexPath*)ip
{
    UITableViewCell *c = [tv dequeueReusableCellWithIdentifier:@"Cell"];
    [self configureCell:c withData:[self dataAtIndexPath:ip]];
    return c;
}

-(void)tableView:(UITableView*)tv didSelectRowAtIndexPath:(NSIndexPath*)ip
{
    [self didSelectCellWithData:[self.cellData objectAtIndex:ip.row]];
}

-(BOOL)isUsingSearchAndIndex
{
    return self.usesSections && sectionTitles && [self.view containsSubviewWithKindOfClass:UISearchBar.class];
}
-(NSArray*)sectionIndexTitlesForTableView:(UITableView*)tv
{
    NSArray* indexTitles = self.usesSections ? sectionTitles : nil;
    if(self.isUsingSearchAndIndex)
        indexTitles = [NSArray arrayByCoalescing:UITableViewIndexSearch, indexTitles, nil];
    return indexTitles;
}

-(int)tableView:(UITableView*)tv sectionForSectionIndexTitle:(NSString*)t atIndex:(int)i
{
    if(self.isUsingSearchAndIndex)
    {
        if(i==0)
            [self.tableView scrollToTop];
        return i-1;
    }
    return i;
}

-(void)searchBar:(UISearchBar*)sb textDidChange:(NSString*)searchText
{
    if(!originalCellData)
        self.originalCellData = cellData;
    self.cellData = searchText.isNotEmpty ? [originalCellData filteredArrayWhereKeyPath:self.textKey containsIgnoreCase:searchText] : originalCellData;
    [self convertToAlphaIndex];
    [self.tableView reloadData];
}

-(void)searchBarCancelButtonClicked:(UISearchBar*)sb
{
    sb.text = NSString.string;
    self.cellData = originalCellData;
    [self convertToAlphaIndex];
    [self.tableView reloadData];
    [sb resignFirstResponder];
}

@end
