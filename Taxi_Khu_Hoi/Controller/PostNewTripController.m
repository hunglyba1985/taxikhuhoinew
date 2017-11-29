//
//  PostNewTripController.m
//  Taxi_Khu_Hoi
//
//  Created by Hung_mobilefolk on 10/18/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import "PostNewTripController.h"
#import "SelectLocationCell.h"


NSString *const kDestination = @"destination";
NSString *const kFrom = @"from";
NSString *const kTime = @"time";
NSString *const kPrice = @"price";
NSString *const kPostButton = @"postButton";
NSString *const kNote = @"note";


@interface PostNewTripController ()

@end

@implementation PostNewTripController

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
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Please set information below to register"];
    section.footerTitle = @"We can add more text here to infor user";
    [form addFormSection:section];
    
    // Title
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Title" rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Title" forKey:@"textField.placeholder"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentCenter) forKey:@"textField.textAlignment"];
//    row.required = YES;
    [section addFormRow:row];
    
    // From
//    row = [XLFormRowDescriptor formRowDescriptorWithTag:kFrom rowType:XLFormRowDescriptorTypeText title:@"From:"];
//    row.required = YES;
//    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kFrom rowType:SelectLocationCellWithNib title:@"From:"];
    [section addFormRow:row];
    
    // Destination
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kDestination rowType:SelectLocationCellWithNib title:@"Destination:"];
    [section addFormRow:row];
    
    // Time
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kTime rowType:XLFormRowDescriptorTypeDateTimeInline title:@"Starts"];
    row.value = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPrice rowType:XLFormRowDescriptorTypePhone title:@"Price:"];
    [row.cellConfigAtConfigure setObject:@"Required..." forKey:@"textField.placeholder"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    row.required = YES;
    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"Wrong number" regex:@"[0-9]{10}"]];
    [section addFormRow:row];
    
    // Notes
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kNote rowType:XLFormRowDescriptorTypeTextView];
    [row.cellConfigAtConfigure setObject:@"Notes" forKey:@"textView.placeholder"];
    [section addFormRow:row];
    
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    section.footerTitle = @"";
    [form addFormSection:section];
    
    // Button
    XLFormRowDescriptor * buttonRow = [XLFormRowDescriptor formRowDescriptorWithTag:kPostButton rowType:XLFormRowDescriptorTypeButton title:@"Post"];
    buttonRow.action.formSelector = @selector(postNewTrip);
    [section addFormRow:buttonRow];
    
    self.form = form;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // change cell height of a particular cell
    if ([[self.form formRowAtIndex:indexPath].tag isEqualToString:kFrom]){
        return 50;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
    
    [self addCloseButton];
    
}

-(void) addCloseButton
{
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.rightBarButtonItem = item;

    
}

-(void) postNewTrip
{
    FIRUser *user = [FIRAuth auth].currentUser;
    NSDictionary *formValue = self.form.formValues;
    NSDate *startTime = [formValue objectForKey:kTime];
    NSTimeInterval timeStampe = [startTime timeIntervalSince1970];
    NSString *starTimeStr = [NSString stringWithFormat:@"%f",timeStampe];
    NSLog(@"start time in string is %@",starTimeStr);
    NSNumber *startTimeNumber = [NSNumber numberWithDouble:timeStampe];

    NSString *destinationStr = [formValue objectForKey:kDestination];
    NSString *fromLocation = [formValue objectForKey:kFrom];
    
    
    NSString *price = [formValue objectForKey:kPrice];
    NSString *note = [formValue objectForKey:kNote];
    
    
    NSString *searchKeyDestination = [[LocationMode shareInstance] getSearchKeyFromLocation:destinationStr];
    NSString *searchKeyFrom = [[LocationMode shareInstance] getSearchKeyFromLocation:fromLocation];
    
    NSString *userType = [LocationMode shareInstance].currentUserProfile.userType;

    Event *newEvent = [[Event alloc] initWithUserId:user.uid andUserType:userType destination:destinationStr startTime:startTimeNumber price:price from:fromLocation note:note searchKeyFrom:searchKeyFrom searchKeyDestination:searchKeyDestination];
    
   
    FIRFirestore *defaultFirestore = [FIRFirestore firestore];
    FIRCollectionReference* db= [defaultFirestore collectionWithPath:EventCollectionData];
    [[db documentWithPath:starTimeStr] setData:[newEvent convertToData] completion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error adding document: %@", error);
        } else {
            NSLog(@"Document added with ID");
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
    

}

-(void) closeClick
{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void) postEventToFirebase:(Event*) event inStartTime:(NSString *) startTimeStr
{
    FIRFirestore *defaultFirestore = [FIRFirestore firestore];
    FIRCollectionReference* db= [defaultFirestore collectionWithPath:EventCollectionData];
    [[db documentWithPath:startTimeStr] setData:[event convertToData] completion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error adding document: %@", error);
        } else {
            NSLog(@"Document added with ID");
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
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
