//
//  MainViewController.m
//  Taxi_Khu_Hoi
//
//  Created by Hung_mobilefolk on 10/17/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import "MainViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "PostNewTripController.h"
#import <GooglePlaces/GooglePlaces.h>
#import "MenuViewController.h"
#import "HistoryViewController.h"
#import "ScheduleViewController.h"
#import "HelpViewController.h"
#import "SettingViewController.h"




@interface MainViewController () <GMSAutocompleteViewControllerDelegate,MenuViewControllerDelegate>
{
    UIButton *postTripButton;
    UIButton *searchButton;
    UIButton *menuButton;
    UIButton *menuBackgroundView;
    NSMutableArray *listUserLocation;
    NSMutableArray *listUserId;
    NSMutableArray *listMarkers;
    NSString *currentLocatinInfo;
}
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (strong,nonatomic) GMSPlacesClient *currentPlaceInfo;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    listMarkers = [NSMutableArray new];
    [self showGoogleMapView];
    [self getLocationOfAllUsers];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
    
//    NSLog(@"view will appear here");
    [self addObserverForView];
    
    //set null title back button
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"";
    self.navigationItem.backBarButtonItem = item;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addPostTripButton];
    [self addSearchingPlace];
    [self addMenuButton];
    [self addMenuBackgroundView];

    [self.view addSubview:self.menuView];
    self.menuView.hidden = true;
    self.currentPlaceInfo = [GMSPlacesClient sharedClient];
}

-(void) addObserverForView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetLocation) name:NotifyGetLocation object:nil];
}


-(void) showGoogleMapView
{
    // Create a GMSCameraPosition that tells the map to display the
    
    NSDictionary *oldLocation = [[NSUserDefaults standardUserDefaults] objectForKey:OldLocation];
    NSNumber *lat = [oldLocation objectForKey:Latitude];
    NSNumber *lon = [oldLocation objectForKey:Longtitude];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[lat doubleValue]
                                                            longitude:[lon doubleValue]
                                                                 zoom:15];
    self.mapView.myLocationEnabled = YES;
    [_mapView setCamera:camera];


}

#pragma mark - Add Compoments
-(void) addSearchingPlace
{
    if (searchButton == nil) {
        NSLog(@"add searching button");
        searchButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 64, self.view.frame.size.width - 40, 40)];
        [searchButton setTitle:@"Where going to?" forState:UIControlStateNormal];
        searchButton.backgroundColor = [UIColor whiteColor];
        [searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [searchButton addTarget:self action:@selector(showSearchView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:searchButton];
    }
  
    
}

-(void) addPostTripButton
{
    if(postTripButton == nil){
        NSLog(@"add post trip button");
        CGPoint buttonPosition = CGPointMake(self.view.frame.size.width/2 - 25, self.view.frame.size.height -100);
        postTripButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonPosition.x, buttonPosition.y, 50, 50)];
        [postTripButton setBackgroundImage:[UIImage imageNamed:@"add_green"] forState:UIControlStateNormal];
        [postTripButton addTarget:self action:@selector(showPostTripView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:postTripButton];
    }

}
-(void) addMenuButton
{
    if (menuButton == nil) {
        menuButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 30, 30)];
        [menuButton setBackgroundImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(menuClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:menuButton];
    }
    
}
-(void) addMenuBackgroundView
{
    if (menuBackgroundView == nil) {
        menuBackgroundView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        menuBackgroundView.backgroundColor = [UIColor blackColor];
        menuBackgroundView.alpha = 0.3;
        [menuBackgroundView addTarget:self action:@selector(clickMenuBackground) forControlEvents:UIControlEventTouchUpInside];
        menuBackgroundView.hidden = true;
        [self.view addSubview:menuBackgroundView];
        
    }
}

