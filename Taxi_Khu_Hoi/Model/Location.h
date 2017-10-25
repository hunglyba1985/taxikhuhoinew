//
//  Location.h
//  Taxi_Khu_Hoi
//
//  Created by Macbook Pro on 10/25/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property(strong, nonatomic) NSString *userId;
@property(strong, nonatomic) NSString *userType;
@property(strong, nonatomic) NSString *longtitude;
@property(strong, nonatomic) NSString *lattitude;



-(instancetype) initWithData:(NSDictionary*) data;

-(instancetype) initWithUserId:(NSString*) userId
                   andUserType:(NSString*) userType
                 andLongtitude:(NSString *) longtitude
                   andLatitude:(NSString*) latitude;


-(NSDictionary *) convertToData;

@end
