//
//  User.m
//  Taxi_Khu_Hoi
//
//  Created by Macbook Pro on 10/25/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import "User.h"


@implementation User


-(instancetype) initWithData:(NSDictionary*) data
{
    self = [super init];
    if (self) {
        self.name = [data objectForKey:UserName];
        self.phoneNumber = [data objectForKey:UserPhone];
        self.imageUrl = [data objectForKey:UserImage];
        self.hometown = [data objectForKey:UserHometown];
        self.userId = [data objectForKey:UserId];
    }
    return self;
}

-(instancetype) initWithName:(NSString*) name
              andPhoneNumber:(NSString*) phone
                 andImageUrl:(NSString *) urlImg
                 andHometown:(NSString*) hometown
                   andUserId:(NSString *)userId
{
    self = [super init];
    if (self) {
        self.name = name;
        self.phoneNumber = phone;
        self.imageUrl = urlImg;
        self.hometown = hometown;
        self.userId = userId;
    }
    return self;
}

-(NSDictionary *) convertToData
{
    NSDictionary *dic = @{UserName:self.name,UserPhone:self.phoneNumber,UserImage:self.imageUrl,UserHometown:self.hometown,UserId:self.userId};
    return dic;
}

@end







