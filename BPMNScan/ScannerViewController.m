#import "ScannerViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "AYGestureHelpView.h"
#import "CNPPopupController.h"
#import "UIColor+AventaPlus.h"
#import "ListViewController.h"
 
#import <CraftAROnDeviceRecognitionSDK/CraftARSDK.h>
#import <CraftAROnDeviceRecognitionSDK/CraftARCollectionManager.h>
#import <CraftAROnDeviceRecognitionSDK/CraftAROnDeviceIR.h>

#import "BPMNElement.h"

#define ON_DEVICE_COLLECTION_TOKEN  @"6a9fae5d6e4c4b78"
 

 @interface ScannerViewController () <CNPPopupControllerDelegate, UIActionSheetDelegate, CraftARSDKProtocol, SearchProtocol, UIScrollViewDelegate>
 {
     CraftARCollectionManager* mCollectionManager;
     CraftAROnDeviceIR* mOnDeviceIR;
     CraftARSDK *_sdk;
     CraftAROnDeviceIR *_oir;
     BPMNElement *singleBPMNElement;
     UIScrollView *scrollView;
     BOOL isSearching;
     NSInteger selectedBundle;
     UIPageControl *pageControl;
     UIView *mainView;
     BOOL didGetBack;
     int selectedItem;
 }

 @property (strong, nonatomic) UIView* imageView;
 @property (weak) IBOutlet UIButton *leftButton;
 @property (weak) IBOutlet UIButton *centerButton;
 @property (weak) IBOutlet UIButton *rightButton;
 @property (weak) IBOutlet UIButton *settingsButton;
 @property (weak) IBOutlet UIImageView *feriImageView;
 @property (weak) IBOutlet UIImageView *appLogoImageView;
 @property (weak) IBOutlet UIView *videoPreview;
 @property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonCollection;

 @property (nonatomic, strong) CNPPopupController *popupController;
 @property (nonatomic, strong) NSArray *allResultItems;
 @property (nonatomic, strong) AYGestureHelpView *helpView;
 @property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
 @end
 
 
 @implementation ScannerViewController {}
 
 - (IBAction)showHelpView:(id)sender {
     [self.helpView removeFromSuperview];
    // if (self.helpView == nil) {
         self.helpView = [AYGestureHelpView new];
         [self.helpView tapWithLabelText:NSLocalizedString(@"Tap to scan", nil) labelPoint:CGPointMake(self.view.center.x, self.view.center.y-130) touchPoint:self.view.center dismissHandler:^{
             [self previewTapped:self];
         } hideOnDismiss:YES];
    // }
 }

- (IBAction)hideHelpView:(id)sender {
    [self.helpView removeFromSuperview];
}

 ////////////////////////////////
 ////////////////////////////////
 
 - (void)showPopupWithStyle:(CNPPopupStyle)popupStyle {
 
     CNPPopupButton *button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-200)/2, 0, 200, 40)];

     [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
     [button setTitle:@"Close Me" forState:UIControlStateNormal];
     button.backgroundColor = [UIColor AP_basicOrangeColorWithTransparent:1.0];
     button.layer.cornerRadius = 4;
     button.selectionHandler = ^(CNPPopupButton *button){
         [self.popupController dismissPopupControllerAnimated:YES];
         [[_sdk getCamera] restartCapture];
         
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
             [self showHelpView:self];
         });
     };

     mainView = [[UIView alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width)/2, 0, [[UIScreen mainScreen] bounds].size.width-30, 300)];
 //    mainView.backgroundColor = [UIColor greenColor];

    [self initializeForView:mainView];
     
     // Init Page Control
     pageControl = [[UIPageControl alloc] init];
     pageControl.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-280)/2, 0, 280, 20);
     pageControl.numberOfPages = self.allResultItems.count;
     pageControl.currentPage = 0;
     [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
     pageControl.currentPageIndicatorTintColor = [UIColor AP_basicOrangeColorWithTransparent:1.0];
     pageControl.pageIndicatorTintColor = [UIColor grayColor];
     
     self.popupController = [[CNPPopupController alloc] initWithContents:@[mainView, pageControl, button]];
     self.popupController.theme = [CNPPopupTheme defaultTheme];
     self.popupController.theme.popupStyle = popupStyle;
     self.popupController.delegate = self;
     [self.popupController presentPopupControllerAnimated:YES];
}

