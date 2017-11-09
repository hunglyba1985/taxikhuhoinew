//
//  DriverRegister.m
//  Taxi_Khu_Hoi
//
//  Created by Hung_mobilefolk on 10/17/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import "DriverRegister.h"
#import "XLForm.h"
#import "MainViewController.h"


NSString *const kTaxiBrand = @"taxi brand";
NSString *const kCarNumber = @"car number";
NSString *const kRegisterButton = @"button";

NSString *const kCustomeImage = @"customImage";
NSString *const kUserFullName = @"user full name";
NSString *const kUserHometown = @"user hometown";
NSString *const kCarName = @"car name";

@interface DriverRegister ()
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section1;
    XLFormSectionDescriptor * section2;
    XLFormRowDescriptor * row;
    UIImage *userProfileImage;
    NSString *userImageUrl;
}
@end

@implementation DriverRegister

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        [self initializeForm];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initializeForm];
    }
    return self;
}


-(void)initializeForm
{
   
    
    form = [XLFormDescriptor formDescriptor];
    
    section1 = [XLFormSectionDescriptor formSectionWithTitle:@"Please set information below to register"];
    section1.footerTitle = @"We can add more text here to infor user";
    [form addFormSection:section1];
    
    // Custom image
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCustomeImage rowType:ImageCustomCellWithNib title:@"Custom image here"];
    [section1 addFormRow:row];
    
    
    section2 = [XLFormSectionDescriptor formSectionWithTitle:@""];
    section2.footerTitle = @"";
    [form addFormSection:section2];
    
    // Button
    XLFormRowDescriptor * buttonRow = [XLFormRowDescriptor formRowDescriptorWithTag:kRegisterButton rowType:XLFormRowDescriptorTypeButton title:@"Register"];
    buttonRow.action.formSelector = @selector(verifyClick:);
    [section2 addFormRow:buttonRow];
    
    self.form = form;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // change cell height of a particular cell
    if ([[self.form formRowAtIndex:indexPath].tag isEqualToString:kCustomeImage]){
        return 150;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void) setForUserProfile
{
    // User real name
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kUserFullName rowType:XLFormRowDescriptorTypeText title:@"Full Name:"];
    [section1 addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kUserHometown rowType:XLFormRowDescriptorTypeText title:@"Hometown:"];
    [section1 addFormRow:row];
}
    
-(void) setForDriverProfile
{
    // User real name
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kUserFullName rowType:XLFormRowDescriptorTypeText title:@"Full Name:"];
    row.required = YES;
    [section1 addFormRow:row];
    
    // Taxi brand
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kTaxiBrand rowType:XLFormRowDescriptorTypeText title:@"Taxi brand:"];
    row.required = YES;
    [section1 addFormRow:row];
    
    // Car name
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCarName rowType:XLFormRowDescriptorTypeText title:@"Car name:"];
    row.required = YES;
    [section1 addFormRow:row];
    
    // Number
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCarNumber rowType:XLFormRowDescriptorTypePhone title:@"Car number:"];
    [row.cellConfigAtConfigure setObject:@"Required..." forKey:@"textField.placeholder"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    row.required = YES;
    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"Wrong number" regex:@"[0-9]{10}"]];
    [section1 addFormRow:row];
    
    [self.tableView reloadData];
}
    

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"Complete your profile";
    self.navigationController.navigationBarHidden = false;
    //set null title back button
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"";
    self.navigationItem.backBarButtonItem = item;
}

-(void)verifyClick:(UIButton*) button
{
    NSDictionary *formValues = self.form.formValues;
    userProfileImage  = [formValues objectForKey:kCustomeImage];
    [self sendImageToFirebaseStore:userProfileImage];
    
    
}

