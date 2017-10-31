//
//  ImageCustomCell.m
//  Taxi_Khu_Hoi
//
//  Created by Hung_mobilefolk on 10/17/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import "ImageCustomCell.h"

NSString * const ImageCustomCellWithNib = @"ImageCustomeCellWithNib";


@implementation ImageCustomCell
{
    UIImagePickerController *_imagePicker; //이미지 피커
    UIActionSheet *_actionSheet; //show Photo Menu
    UIImage *_image;
}

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:NSStringFromClass([ImageCustomCell class]) forKey:ImageCustomCellWithNib];
}

-(void)configure
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
    

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)getDeviceImage:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
        
        [_actionSheet showInView:self.formViewController.view];
        
    } else {
        
        [self choosePhotoFromLibrary];
    }
    
}
- (void)takePhoto
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    [self.formViewController presentViewController:_imagePicker animated:YES completion:nil];
}



- (void)choosePhotoFromLibrary
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    [self.formViewController presentViewController:_imagePicker animated:YES completion:nil];
}

- (void)showImage:(UIImage *)image
{
    [self.imageButton setBackgroundImage:image forState:UIControlStateNormal];
    self.rowDescriptor.value = image;
    self.infoLabel.hidden = true;
    
}

#pragma mark - UIImagePickerController Delegate

//must conform to both UIImagePickerControllerDelegate and UINavigationControllerDelegate
//but don’t have to implement any of the UINavigationControllerDelegate methods.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _image = info[UIImagePickerControllerEditedImage];
    [self showImage:_image];
    [self.formViewController dismissViewControllerAnimated:YES completion:nil];
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self.formViewController dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [self takePhoto];
        
    } else if (buttonIndex == 1) {
        
        [self choosePhotoFromLibrary];
    }
    
    _actionSheet = nil;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