- (void) initializeForView:(UIView*)main
{
    scrollView = [[UIScrollView alloc] initWithFrame:[main bounds]];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    int numPages = (int)self.allResultItems.count;
  
    CGFloat frameWidth = mainView.frame.size.width;
    CGFloat frameHeight = mainView.frame.size.height;
    
    CGFloat contentWidth = numPages * frameWidth;
    scrollView.contentSize = CGSizeMake(contentWidth, frameHeight);
    
    for (int i = 0; i < numPages; i++) {
        // Found one item, launch its content on a webView:
        
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score"
                                                     ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedArray = [self.allResultItems sortedArrayUsingDescriptors:sortDescriptors];
        
        
        
        CraftARSearchResult *bestResult = [sortedArray objectAtIndex:i];
        CraftARItem *item = bestResult.item;
        
        NSLog(@"score %f",bestResult.score);
        
        singleBPMNElement = [[BPMNElement alloc] init];
        singleBPMNElement = [[BPMNElement plistBPMNElementWithId:item.name] firstObject];
        
        _imageView = [[[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"CellImageView"] owner:self options:nil] objectAtIndex:0];
        
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:[singleBPMNElement valueForKey:@"elementName"] attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
        
        NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:[singleBPMNElement valueForKey:@"elementDescription"] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * frameWidth, 5, frameWidth, 30)];
        titleLabel.numberOfLines = 0;
        titleLabel.attributedText = title;
        
        UILabel *lineOneLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * frameWidth, 30, frameWidth, 90)];
        lineOneLabel.numberOfLines = 3;
        //lineOneLabel.backgroundColor = [UIColor redColor];
        lineOneLabel.attributedText = lineOne;
    
        [scrollView addSubview:titleLabel];
        [scrollView addSubview:lineOneLabel];
        
        UIImage *image = [UIImage imageNamed:[singleBPMNElement valueForKey:@"elementImageName"]];
        CGSize size = CGSizeMake(image.size.height/1.5, image.size.width/1.5);
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[self resizeImage:image imageSize:size]];
        imageView.frame = mainView.bounds;
        imageView.contentMode = UIViewContentModeCenter;
        imageView.clipsToBounds = YES;
    
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:singleTap];
        
        CGRect imageViewFrame = _imageView.frame;
        imageViewFrame.origin.x = i * frameWidth;
        imageViewFrame.origin.y = 70;
        imageViewFrame.size.width = frameWidth;
        imageViewFrame.size.height = frameHeight;
        _imageView.userInteractionEnabled = YES;
        [_imageView setFrame:imageViewFrame];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_imageView addSubview:imageView];
        [scrollView addSubview:_imageView];
       
        [scrollView bringSubviewToFront:lineOneLabel];
    }
    [mainView addSubview:scrollView];
}


- (void)handleTap:(UITapGestureRecognizer *)tapRecognizer
{
    //handle pinch...
    [self.popupController dismissPopupControllerAnimated:YES];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        didGetBack = YES;
        
        BPMNElement *singleItem  = [[BPMNElement alloc] init];
        singleItem = [self.allResultItems objectAtIndex:pageControl.currentPage];
        [self performSegueWithIdentifier:@"listSegue" sender:singleItem];
    });
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

- (IBAction)changePage:(id)sender {
    [self changePageAnimated:YES];
}

- (void)changePageAnimated:(BOOL)animated {
    CGFloat x = pageControl.currentPage * [mainView bounds].size.width;
    [scrollView setContentOffset:CGPointMake(x, 0) animated:animated];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)inScrollView  {
    NSInteger pageNumber = roundf(inScrollView.contentOffset.x / (inScrollView.frame.size.width));
    pageControl.currentPage = pageNumber;
}


 #pragma mark - CNPPopupController Delegate
 
 - (void)popupController:(CNPPopupController *)controller didDismissWithButtonTitle:(NSString *)title {
   //  NSLog(@"Dismissed with button title: %@", title);
 }
 
 - (void)popupControllerDidPresent:(CNPPopupController *)controller {
     //NSLog(@"Popup controller presented.");
 }


 #pragma mark - event response
 
 -(void)showPopupCentered:(id)sender {
     [self showPopupWithStyle:CNPPopupStyleCentered];
 }
 
