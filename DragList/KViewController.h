//
//  KViewController.h
//  DragList
//
//  Created by Kevin on 12-12-27.
//  Copyright (c) 2012年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "KRefreshTableView.h"

@interface KViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DataUpdateCallback>
{
    NSMutableArray* aryItems;
    
    
}

@property (retain, nonatomic) IBOutlet KRefreshTableView *MyTableView;

@end
