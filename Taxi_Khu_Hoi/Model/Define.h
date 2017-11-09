//
//  Define.h
//  Taxi_Khu_Hoi
//
//  Created by Hung_mobilefolk on 10/18/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#ifndef Define_h
#define Define_h

// Location function
#define NotifyGetLocation             @"Notify Get Location"
#define OldLocation                   @"Old Location"
#define Latitude    @"Latitude"
#define Longtitude @"Longtitude"
#define CurrentLocationInfo  @"current location info"


// User register
#define AuthVerificationID  @"authVerificationID"
#define UserNameUpdate @"User name update"

// Firebase model define
#define UserCollectionData @"users"
#define DriverCollectionData @"drivers"
#define LocationCollectionData @"locations"
#define EventCollectionData @"events"


// Client Model object
#define UserId    @"userId"
#define UserType  @"userType"
#define UserName  @"name"
#define UserPhone @"phone"
#define UserImage @"image_url"
#define UserHometown @"hometown"
#define UserNameId @"nameId"

#define TaxiBrand @"taxi_brand"
#define CarNumber @"car_number"
#define CarName   @"car_name"

#define UserLongtitude @"longtitude"
#define UserLatitude @"latitude"


#define TypeUser @"type user"
#define TypeDriver @"type driver"


#define UserData @"userData"

// Client Model object event
#define UserDestination @"destination"
#define UserStartTime @"startTime"
#define UserPrice @"price"
#define UserFrom @"from"
#define UserNote @"note"


typedef NS_ENUM(NSUInteger, UserRegistedType) {
    kUser,
    kDriver,
};


#endif /* Define_h */





















