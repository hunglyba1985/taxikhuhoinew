//
//  Event.h
//  Taxi_Khu_Hoi
//
//  Created by Macbook Pro on 10/25/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSString *userType;
@property (strong, nonatomic) NSString *destination;
@property (strong, nonatomic) NSString *from;
@property (strong, nonatomic) NSNumber *startTime;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *note;
@property (strong, nonatomic) NSString *searchKeyDestination;
@property (strong, nonatomic) NSString *searchKeyFrom;




-(instancetype) initWithData:(NSDictionary*) data;

-(instancetype) initWithUserId:(NSNumber*) userId
                   andUserType:(NSString*) userType
                   destination:(NSString *) destination
                     startTime:(NSNumber*) startTime
                         price:(NSString*) price
                          from:(NSString*) from
                          note:(NSString*) note
                 searchKeyFrom:(NSString*) searchKeyFrom
          searchKeyDestination:(NSString*) searchKeyDestination;


-(NSDictionary *) convertToData;

-(void) postEventToFirebaseAtTime:(NSString *) startTime;



@end
