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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
}

-(void) update
{
    [super update];
    
//    self.userImage.layer.cornerRadius = 40;
//
//    if (self.rowDescriptor.value != nil) {
//        [self.userImage setImage:self.rowDescriptor.value];
//    }
//
//    if (self.rowDescriptor.title != nil) {
//        self.userName.text = self.rowDescriptor.title;
//
//    }
    
    [self setProfileUser];
    
}

-(void) setProfileUser
{
    //    cell.value  = [UIImage imageNamed:@"test"];
    
    FIRUser *user = [FIRAuth auth].currentUser;
    
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage reference];
    NSString *imagePath = [NSString stringWithFormat:@"%@/iamges/%@.jpg",UserCollectionData,user.uid];
    FIRStorageReference *userImage = [storageRef child:imagePath];
    
    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
    [userImage dataWithMaxSize:1 * 1024 * 1024 completion:^(NSData *data, NSError *error){
        if (error != nil) {
            // Uh-oh, an error occurred!
            NSLog(@"error when download image");
        } else {
            // Data for "images/island.jpg" is returned
            NSLog(@"success get image from firebase");
            UIImage *image = [UIImage imageWithData:data];
            [self.userImage setImage:image];
        }
    }];
    
    
    FIRFirestore *defaultFirestore = [FIRFirestore firestore];
    FIRDocumentReference *docRef= [[defaultFirestore collectionWithPath:UserCollectionData] documentWithPath:user.uid];
    [docRef getDocumentWithCompletion:^(FIRDocumentSnapshot *snapshot, NSError *error) {
        if (snapshot.exists) {
//            NSLog(@"Document data: %@", snapshot.data);
            self.userName.text = [snapshot.data objectForKey:UserNameId];
        } else {
            NSLog(@"Document does not exist");
        }
    }];


    
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