#pragma mark - Get Data From Firebase
-(void) getLocationOfAllUsers
{
    FIRFirestore *defaultFirestore = [FIRFirestore firestore];
    FIRCollectionReference* db= [defaultFirestore collectionWithPath:LocationCollectionData];
    
//    [db getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
//        if (error != nil) {
//            NSLog(@"Error getting documents: %@", error);
//        } else {
//            for (FIRDocumentSnapshot *document in snapshot.documents) {
//                NSLog(@"current uer location %@ => %@", document.documentID, document.data);
//                [listUserId addObject:document.documentID];
//                NSDictionary *locationData = document.data;
//                [listUserLocation addObject:locationData];
//                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[locationData objectForKey:UserLatitude] floatValue], [[locationData objectForKey:UserLongtitude] floatValue]);
//                [self setMarkOnMap:coordinate];
//            }
//        }
//    }];
    
    listUserId = [NSMutableArray new];
    listUserLocation = [NSMutableArray new];
    
    [db addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
            if (snapshot == nil) {
                NSLog(@"Error fetching documents: %@", error);
                return;
            }else
            {
                for (FIRDocumentChange *diff in snapshot.documentChanges) {
                    if (diff.type == FIRDocumentChangeTypeAdded) {
                        NSLog(@"New location: %@", diff.document.data);

                        NSDictionary *locationData = diff.document.data;
                        [listUserId addObject:diff.document.documentID];
                        
                        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[locationData objectForKey:UserLatitude] floatValue], [[locationData objectForKey:UserLongtitude] floatValue]);
                        [self setMarkOnMap:coordinate];
                        
                    }
                    if (diff.type == FIRDocumentChangeTypeModified) {
                        NSLog(@"Modified location: %@", diff.document.data);
                        NSInteger oldUserIdIndex = [listUserId indexOfObject:diff.document.documentID];
//                        NSDictionary *oldLocation = [listUserLocation objectAtIndex:oldUserIdIndex];
//                        NSLog(@"old location is %@",oldLocation);
//                        CLLocationCoordinate2D oldCoordinate = CLLocationCoordinate2DMake([[oldLocation objectForKey:UserLatitude] floatValue], [[oldLocation objectForKey:UserLongtitude] floatValue]);
//                        [self removerMarkOnMap:oldCoordinate];
                        
                        GMSMarker *marker = [listMarkers objectAtIndex:oldUserIdIndex];
                        marker.map = nil;
                        
                        NSDictionary *newLocationData = diff.document.data;
                        NSLog(@"new location is %@",newLocationData);
                        CLLocationCoordinate2D newCoordinate = CLLocationCoordinate2DMake([[newLocationData objectForKey:UserLatitude] floatValue], [[newLocationData objectForKey:UserLongtitude] floatValue]);
                        [self replaceMarkerWithNewCoordinate:newCoordinate atIndex:oldUserIdIndex];
                        
                    }
                    if (diff.type == FIRDocumentChangeTypeRemoved) {
                        NSLog(@"Removed location: %@", diff.document.data);
                        NSInteger oldUserIdIndex = [listUserId indexOfObject:diff.document.documentID];
                        NSDictionary *oldLocation = [listUserLocation objectAtIndex:oldUserIdIndex];
                        CLLocationCoordinate2D oldCoordinate = CLLocationCoordinate2DMake([[oldLocation objectForKey:UserLatitude] floatValue], [[oldLocation objectForKey:UserLongtitude] floatValue]);
                        [self removerMarkOnMap:oldCoordinate];
                        
                        [listUserId removeObjectAtIndex:oldUserIdIndex];
                    }
                }
            }
    }];
    
}


#pragma mark - Private Method
-(void)showPostTripView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PostNewTripController *postTrip = [storyboard instantiateViewControllerWithIdentifier:@"PostNewTripController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postTrip];
    [self presentViewController:nav animated:YES completion:nil];
    
}

-(void) showSearchView
{
//    NSLog(@"show searching view");
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;
    filter.country = @"VN";
    

    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.autocompleteFilter = filter;
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

-(void) menuClick
{
    self.menuView.hidden = false;
    menuBackgroundView.hidden = false;
}
-(void)clickMenuBackground
{
    [self hideMenu];
}

-(void) hideMenu
{
    self.menuView.hidden = true;
    menuBackgroundView.hidden = true;
}

-(void) resetLocation
{
//  NSLog(@"reset location here");
    CLLocation *currentLocation = [LocationMode shareInstance].location;
    [self setCameraForMap:currentLocation.coordinate];
    [self getCurrentLocaitonInfo];
}


-(void) setCameraForMap:(CLLocationCoordinate2D ) coordinate
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                            longitude:coordinate.longitude
                                                                 zoom:15];

    [_mapView setCamera:camera];
}

