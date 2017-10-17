//
//  ImageCustomCell.h
//  Taxi_Khu_Hoi
//
//  Created by Hung_mobilefolk on 10/17/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLFormDescriptorCell.h"
#import "XLFormViewController.h"

extern NSString * const ImageCustomCellWithNib;

@protocol ImageCustomCellDelegate;


@interface ImageCustomCell : XLFormBaseCell <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) id<ImageCustomCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


@end
