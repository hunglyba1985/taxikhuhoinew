//
//  Location.m
//  Taxi_Khu_Hoi
//
//  Created by Macbook Pro on 10/25/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import "Location.h"

@implementation Location

-(instancetype) initWithData:(NSDictionary*) data
{
    self = [super init];
    if (self) {
        self.userId = [data objectForKey:UserId];
        self.userType = [data objectForKey:UserType];
        self.longtitude = [data objectForKey:UserLongtitude];
        self.lattitude = [data objectForKey:UserLatitude];
        self.status = [[data objectForKey:LocationStatus] boolValue];
    }
    return self;
}

-(instancetype) initWithUserId:(NSString*) userId
                   andUserType:(NSString*) userType
                 andLongtitude:(NSString *) longtitude
                   andLatitude:(NSString*) latitude
                     andStatus:(NSNumber *)status
{
    self = [super init];
    if (self) {
        self.userId = userId;
        self.userType = userType;
        self.longtitude = longtitude;
        self.lattitude = latitude;
        self.status = [status boolValue];
    }
    return self;
}

-(NSDictionary *) convertToData
{
    NSDictionary *dic = @{UserId:self.userId,UserType:self.userType,UserLatitude:self.lattitude,UserLongtitude:self.longtitude,LocationStatus:[NSNumber numberWithBool:self.status]};
    
    return dic;
}




@end
