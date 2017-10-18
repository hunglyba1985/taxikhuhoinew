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


@interface MainViewController ()
{
    GMSMapView *mapView;
    UIButton *postTripButton;
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

    [self addObserverForView];
    [self addPostTripButton];

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

-(void) addPostTripButton
{
    if(postTripButton == nil){
        NSLog(@"add post trip button");
        CGPoint buttonPosition = CGPointMake(self.view.frame.size.width/2 - 25, self.view.frame.size.height -100);
        postTripButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonPosition.x, buttonPosition.y, 50, 50)];
        postTripButton.layer.cornerRadius = 25;
        postTripButton.backgroundColor = [UIColor whiteColor];
        [postTripButton setTitle:@"+" forState:UIControlStateNormal];
        [postTripButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        postTripButton.layer.borderColor = [UIColor grayColor].CGColor;
        postTripButton.layer.borderWidth = 1;
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
