//
//  UserImageCell.h
//  Taxi_Khu_Hoi
//
//  Created by Macbook Pro on 10/19/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const UserImageCustomCellWithNib;


@interface UserImageCell : XLFormBaseCell

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;


@end