-(void) sendImageToFirebaseStore:(UIImage *) image
{
    NSLog(@"start send image to firebase");
    NSData *imageData = UIImageJPEGRepresentation(image,0.8);
    FIRUser *user = [FIRAuth auth].currentUser;
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage reference];
    NSString *imagePath = [NSString stringWithFormat:@"%@/iamges/%@.jpg",UserCollectionData,user.uid];
    FIRStorageReference *userImage = [storageRef child:imagePath];
    
    // Create the file metadata
    FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
    metadata.contentType = @"image/jpeg";
    
    FIRStorageUploadTask *uploadTask = [userImage putData:imageData
                                                 metadata:metadata
                                               completion:^(FIRStorageMetadata *metadata,
                                                            NSError *error) {
                                                   if (error != nil) {
                                                       // Uh-oh, an error occurred!
                                                       if ([self.userRegistedType isEqualToString:TypeUser]) {
                                                           UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Error happen" message:@"Can't upload your image" preferredStyle:UIAlertControllerStyleAlert];
                                                           UIAlertAction *try = [UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                               [self sendImageToFirebaseStore:userProfileImage];
                                                           }];
                                                           UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                               [self uploadUserProfileToFirebaseWithImageUrl:@""];
                                                           }];
                                                           [alertView addAction:try];
                                                           [alertView addAction:continueAction];
                                                           [self presentViewController:alertView animated:YES completion:nil];
                                                       }
                                                       
                                                       
                                                   } else {
                                                       // Metadata contains file metadata such as size, content-type, and download URL.
                                                       NSURL *downloadURL = metadata.downloadURL;
                                                       NSLog(@"down load url%@",downloadURL);
                                                       userImageUrl = [downloadURL absoluteString];
                                                       [self uploadUserProfileToFirebaseWithImageUrl:[downloadURL absoluteString]];
                                                   }
                                               }];
    
//    // Listen for state changes, errors, and completion of the upload.
//    [uploadTask observeStatus:FIRStorageTaskStatusResume handler:^(FIRStorageTaskSnapshot *snapshot) {
//        // Upload resumed, also fires when the upload starts
//    }];
//
//    [uploadTask observeStatus:FIRStorageTaskStatusPause handler:^(FIRStorageTaskSnapshot *snapshot) {
//        // Upload paused
//    }];
//
//    [uploadTask observeStatus:FIRStorageTaskStatusProgress handler:^(FIRStorageTaskSnapshot *snapshot) {
//        // Upload reported progress
//        double percentComplete = 100.0 * (snapshot.progress.completedUnitCount) / (snapshot.progress.totalUnitCount);
//        NSLog(@"Upload completed progress %f",percentComplete);
//    }];
//
        [uploadTask observeStatus:FIRStorageTaskStatusSuccess handler:^(FIRStorageTaskSnapshot *snapshot) {
            // Upload completed successfully
            NSLog(@"Upload completed successfully");
        }];
//
        // Errors only occur in the "Failure" case
        [uploadTask observeStatus:FIRStorageTaskStatusFailure handler:^(FIRStorageTaskSnapshot *snapshot) {
            if (snapshot.error != nil) {
                NSLog(@"Upload failure");
                switch (snapshot.error.code) {
                    case FIRStorageErrorCodeObjectNotFound:
                        // File doesn't exist
                        break;

                    case FIRStorageErrorCodeUnauthorized:
                        // User doesn't have permission to access file
                        break;

                    case FIRStorageErrorCodeCancelled:
                        // User canceled the upload
                        break;

                        /* ... */

                    case FIRStorageErrorCodeUnknown:
                        // Unknown error occurred, inspect the server response
                        break;
                }
            }
        }];

    
}

-(void) uploadUserProfileToFirebaseWithImageUrl:(NSString *) userImageUrlstr
{
        NSDictionary *formValues = self.form.formValues;
        NSString *userPhone = [[NSUserDefaults standardUserDefaults] objectForKey:UserPhone];
        FIRUser *user = [FIRAuth auth].currentUser;

        if ([self.userRegistedType isEqualToString:TypeUser]) {
            User *newUser = [[User alloc] initWithName:[formValues objectForKey:kUserFullName] andPhoneNumber:userPhone andImageUrl:userImageUrl andHometown:[formValues objectForKey:kUserHometown] andUserId:user.uid andUserNameId:[[NSUserDefaults standardUserDefaults] objectForKey:UserNameUpdate] andUserType:self.userRegistedType];
    
            FIRFirestore *defaultFirestore = [FIRFirestore firestore];
            FIRCollectionReference* db= [defaultFirestore collectionWithPath:UserCollectionData];
            [[db documentWithPath:user.uid] setData:[newUser convertToData] completion:^(NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"Error adding document: %@", error);
                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Error happen" message:@"Can't upload your profile" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *try = [UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self uploadUserProfileToFirebaseWithImageUrl:userImageUrl];
                    }];
                  
                    [alertView addAction:try];
                    [self presentViewController:alertView animated:YES completion:nil];
                } else {
                    NSLog(@"Document added with ID");
                    [self showTheMainView];
                }
            }];
            
        }else{
            
            
    
        }
}

-(void) showTheMainView
{
//        NSLog(@"verify click");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainViewController *mainView = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        [self.navigationController pushViewController:mainView animated:true];

}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
