//
//  MainViewController.m
//  Taxi_Khu_Hoi
//
//  Created by Hung_mobilefolk on 10/17/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import "MainViewController.h"
#import <GoogleMaps/GoogleMaps.h>


@interface MainViewController ()
{
    GMSMapView *mapView;
    
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showGoogleMapView];
    
    [self addMoreLayerToView];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addObserverForView];
    
    self.navigationController.navigationBarHidden = true;
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

-(void) addMoreLayerToView
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    button.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:button];
    
}


-(void) resetLocation
{
//    NSLog(@"reset location here");
    CLLocation *currentLocation = [LocationMode shareInstance].location;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude
                                                            longitude:currentLocation.coordinate.longitude
                                                                 zoom:17];
    
    [mapView setCamera:camera];
    
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
