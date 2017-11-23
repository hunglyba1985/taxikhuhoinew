//
//  LocationMode.h
//  Taxi_Khu_Hoi
//
//  Created by Hung_mobilefolk on 10/18/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Location.h"
#import "User.h"


@interface LocationMode : NSObject <CLLocationManagerDelegate>
{
    NSTimer *updateCurrentLocationTimer;
    
}
@property (strong, nonatomic) CLLocationManager *locationManager; //TODO: private
@property (readonly, nonatomic) CLLocation *location;
@property (readonly, nonatomic) CLLocationDegrees longitude;
@property (readonly, nonatomic) CLLocationDegrees latitude;
@property (readonly, nonatomic) CLPlacemark *placemark;
@property (strong,nonatomic) User *currentUserProfile;


+(LocationMode *) shareInstance;
-(BOOL)checkLocationAuthorizationStatus;

-(NSString *) getSearchKeyFromLocation:(NSString *) locationAddress;
-(NSString *) convertStringToRomaria:(NSString *) originalStr;
-(void) updateLocationToFirebase:(Location *) currentLocation;




@end