- (void)showPopupFormSheet:(id)sender {
    [self showPopupWithStyle:CNPPopupStyleActionSheet];
 }
 
 - (void)showPopupFullscreen:(id)sender {
     [self showPopupWithStyle:CNPPopupStyleFullscreen];
 }
 
////////////////////////////////
////////////////////////////////

 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 
 - (IBAction)previewTapped:(id)sender
 {
     if (!isSearching) {
         [self snapPhotoToSearch:self];
     }
 }
 
- (void)viewDidLoad
{
     [super viewDidLoad];
     selectedBundle = -1;
     didGetBack = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"initIRRecogniser" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initIRRecogniser:) name:@"initIRRecogniser" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"initIRRecogniserMenuOpen" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initIRRecogniserMenuOpen:) name:@"initIRRecogniserMenuOpen" object:nil];
}


- (void)initIRRecogniserMenuOpen:(NSNotification *) notification {
    if ([[notification.userInfo objectForKey:@"open"]integerValue] == 1) {
        [self hideHelpView:self];
    }
    else {
       // [self showHelpView:self];
    }
}

- (void)initIRRecogniser:(NSNotification *) notification {
    
    if ([[notification.userInfo objectForKey:@"index"]integerValue] == 6) {
        [self performSegueWithIdentifier:@"listSegue" sender:nil];
    }
    else{
        [self.feriImageView removeFromSuperview];
        [self initAPIKeyForIndex:[[notification.userInfo objectForKey:@"index"]integerValue]];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.videoPreview bringSubviewToFront:self.leftButton];
    [self.videoPreview bringSubviewToFront:self.centerButton];
    [self.videoPreview bringSubviewToFront:self.rightButton];

    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (didGetBack) {
        didGetBack = NO;
        [[_sdk getCamera] restartCapture];
        
        if (_sdk) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self showHelpView:self];
            });
        }
    }
    

  /*  [UIView animateWithDuration:1.0
                          delay:0.0
                        options:nil
                     animations:^{
                       //  self.appLogoImageView.frame = CGRectOffset(self.appLogoImageView.frame, 140 , self.appLogoImageView.frame.origin.y);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:1.0
                                               delay:0.0
                                             options:nil
                                          animations:^{
                                              self.appLogoImageView.frame = CGRectOffset(self.appLogoImageView.frame, 0 , -200);
                                          }
                                          completion:^(BOOL finished){
                                              [ self.appLogoImageView removeFromSuperview];
                                          }];
                     }];

    */
    
}

#pragma mark Private


- (IBAction)setAPIKey:(id)sender
{
    UIButton *selectedButton = (UIButton*)sender;
    [self initAPIKeyForIndex:selectedButton.tag];
}

