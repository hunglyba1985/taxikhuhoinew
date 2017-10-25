//
//  LocationMode.m
//  Taxi_Khu_Hoi
//
//  Created by Hung_mobilefolk on 10/18/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import "LocationMode.h"

static LocationMode *_shareClient;


@implementation LocationMode

+(LocationMode *) shareInstance
{
    if(!_shareClient) {
        _shareClient = [[LocationMode alloc] init];
    }
    return _shareClient;
}

- (id) init {
    self = [super init];
    if (self) {
        
        [self setupGetCurrentLocation];

    }
    
    return self;
}

-(void) setupGetCurrentLocation
{

    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    //TODO: change for map to Best
    _locationManager.activityType = CLActivityTypeFitness;
    _locationManager.distanceFilter = (CLLocationDistance)1.0;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    if([self checkLocationAuthorizationStatus])
    {
        [_locationManager startUpdatingLocation];
    }
    
//    if(!updateCurrentLocationTimer){
//        updateCurrentLocationTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateCurrentLocation) userInfo:nil repeats:true];
//
//    }
}

#pragma mark - Public Methods

-(BOOL)checkLocationAuthorizationStatus
{
    //TODO: localization
    //TODO: check BG usage
    NSString *errorMessage;
    switch ([CLLocationManager authorizationStatus])
    {
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            return YES;
            case kCLAuthorizationStatusRestricted:
            errorMessage = @"Location services must be enabled in order to use Encounter.";
            return NO;
            break;
            case kCLAuthorizationStatusDenied:
            errorMessage = @"Location services must be enabled in order to use Encounter.";
            return NO;
            break;
            case kCLAuthorizationStatusNotDetermined:
        default:
        {
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            { //iOS 8+
                [self.locationManager requestWhenInUseAuthorization];
                return YES;
            }
            errorMessage = @"Unable to determine your location. Please make sure location services are enabled.";
            return YES;
            break;
        }
    }
    
    
}

#pragma mark - Private Method
-(void)updateCurrentLocation
{
//    NSLog(@"update current location run");
    [_locationManager startUpdatingLocation];
}


#pragma mark - CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _location = [locations lastObject];
    [self notifiLocationAndSaveToNextTime];
    
    FIRUser *user = [FIRAuth auth].currentUser;
    if (user) {
        
        Location *currentLocation = [[Location alloc] initWithUserId:user.uid andUserType:TypeUser andLongtitude:[NSString stringWithFormat:@"%f",_location.coordinate.longitude] andLatitude:[NSString stringWithFormat:@"%f",_location.coordinate.latitude]];
        [self updateLocationToFirebase:currentLocation];
        
    }

    
    
}

- (void)locationManager:(CLLocationManager*)manager
    didUpdateToLocation:(CLLocation*)newLocation
           fromLocation:(CLLocation*)oldLocation
{
    _location = newLocation;
    [self notifiLocationAndSaveToNextTime];

}

-(void)processLocationUpdateWithLocation:(CLLocation*)newLocation
{
    _location = newLocation;
    [self notifiLocationAndSaveToNextTime];

}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
       ([error.domain isEqualToString:kCLErrorDomain] && error.code == kCLErrorDenied))
    {
        [self checkLocationAuthorizationStatus];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if([CLLocationManager locationServicesEnabled])
    {
        [self.locationManager startUpdatingLocation];
   
    }
}

-(void) notifiLocationAndSaveToNextTime
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyGetLocation object:nil];
    NSNumber *lat = [NSNumber numberWithDouble:_location.coordinate.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:_location.coordinate.longitude];
    NSDictionary *userLocation=@{Latitude:lat,Longtitude:lon};
    
    [[NSUserDefaults standardUserDefaults] setObject:userLocation forKey:OldLocation];
}

-(void) updateLocationToFirebase:(Location *) currentLocation
{
//    NSLog(@"update current location to firebase");
    FIRFirestore *defaultFirestore = [FIRFirestore firestore];
    FIRCollectionReference* db= [defaultFirestore collectionWithPath:LocationCollectionData];
    FIRUser *user = [FIRAuth auth].currentUser;
    [[db documentWithPath:user.uid] setData:[currentLocation convertToData] completion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error adding document: %@", error);
        } else {
            NSLog(@"Document added with ID");
        }
    }];
    
}


@end


























