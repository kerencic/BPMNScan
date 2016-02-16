//
//  ListViewController.m
//  BPMNScan
//
//  Created by Smiljan Kerencic on 29/12/15.
//  Copyright © 2015 Aventa Plus d.o.o. All rights reserved.
//

#import "ListViewController.h"
#import "BPMNElement.h"
#import "UIColor+AventaPlus.h"

@interface ListViewController ()
{
    int selectedIndex;
}

@property (nonatomic, strong) NSArray *allResultItems;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedIndex = 0;
    
    self.title = @"BPMN Elements";
    
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor AP_basicOrangeColorWithTransparent:1.0];
    
    [self.tableView setContentOffset:CGPointZero animated:NO];
    
    _allResultItems = [BPMNElement plistAllBPMNElements];
    [self.tableView reloadData];
    
    [self findItemIndex];
}

- (void)findItemIndex {
    if (self.selectedItem.length > 5) {
        for (int i = 0; i < _allResultItems.count; i++) {
            BPMNElement *singleBPMNElement = [[BPMNElement alloc] init];
            singleBPMNElement = [_allResultItems objectAtIndex:i];
            if ([[singleBPMNElement valueForKey:@"elementId"] isEqualToString:self.selectedItem ]) {
                selectedIndex = i;
            }
        }
        [self goToItemAtIndex];
    }
}

- (void)goToItemAtIndex {
    if (selectedIndex > 0) {
        [self.tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:selectedIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        self.selectedItem = @"";
        selectedIndex = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _allResultItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAttributedString *attributedText;
    
    CGFloat height = 90;
    CGFloat minHeight = 70;
    CGSize size;
    CGFloat textFieldWidth = 0;
    
    BPMNElement *singleBPMNElement = [[BPMNElement alloc] init];
    singleBPMNElement = [_allResultItems objectAtIndex:indexPath.row];
    
    attributedText = [[NSAttributedString alloc] initWithString:[singleBPMNElement valueForKey:@"elementDescription"] attributes:@{ NSFontAttributeName: [UIFont fontWithName:@"Avenir-Light" size:17.0f]}];
     textFieldWidth = [[UIScreen mainScreen] bounds].size.width-96;
     
     size = [attributedText boundingRectWithSize:(CGSize){textFieldWidth, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
    
    height = MAX(ceil((size.height + (70))), minHeight);
    
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listItem" forIndexPath:indexPath];
        if(cell == nil)
            cell = [tableView dequeueReusableCellWithIdentifier:@"listItem" forIndexPath:indexPath];
    
    UIImageView *mainItemImageView = (UIImageView*)[cell viewWithTag:1];
    UILabel* titleLabel = (UILabel*)[cell viewWithTag:2];
    UILabel* subtitleLabel = (UILabel*)[cell viewWithTag:3];
    UILabel* idLabel = (UILabel*)[cell viewWithTag:4];
 
    BPMNElement *singleBPMNElement = [[BPMNElement alloc] init];
    singleBPMNElement = [_allResultItems objectAtIndex:indexPath.row];
    
    titleLabel.text = [singleBPMNElement valueForKey:@"elementName"];
    subtitleLabel.text = [singleBPMNElement valueForKey:@"elementDescription"];
    
    
    UIImage *image = [UIImage imageNamed:[singleBPMNElement valueForKey:@"elementImageName"]];
    CGSize size = CGSizeMake(image.size.height/1.5, image.size.width/1.5);
   
    [mainItemImageView setImage:[self resizeImage:image imageSize:size]];
    
    idLabel.text = [[singleBPMNElement valueForKey:@"elementId"] substringFromIndex:MAX((int)[[singleBPMNElement valueForKey:@"elementId"] length]-4, 0)];
    
    cell.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)/*size*/ newSize
{
    float width = newSize.width;
    float height = newSize.height;
    
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    //indent in case of width or height difference
    float offset = (width - height) / 2;
    if (offset > 0) {
        rect.origin.y = offset;
    }
    else {
        rect.origin.x = -offset;
    }
    
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
    
}


@end
