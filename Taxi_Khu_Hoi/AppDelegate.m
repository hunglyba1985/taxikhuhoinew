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

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@property(strong, nonatomic) FIRAuthStateDidChangeListenerHandle handle;

@end

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:@"ImageCustomCell" forKey:@"XLFormRowDescriptorYourCustomType"];
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:@"UserImageCell" forKey:@"XLFormRowDescriptorYourCustomType"];
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:@"SelectLocationCell" forKey:@"XLFormRowDescriptorYourCustomType"];

    
    [self setupGoogleMap];
    [[LocationMode shareInstance] checkLocationAuthorizationStatus];
    
    // [START initialize_firebase]
    [FIRApp configure];
    // [END initialize_firebase]
    
    [self checkUserSignIn];
    
    NSLog(@"number of provinces %i",(int)ProvinceWithoutAccented.count);
    
    // [START set_messaging_delegate]
    [FIRMessaging messaging].delegate = self;
    // [END set_messaging_delegate]
    
    
    [self registerForRemoteNotifications:application];

    
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
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainView];
        self.window.rootViewController  = nav;
        
        FIRUser *user = [FIRAuth auth].currentUser;
        FIRFirestore *defaultFirestore = [FIRFirestore firestore];
        FIRDocumentReference *docRef= [[defaultFirestore collectionWithPath:UserCollectionData] documentWithPath:user.uid];
        [docRef getDocumentWithCompletion:^(FIRDocumentSnapshot *snapshot, NSError *error) {
            if (snapshot.exists) {
                NSLog(@"App delegate Document data: %@", snapshot.data);
                NSDictionary *userProfile = snapshot.data;
                User *currentUser = [[User alloc] initWithData:userProfile];
                [LocationMode shareInstance].currentUserProfile = currentUser;
            } else {
                NSLog(@"Document does not exist");
            }
        }];
        
    } else {
        // No user is signed in.
        // ...
        NSLog(@"no user signed in");
        ViewController *welcomeView = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:welcomeView];
        self.window.rootViewController = nav;
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
- (void)registerForRemoteNotifications:(UIApplication *)application
{
    
    // Register for remote notifications. This shows a permission dialog on first run, to
    // show the dialog at a more appropriate time move this registration accordingly.
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier. Disable the deprecation warnings.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
#pragma clang diagnostic pop
    } else {
        // iOS 8 or later
        // [START register_for_notifications]
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [application registerUserNotificationSettings:settings];
        } else {
            // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            // For iOS 10 display notification (sent via APNS)
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert
            | UNAuthorizationOptionSound
            | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            }];
#endif
        }
        
        [application registerForRemoteNotifications];
        // [END register_for_notifications]
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

# pragma mark FIRMessagingDelegate
// [START refresh_token]
- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
    
//    NSString *fcmToken = [FIRMessaging messaging].FCMToken;
//    NSLog(@"FCM registration token: %@", fcmToken);
    
    if ([FIRAuth auth].currentUser) {
        FIRFirestore *defaultFirestore = [FIRFirestore firestore];
        FIRCollectionReference* db= [defaultFirestore collectionWithPath:UserCollectionData];
        FIRDocumentReference *documentDB = [db documentWithPath:[FIRAuth auth].currentUser.uid];
        
        [documentDB updateData:@{
                                    @"notificationTokens": fcmToken
                                    } completion:^(NSError * _Nullable error) {
                                        if (error != nil) {
                                            NSLog(@"FIRMessaging Error updating document: %@", error);
                                        } else {
                                            NSLog(@"FIRMessaging Document successfully updated");
                                        }
                                    }];
    }
    
  
    
    
}
// [END refresh_token]

// [START ios_10_data_message]
// Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
// To enable direct data messages, you can set [Messaging messaging].shouldEstablishDirectChannel to YES.
- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    NSLog(@"Received data message: %@", remoteMessage.appData);
}
// [END ios_10_data_message]





@end
