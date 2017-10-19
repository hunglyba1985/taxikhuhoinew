//
//  UserImageCell.m
//  Taxi_Khu_Hoi
//
//  Created by Macbook Pro on 10/19/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import "UserImageCell.h"


NSString * const UserImageCustomCellWithNib = @"UserImageCustomeCellWithNib";


@implementation UserImageCell


+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:NSStringFromClass([UserImageCell class]) forKey:UserImageCustomCellWithNib];
}

-(void) configure
{
    self.userImage.layer.cornerRadius = 40;
    self.userImage.clipsToBounds = true;
}

-(void) update
{
    [super update];
    
    self.userImage.layer.cornerRadius = 40;
    
    
    if (self.rowDescriptor.value != nil) {
        [self.userImage setImage:self.rowDescriptor.value];
    }
    
    if (self.rowDescriptor.title != nil) {
        self.userName.text = self.rowDescriptor.title;
        
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
