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
NSString *const kImage = @"image";
NSString *const kCustomeImage = @"customImage";
NSString *const kUserFullName = @"user full name";

@interface DriverRegister ()
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section1;
    XLFormSectionDescriptor * section2;

    XLFormRowDescriptor * row;
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
    row.required = YES;
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
    NSLog(@"verify click");
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
