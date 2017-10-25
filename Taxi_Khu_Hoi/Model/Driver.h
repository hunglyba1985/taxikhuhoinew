//
//  Driver.h
//  Taxi_Khu_Hoi
//
//  Created by Macbook Pro on 10/25/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Driver : NSObject

@property(strong, nonatomic) NSString *phoneNumber;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *imageUrl;
@property(strong, nonatomic) NSString *taxiBrand;
@property(strong, nonatomic) NSString *carNumber;
@property(strong, nonatomic) NSString *carName;




-(instancetype) initWithData:(NSDictionary*) data;

-(instancetype) initWithName:(NSString*) name
              andPhoneNumber:(NSString*) phone
                 andImageUrl:(NSString *) urlImg
                andTaxiBrand:(NSString*) taxiBrand
                andCarNumber:(NSString*) carNumber
                  andCarName:(NSString*) carName;


-(NSDictionary *) convertToData;




@end
