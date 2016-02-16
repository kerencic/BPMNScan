#import "AppDelegate.h"
#import "ScannerViewController.h"
#import "APConstants.h"

#import "UIColor+AventaPlus.h"

#import "TGLGuillotineMenu.h"

#import "ScannerViewController.h"

@interface AppDelegate () <TGLGuillotineMenuDelegate>

@end

@implementation AppDelegate

+ (AppDelegate *)sharedAppDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIColor AP_basicOrangeColorWithTransparent:1.0], NSForegroundColorAttributeName, nil]];
    
    id<UIApplicationDelegate> app = [[UIApplication sharedApplication] delegate];
    
    UIStoryboard *storyboard = app.window.rootViewController.storyboard;
    ScannerViewController *vc01 = [storyboard instantiateViewControllerWithIdentifier:@"ScannerViewController"];

    NSArray *vcArray        = [[NSArray alloc] initWithObjects:vc01, nil];
    NSArray *titlesArray    = [[NSArray alloc] initWithObjects:@"BPMN 2.0 bundle", @"BPMN bundle 1", @"BPMN bundle 2", @"BPMN bundle 3", @"BPMN bundle 4", @"BPMN bundle 5", @"All BPMN Elements", nil];
    NSArray *imagesArray    = [[NSArray alloc] initWithObjects:@"ic_profile", @"ic_feed", @"ic_activity", @"ic_settings", @"ic_settings", @"ic_settings", @"ic_settings", nil];
    
    TGLGuillotineMenu *menuVC = [[TGLGuillotineMenu alloc] initWithViewControllers:vcArray MenuTitles:titlesArray andImagesTitles:imagesArray];
    menuVC.delegate = self;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:menuVC];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navController;
    self.window.backgroundColor = [UIColor AP_basicOrangeColorWithTransparent:1.0];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

#pragma mark - Guillotine Menu Delegate

-(void)selectedMenuItemAtIndex:(NSInteger)index{
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:@"initIRRecogniser" object:nil userInfo:@{@"index": @(index) }];
}

-(void)menuDidOpen{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:@"initIRRecogniserMenuOpen" object:nil userInfo:@{@"open": @(1) }];
}

-(void)menuDidClose{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:@"initIRRecogniserMenuOpen" object:nil userInfo:@{@"open": @(0) }];
}

@end
