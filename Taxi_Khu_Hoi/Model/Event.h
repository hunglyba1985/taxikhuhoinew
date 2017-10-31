//
//  Event.h
//  Taxi_Khu_Hoi
//
//  Created by Macbook Pro on 10/25/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userType;
@property (strong, nonatomic) NSString *destination;
@property (strong, nonatomic) NSString *from;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *note;




-(instancetype) initWithData:(NSDictionary*) data;

-(instancetype) initWithUserId:(NSString*) userId
                   andUserType:(NSString*) userType
                   destination:(NSString *) destination
                     startTime:(NSString*) startTime
                         price:(NSString*) price
                          from:(NSString*) from
                          note:(NSString*) note;


-(NSDictionary *) convertToData;




@end
