//
//  Event.m
//  Taxi_Khu_Hoi
//
//  Created by Macbook Pro on 10/25/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import "Event.h"

@implementation Event

-(instancetype) initWithData:(NSDictionary*) data{
    self = [super init];
    if (self) {
        self.userId = [data objectForKey:UserId];
        self.userType = [data objectForKey:UserType];
        self.destination = [data objectForKey:UserDestination];
        self.startTime = [data objectForKey:UserStartTime];
        self.price = [data objectForKey:UserPrice];
        self.from = [data objectForKey:UserFrom];
        self.note = [data objectForKey:UserNote];
    }
    return self;
    
}

-(instancetype) initWithUserId:(NSString*) userId
                   andUserType:(NSString*) userType
                   destination:(NSString *) destination
                     startTime:(NSString*) startTime
                         price:(NSString*) price
                          from:(NSString *) from
                          note:(NSString *) note
{
    self = [super init];
    if (self) {
        self.userId = userId;
        self.userType = userType;
        self.destination = destination;
        self.startTime = startTime;
        self.price = price;
        self.from = from;
        self.note = note;
    }
    return self;
}


-(NSDictionary *) convertToData{
    NSDictionary *dic = @{UserId:self.userId,
                          UserType:self.userType,
                          UserDestination:self.destination,
                          UserStartTime:self.startTime,
                          UserPrice:self.price,
                          UserFrom:self.from,
                          UserNote:self.note
                          };
    return dic;

}



@end