-(void) setMarkOnMap:(CLLocationCoordinate2D ) coordinate
{
    NSLog(@"set mark on map");
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = coordinate;
//        marker.snippet = @"Hello World";
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.map = _mapView;
    [listMarkers addObject:marker];
}

-(void) replaceMarkerWithNewCoordinate:(CLLocationCoordinate2D) coordinate atIndex:(NSInteger) index
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coordinate;
    //        marker.snippet = @"Hello World";
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = _mapView;
    [listMarkers replaceObjectAtIndex:index withObject:marker];
    
}

-(void) removerMarkOnMap:(CLLocationCoordinate2D) coordinate
{
    
    NSLog(@"remover old mark on map");
    GMSMarker *marker = [GMSMarker markerWithPosition:coordinate];
    marker.map = _mapView;
    marker.map = nil;
}
-(void) getCurrentLocaitonInfo
{
    [self.currentPlaceInfo currentPlaceWithCallback:^(GMSPlaceLikelihoodList *likelihoodList, NSError *error) {
        if (error != nil) {
            NSLog(@"Current Place error %@", [error localizedDescription]);
            return;
        }
        
        GMSPlaceLikelihood *likelihood = [likelihoodList.likelihoods firstObject];
        GMSPlace* place = likelihood.place;
        NSLog(@"Current Place address %@", place.formattedAddress);
        currentLocatinInfo = place.formattedAddress;
        [[NSUserDefaults standardUserDefaults] setObject:place.formattedAddress forKey:CurrentLocationInfo];
        
//        for (GMSPlaceLikelihood *likelihood in likelihoodList.likelihoods) {
//            GMSPlace* place = likelihood.place;
//            NSLog(@"Current Place name %@ at likelihood %g", place.name, likelihood.likelihood);
//            NSLog(@"Current Place address %@", place.formattedAddress);
//            NSLog(@"Current Place attributions %@", place.attributions);
//            NSLog(@"Current PlaceID %@", place.placeID);
//        }
        
    }];
}

#pragma mark - GMSAutocompleteViewControllerDelegate
// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    NSLog(@"didAutocompleteWithPlace");
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    
    [self setCameraForMap:place.coordinate];
    [self setMarkOnMap:place.coordinate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) postSearchingTripToFirebaseWithDestination:(NSString*) destination
{
    FIRUser *user = [FIRAuth auth].currentUser;
    NSTimeInterval timeStampe = [[NSDate date] timeIntervalSince1970];
    NSString *starTimeStr = [NSString stringWithFormat:@"%f",timeStampe];
    NSLog(@"start time in string is %@",starTimeStr);
    Event *newEvent = [[Event alloc] initWithUserId:user.uid andUserType:UserType destination:destination startTime:starTimeStr price:@"" from:currentLocatinInfo note:@""];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    // TODO: handle the error.
    NSLog(@"error: %ld", [error code]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    NSLog(@"Autocomplete was cancelled.");
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"MenuSegue"]) {
        NSLog(@"run to here right");
        MenuViewController *menuView = segue.destinationViewController;
        //        menuView.testLabel.text = @"show fuck here";
        menuView.delegate = self;
        
    }
}

#pragma mark - MenuViewController Delegate
-(void) menuViewControllerDidChooseUserHistory
{
    [self hideMenu];
    HistoryViewController *history = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryViewController"];
    [self.navigationController pushViewController:history animated:YES];
}
-(void) menuViewControllerDidChooseSchedule
{
    [self hideMenu];
    ScheduleViewController *schedule = [self.storyboard instantiateViewControllerWithIdentifier:@"ScheduleViewController"];
    [self.navigationController pushViewController:schedule animated:YES];
}

-(void) menuViewControllerDidChooseHelp
{
    [self hideMenu];
    HelpViewController *help = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpViewController"];
    [self.navigationController pushViewController:help animated:YES];
}

-(void) menuViewControllerDidChooseSetting
{
    [self hideMenu];
    SettingViewController *setting = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self.navigationController pushViewController:setting animated:YES];
}

@end














