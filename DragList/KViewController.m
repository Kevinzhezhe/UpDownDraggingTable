//
//  KViewController.m
//  DragList
//
//  Created by Kevin on 12-12-27.
//  Copyright (c) 2012年 Kevin. All rights reserved.
//

#import "KViewController.h"

#define ITEM_HEIGHT 50

@interface KViewController ()

@end

@implementation KViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Create some test data
    aryItems = [NSMutableArray arrayWithCapacity:0];
    [aryItems retain];
    
    for (int i = 0; i < 5; i++) {
        NSString* str = [NSString stringWithFormat:@"item %d", i];
        [aryItems addObject:str];
    }
    
    //Initialize
    [_MyTableView initTable: aryItems];

    
    _MyTableView.delegate = self;
    [_MyTableView setDataSource:self];
    //set delegate to get data
    [_MyTableView setMyDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_MyTableView release];
    [aryItems release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMyTableView:nil];
    [super viewDidUnload];
}


// caller of KRefreshTableView needs to implement protocol DataUpdateCallback::updateData()
- (int) updateData:(BOOL)header
{
    if (header) {
        for (int i = 4; i > 0; i--) {
            NSString* str = [NSString stringWithFormat:@"item header %d", i];
            [aryItems insertObject:str atIndex:0];
        }
        return 4;
    }
    else
    {
        for (int i = 1; i < 10; i++) {
            NSString* str = [NSString stringWithFormat:@"item footer %d", i];
            [aryItems addObject:str];
        }
        return 9;
    }
}



#pragma mark -- table view delegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

#pragma mark -- DataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [aryItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (cell) {
        UILabel* label = (UILabel*)[cell viewWithTag:1];
        
        NSString* item = [aryItems objectAtIndex: indexPath.row];
        [label setText:item];
    }
    
    return cell;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_MyTableView myScrollViewDidScroll:scrollView];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_MyTableView myScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
}

@end
