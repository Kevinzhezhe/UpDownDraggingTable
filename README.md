UpDownDraggingTable
===================

I got a table which supports drag down on internet, named EGORefreshTableHeaderView.
then I did something to support both drag down and drag up based on EGORefreshTableHeaderView.

I encapsulated a class named KRefreshTableView which was derived from UITableView.
with this class, it's very easy to support drag down and up.

The header file looks like this:

@protocol DataUpdateCallback <NSObject>  // define a protocol, the caller needs to provide data

@required
- (int) updateData: (BOOL) header;

@end

@interface KRefreshTableView : UITableView <EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;  // header
    EGORefreshTableHeaderView *_refreshFooterView;  // footer
    
	BOOL _reloading;
}

@property(retain, nonatomic) id<DataUpdateCallback> MyDelegate;
@property(retain, nonatomic) id Items;

- (void) initTable: (id) TableItems;
- (void) myScrollViewDidScroll:(UIScrollView *)scrollView;
- (void) myScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end

For more details, please see the source code.
