//
//  MenuViewController.h
//  Taxi_Khu_Hoi
//
//  Created by Hung_mobilefolk on 10/19/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuViewController;

@protocol MenuViewControllerDelegate <NSObject>

-(void) menuViewControllerDidChooseUserHistory;
-(void) menuViewControllerDidChooseSchedule;
-(void) menuViewControllerDidChooseHelp;
-(void) menuViewControllerDidChooseSetting;






@end


@interface MenuViewController : XLFormViewController

@property (nonatomic, weak) id<MenuViewControllerDelegate> delegate;


@end
