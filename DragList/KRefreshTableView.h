//
//  KRefreshTableView.h
//  DragList
//
//  Created by Kevin on 12-12-28.
//  Copyright (c) 2012 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

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