- (IBAction)initAPIKeyForIndex:(NSInteger)index
{
    [_sdk stopCapture];
    
    [self.activityIndicator startAnimating];
    for(UIButton *button in self.buttonCollection){
        [[button layer] setCornerRadius:15.0f];
        [[button layer] setMasksToBounds:YES];
        [[button layer] setBorderWidth:1.0f];
        [[button layer] setBorderColor:[UIColor whiteColor].CGColor];
        
        //capture frame
        if (button.tag == index) {
            [button setSelected:YES];
            button.backgroundColor = [UIColor AP_basicOrangeColorWithTransparent:1.0];
            button.titleLabel.textColor = [UIColor whiteColor];
        }
        else{
            [button setSelected:NO];
            button.backgroundColor = [UIColor whiteColor];
            button.titleLabel.textColor = [UIColor AP_basicOrangeColorWithTransparent:1.0];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        dispatch_queue_t imageQueue = dispatch_queue_create("IRQueue",NULL);
        dispatch_async(imageQueue, ^{
            // Get the colleciton manager
            mCollectionManager = [CraftARCollectionManager sharedCollectionManager];
            
            // Get the On Device IR
            mOnDeviceIR = [CraftAROnDeviceIR sharedCraftAROnDeviceIR];
            
            NSDictionary *api_keys = @{
                                       @"0" : @"com.catchoom.test_BPMN",
                                       @"1" : @"com.catchoom.test_0_22",
                                       @"2" : @"com.catchoom.test_23_42",
                                       @"3" : @"com.catchoom.test_43_61",
                                       @"4" : @"com.catchoom.test_62_81",
                                       @"5" : @"com.catchoom.test_82_94",
                                       };
            
            NSString *api_key = [api_keys valueForKey:[NSString stringWithFormat:@"%i", (int)index]];
            
            selectedBundle = index;
            
            [self addDemoCollectionWithName:api_key];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // setup the CraftAR SDK
                _sdk = [CraftARSDK sharedCraftARSDK];
                
                // Become delegate of the SDK to receive capture initialization callbacks
                _sdk.delegate = self;
                
                // Initialize the video capture on our preview view.
                [_sdk startCaptureWithView:self.videoPreview];
                
                [self showHelpView:self];
                [self.activityIndicator stopAnimating];
            });
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


////////////////////////////////
////////////////////////////////


#pragma mark manage collection
- (void) addDemoCollectionWithName:(NSString*)filename {
    NSString* bundlePath = [[NSBundle mainBundle] pathForResource:filename ofType: @"zip"];
    
     __weak typeof(self) weakSelf = self;
    
     // And add it to the device
     [mCollectionManager addCollectionFromBundle:bundlePath withOnProgress:^(float progress) {
      //   NSLog(@"Add bundle progress: %f", progress);
     } andOnSuccess:^(CraftAROnDeviceCollection *collection) {
         // On success, we load the collection for recognition
         [weakSelf loadDemoCollection: collection];
     } andOnError:^(CraftARError *error) {
      //   NSLog(@"Error adding collection: %@", [error localizedDescription]);
         [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
     }];
    
    // setup the CraftAR SDK
    _sdk = [CraftARSDK sharedCraftARSDK];
    
    // Become delegate of the SDK to receive capture initialization callbacks
    _sdk.delegate = self;
}

- (void) loadDemoCollection: (CraftAROnDeviceCollection*) collection {
    //__weak typeof(self) weakSelf = self;
    
    [mOnDeviceIR setCollection:collection setActive:YES withOnProgress:^(float progress) {
        NSLog(@"Load collection progress: %f", progress/100);
    } onSuccess:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
        });
        
    } andOnError:^(NSError *error) {
        //NSLog(@"Error adding collection: %@", [error localizedDescription]);
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}


- (void) didStartCapture {
    _oir = [CraftAROnDeviceIR sharedCraftAROnDeviceIR];
    _sdk.searchControllerDelegate = _oir.mSearchController;
    _oir.delegate = self;
}

- (IBAction)snapPhotoToSearch:(id)sender {
    isSearching = YES;
    if (selectedBundle >= 0) {
        [self.helpView removeFromSuperview];
        [SVProgressHUD showWithStatus:@"Searching..."];
        [_sdk singleShotSearch];
    }
    else{
        
    }
}

- (void) didGetSearchResults:(NSArray *)resultItems {
    self.allResultItems = resultItems;

    if ([resultItems count] >= 1) {
        [SVProgressHUD dismiss];
        [self showPopupFormSheet:self];
    } else {
        [SVProgressHUD showErrorWithStatus:@"Nothing found"];
        [[_sdk getCamera] restartCapture];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self showHelpView:self];
        });
    }
    isSearching = NO;
}

- (void) didFailSearchWithError:(CraftARError *)error {
   // NSLog(@"Error calling CRS: %@", [error localizedDescription]);
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    [[_sdk getCamera] restartCapture];
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self showHelpView:self];
    });
}

#pragma mark view lifecycle

- (void) viewWillDisappear:(BOOL)animated {
   // [_sdk stopCapture];
    
    [self hideHelpView:self];
    [super viewWillDisappear:animated];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"listSegue"])
    {
        return YES;
    }
    return NO;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   // [[self.navigationController navigationItem] setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BACK", nil) style:UIBarButtonItemStylePlain target:nil action:nil]];
    
     self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"d" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if([[segue identifier] isEqualToString:@"listSegue"])
    {
        
        ListViewController *destinationVC = segue.destinationViewController;
        didGetBack = YES;
        if (sender){
            CraftARSearchResult *bestResult = (CraftARSearchResult*)sender;
            CraftARItem *item = bestResult.item;
            destinationVC.selectedItem = item.name;
        }
        else{
            destinationVC.selectedItem = @"";
        }
    }
}

@end


