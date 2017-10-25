//
//  Driver.m
//  Taxi_Khu_Hoi
//
//  Created by Macbook Pro on 10/25/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import "Driver.h"

@implementation Driver

-(instancetype) initWithData:(NSDictionary*) data
{
    self = [super init];
    if (self) {
        self.name = [data objectForKey:UserName];
        self.phoneNumber = [data objectForKey:UserPhone];
        self.imageUrl = [data objectForKey:UserImage];
        self.carName = [data objectForKey:CarName];
        self.carNumber = [data objectForKey:CarNumber];
        self.taxiBrand = [data objectForKey:TaxiBrand];
        
        
    }
    return self;
}

-(instancetype) initWithName:(NSString*) name
              andPhoneNumber:(NSString*) phone
                 andImageUrl:(NSString *) urlImg
                andTaxiBrand:(NSString*) taxiBrand
                andCarNumber:(NSString*) carNumber
                  andCarName:(NSString*) carName
{
    self = [super init];
    if (self) {
        self.name = name;
        self.phoneNumber = phone;
        self.imageUrl = urlImg;
        self.carNumber= carNumber;
        self.carName = carName;
        self.taxiBrand = taxiBrand;
    }
    return self;
}

-(NSDictionary *) convertToData
{
    NSDictionary *dic = @{UserName:self.name,UserPhone:self.phoneNumber,UserImage:self.imageUrl,TaxiBrand:self.taxiBrand,CarNumber:self.carNumber,CarName:self.carName};
    
    return dic;
}


@end









