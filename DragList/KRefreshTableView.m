//
//  KRefreshTableView.m
//  DragList
//
//  Created by Kevin on 12-12-28.
//  Copyright (c) 2012 Kevin. All rights reserved.
//

#import "KRefreshTableView.h"

@implementation KRefreshTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (void)dealloc
{
    [self.MyDelegate release];
    [self.Items release];
    
    [super dealloc];
}

#pragma mark -- Handle drag down and up  －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
//Put footer at the end of table
- (void) putFooterAtEnd
{
    CGRect footerFrame = _refreshFooterView.frame;
    CGRect r = CGRectMake(footerFrame.origin.x, self.contentSize.height, self.frame.size.width, footerFrame.size.height);
    
    if (r.origin.y < self.frame.size.height) {
        r.origin.y = self.frame.size.height;
    }
    _refreshFooterView.frame = r;
}

- (void) showHeaderAndFooter
{
    if (_refreshHeaderView == nil) {
		_refreshHeaderView = [[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height) IsHeader: YES] autorelease];
		_refreshHeaderView.delegate = self;
		[self addSubview:_refreshHeaderView];  // add Header control into table
	}
    [_refreshHeaderView refreshLastUpdatedDate];
    
    if (_refreshFooterView == nil) {
		_refreshFooterView = [[[EGORefreshTableHeaderView alloc] initWithFrame:
                              CGRectMake(0, -1000, self.frame.size.width, self.bounds.size.height) IsHeader: NO] autorelease];
		_refreshFooterView.delegate = self;
        [self addSubview:_refreshFooterView];
        
        [self putFooterAtEnd];  // adjust the position of footer
	}
    [_refreshFooterView refreshLastUpdatedDate];
    
}

//it will be called in main thread
- (void) finishedLoadMoreHeaderData: (NSNumber*) num
{
    //reload data
    [self reloadData];
    
    [self putFooterAtEnd];
    
    [_refreshHeaderView refreshLastUpdatedDate];  // update last modifed time
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    _reloading = NO;
}

//this function will be called in main thread
- (void) finishedLoadMoreFooterData: (NSNumber*) num
{
    [self reloadData];
    
    [self putFooterAtEnd];
    
    //locate to the item before dragging
    NSMutableArray* ary = self.Items;
    unsigned long prevNum = [ary count]  - num.intValue;  // get the item count before dragging
    if (prevNum >= 1) {
        NSIndexPath* row = [NSIndexPath indexPathForRow:prevNum - 1 inSection:0];
        //locate
        [self scrollToRowAtIndexPath:row atScrollPosition:UITableViewScrollPositionNone animated:NO];
        
    }
    
    [num release];
    
    [_refreshFooterView refreshLastUpdatedDate];
    
    _reloading = NO;
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    
}


//get new data from caller, mostly it will be run in a new thread
- (void) GetMoreHeaderData
{
    @autoreleasepool {
        [self.MyDelegate updateData:YES];  // get data from delegate
        
        //need to update ui on main thread
        [self performSelectorOnMainThread:@selector(finishedLoadMoreHeaderData:) withObject:nil waitUntilDone:YES];
    }
}

//get new data fro footer, mostly it will be run in a new thread (not main thread)
- (void) GetMoreFooterData
{
    @autoreleasepool {
        int ret = [self.MyDelegate updateData:NO];
        NSNumber* number = [NSNumber numberWithInt:ret];
        [number retain];
        
        [self performSelectorOnMainThread:@selector(finishedLoadMoreFooterData:) withObject:number waitUntilDone:YES];
    }
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    if (view == _refreshFooterView) {
        NSLog(@"It's footer");
        
        _reloading = YES;  // set a flag to avoid that there are multiple refreshing tasks
        
        //start a thread to get data
        [NSThread detachNewThreadSelector:@selector(GetMoreFooterData) toTarget:self withObject:nil];
    }
    
    if (view == _refreshHeaderView) {
        NSLog(@"It's header");
        
        _reloading = YES;
        
        [NSThread detachNewThreadSelector:@selector(GetMoreHeaderData) toTarget:self withObject:nil];
    }
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading;
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date];  // get current time, this will be shown as "last updated time"
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods


// this function will be called when user scrolls table.
- (void) myScrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
}

// tell delegate that dragging finished
- (void) myScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
}


- (void) initTable: (id) TableItems
{
    _reloading = NO;
    [self setItems:TableItems];
    
    [self showHeaderAndFooter];  // create and show header/footer controls.
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
