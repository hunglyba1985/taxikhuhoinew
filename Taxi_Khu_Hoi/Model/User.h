//
//  User.h
//  Taxi_Khu_Hoi
//
//  Created by Macbook Pro on 10/25/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(strong, nonatomic) NSString *phoneNumber;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *imageUrl;
@property(strong, nonatomic) NSString *hometown;
@property(strong, nonatomic) NSString *userId;


-(instancetype) initWithData:(NSDictionary*) data;

-(instancetype) initWithName:(NSString*) name
              andPhoneNumber:(NSString*) phone
                 andImageUrl:(NSString *) urlImg
                 andHometown:(NSString*) hometown
                   andUserId:(NSString*) userId;


-(NSDictionary *) convertToData;



@end
