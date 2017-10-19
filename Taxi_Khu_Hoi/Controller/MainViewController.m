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


@interface MainViewController () <GMSAutocompleteViewControllerDelegate>
{
    GMSMapView *mapView;
    UIButton *postTripButton;
    UIButton *searchButton;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showGoogleMapView];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
    
    NSLog(@"view will appear here");
    
    [self addObserverForView];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addPostTripButton];
    [self addSearchingPlace];
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
                                                                 zoom:17];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    

}

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

-(void)showPostTripView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PostNewTripController *postTrip = [storyboard instantiateViewControllerWithIdentifier:@"PostNewTripController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postTrip];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void) showSearchView
{
    NSLog(@"show searching view");
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}


-(void) resetLocation
{
//    NSLog(@"reset location here");
    CLLocation *currentLocation = [LocationMode shareInstance].location;
    [self setCameraForMap:currentLocation.coordinate];
}

-(void) setCameraForMap:(CLLocationCoordinate2D ) coordinate
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                            longitude:coordinate.longitude
                                                                 zoom:17];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = camera.target;
    marker.snippet = @"Hello World";
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = mapView;
    
    [mapView setCamera:camera];
}

-(void) setMarkOnMap:(CLLocationCoordinate2D ) coordinate
{
    
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
