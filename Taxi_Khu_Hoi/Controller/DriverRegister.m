//
//  DriverRegister.m
//  Taxi_Khu_Hoi
//
//  Created by Hung_mobilefolk on 10/17/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import "DriverRegister.h"
#import "XLForm.h"

NSString *const kBrandName = @"name";
NSString *const kCarNumber = @"number";
NSString *const kRegisterButton = @"button";
NSString *const kImage = @"image";

@interface DriverRegister ()

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
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Please set information below to register"];
    section.footerTitle = @"We can add more text here to infor user";
    [form addFormSection:section];
    
    // Image
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kImage rowType:XLFormRowDescriptorTypeImage title:@"Image"];
    row.value = [UIImage imageNamed:@"default_avatar"];
    [section addFormRow:row];
    
    // Name
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kBrandName rowType:XLFormRowDescriptorTypeText title:@"Brand Name:"];
    row.required = YES;
    [section addFormRow:row];
    
    // Number
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCarNumber rowType:XLFormRowDescriptorTypePhone title:@"Car number:"];
    [row.cellConfigAtConfigure setObject:@"Required..." forKey:@"textField.placeholder"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    row.required = YES;
    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"Wrong number" regex:@"[0-9]{10}"]];
    [section addFormRow:row];
    
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    section.footerTitle = @"";
    [form addFormSection:section];
    
    // Button
    XLFormRowDescriptor * buttonRow = [XLFormRowDescriptor formRowDescriptorWithTag:kRegisterButton rowType:XLFormRowDescriptorTypeButton title:@"Register"];
    buttonRow.action.formSelector = @selector(didTouchButton:);
    [section addFormRow:buttonRow];
    
    self.form = form;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"Driver register";
    
}

-(void)didTouchButton:(UIButton*) button
{
    NSLog(@"Register click");
    
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