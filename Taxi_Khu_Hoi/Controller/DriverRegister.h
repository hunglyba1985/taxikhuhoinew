//
//  DriverRegister.h
//  Taxi_Khu_Hoi
//
//  Created by Hung_mobilefolk on 10/17/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLFormViewController.h"

@interface DriverRegister : XLFormViewController

@property (nonatomic,strong) NSString *userRegistedType;

-(void) setForUserProfile;
-(void) setForDriverProfile;


@end
