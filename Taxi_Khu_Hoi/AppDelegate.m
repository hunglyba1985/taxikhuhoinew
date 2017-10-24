//
//  AppDelegate.m
//  Taxi_Khu_Hoi
//
//  Created by Hung_mobilefolk on 10/17/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import "AppDelegate.h"
#import "XLFormViewController.h"
@import Firebase;
@import FirebaseAuth;
@import GoogleMaps;
@import GooglePlaces;
#import <UserNotifications/UserNotifications.h>
#import "MainViewController.h"
#import "ViewController.h"


#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface AppDelegate () <UNUserNotificationCenterDelegate>

@property(strong, nonatomic) FIRAuthStateDidChangeListenerHandle handle;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:@"ImageCustomCell" forKey:@"XLFormRowDescriptorYourCustomType"];
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:@"UserImageCell" forKey:@"XLFormRowDescriptorYourCustomType"];

    
    [self setupGoogleMap];
    [[LocationMode shareInstance] checkLocationAuthorizationStatus];
    
    // [START initialize_firebase]
    [FIRApp configure];
    // [END initialize_firebase]
    
    [self registerForRemoteNotifications];
    
    [self checkUserSignIn];
    
    return YES;
}

-(void) setupGoogleMap
{
    [GMSServices provideAPIKey:@"AIzaSyCOtIdprF-Sb0VP-s1dH7MPeNkmHt6NmCU"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyCOtIdprF-Sb0VP-s1dH7MPeNkmHt6NmCU"];
}

-(void) checkUserSignIn
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    if ([FIRAuth auth].currentUser) {
        // User is signed in.
        // ...
        NSLog(@"user signed in-------");
        NSLog(@"get current user is %@",[FIRAuth auth].currentUser.phoneNumber);
        MainViewController *mainView = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        self.window.rootViewController  = mainView;
    } else {
        // No user is signed in.
        // ...
        NSLog(@"no user signed in");
        ViewController *welcomeView = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        self.window.rootViewController = welcomeView;
    }
    [self.window makeKeyAndVisible];

}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Push Notification
- (void)registerForRemoteNotifications {
    
        if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
            NSLog(@"register remote notification -----------  ");
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
                if(!error){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                    });
                }
            }];
        }
        else {
            // Code for old versions
            UIUserNotificationType UserNotificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
            
            UserNotificationTypes |= UIUserNotificationActivationModeBackground;
            UserNotificationTypes |= UIUserNotificationActivationModeForeground;
            
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UserNotificationTypes categories:nil];
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
 
    
}

#pragma mark - UNUserNotificationCenterDelegate
//Called when a notification is delivered to a foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"didReceiveNotificationResponse User Info : %@",response.notification.request.content.userInfo);
    
    completionHandler();
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"did register notification %@",deviceToken);
    
    // Pass device token to auth.
    [[FIRAuth auth] setAPNSToken:deviceToken type:FIRAuthAPNSTokenTypeSandbox];
    // Further handling of the device token if needed by the app.
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Pass notification to auth and check if they can handle it.
    
    NSLog(@"didReceiveRemoteNotification with info in the old way: %@",notification);
    NSDictionary *info = [notification objectForKey:@"aps"];
    
    if ([info[@"type"] isEqualToString:@"test"]) {
        //        NSLog(@"type test post notificaiton -------");
        //
        //        if (!self.justOneTime) {
        //            [[[UIAlertView alloc] initWithTitle:@"fucking show" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        //            self.justOneTime = true;
        //        }
        
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"Test" object:nil userInfo:nil];
        
        NSLog(@"get push notification write on to prepare for open app");
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"free_trial_credit.plist"];
        
        [notification writeToFile:filePath atomically:YES];
        completionHandler(UIBackgroundFetchResultNoData);
    }
    
    
    if ([[FIRAuth auth] canHandleNotification:notification]) {
        completionHandler(UIBackgroundFetchResultNoData);
        return;
    }
    //     This notification is not auth related, developer should handle it.
}






@end
