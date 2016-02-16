//
//  ListViewController.h
//  BPMNScan
//
//  Created by Smiljan Kerencic on 29/12/15.
//  Copyright © 2015 Aventa Plus d.o.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPMNElement.h"
@interface ListViewController : UIViewController

@property (nonatomic) NSString *selectedItem;
@property(nonatomic, retain) IBOutlet UITableView *tableView;

@end
