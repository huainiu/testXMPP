//
//  ContactViewController.h
//  testXMPP
//
//  Created by yangjiannan on 4/23/13.
//  Copyright (c) 2013 techrare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ContactViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,  NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *fetchedResultsController;
}
@property(retain ,nonatomic) IBOutlet UITableView *tableView;
@property(retain, nonatomic)IBOutlet UISegmentedControl *segCtl;
@end
