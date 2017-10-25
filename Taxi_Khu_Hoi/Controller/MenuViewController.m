//
//  MenuViewController.m
//  Taxi_Khu_Hoi
//
//  Created by Hung_mobilefolk on 10/19/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import "MenuViewController.h"

NSString *const kUserImage = @"userImage";
NSString *const kUserTrip = @"userTrip";


@interface MenuViewController ()

@end

@implementation MenuViewController

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
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    section.footerTitle = @"";
    [form addFormSection:section];
    
    // Custom image
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kUserImage rowType:UserImageCustomCellWithNib title:@"Custom image here"];
    [section addFormRow:row];
    
    
    //    // Image
    //    row = [XLFormRowDescriptor formRowDescriptorWithTag:kImage rowType:XLFormRowDescriptorTypeImage title:@"Image"];
    //    row.value = [UIImage imageNamed:@"default_avatar"];
    //    [section addFormRow:row];
    
    // Name
//    row = [XLFormRowDescriptor formRowDescriptorWithTag:kBrandName rowType:XLFormRowDescriptorTypeText title:@"Brand Name:"];
//    row.required = YES;
//    [section addFormRow:row];
//    
//    // Number
//    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCarNumber rowType:XLFormRowDescriptorTypePhone title:@"Car number:"];
//    [row.cellConfigAtConfigure setObject:@"Required..." forKey:@"textField.placeholder"];
//    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
//    row.required = YES;
//    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"Wrong number" regex:@"[0-9]{10}"]];
//    [section addFormRow:row];
//    
//    
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    section.footerTitle = @"";
    [form addFormSection:section];
//
    // Button
    XLFormRowDescriptor * yourTrip = [XLFormRowDescriptor formRowDescriptorWithTag:kUserTrip rowType:XLFormRowDescriptorTypeButton title:@"Your Trips"];
    [yourTrip.cellConfig setObject:@(NSTextAlignmentNatural) forKey:@"textLabel.textAlignment"];
    [yourTrip.cellConfig setObject:[UIColor blackColor] forKey:@"textLabel.textColor"];
    yourTrip.action.formSelector = @selector(userTripClick);
    [section addFormRow:yourTrip];
    
    XLFormRowDescriptor * scheduleButton = [XLFormRowDescriptor formRowDescriptorWithTag:kUserTrip rowType:XLFormRowDescriptorTypeButton title:@"Scheduled"];
    [scheduleButton.cellConfig setObject:@(NSTextAlignmentNatural) forKey:@"textLabel.textAlignment"];
    [scheduleButton.cellConfig setObject:[UIColor blackColor] forKey:@"textLabel.textColor"];
    scheduleButton.action.formSelector = @selector(scheduleClick);
    [section addFormRow:scheduleButton];
    
    XLFormRowDescriptor * helpButton = [XLFormRowDescriptor formRowDescriptorWithTag:kUserTrip rowType:XLFormRowDescriptorTypeButton title:@"Help"];
    [helpButton.cellConfig setObject:@(NSTextAlignmentNatural) forKey:@"textLabel.textAlignment"];
    [helpButton.cellConfig setObject:[UIColor blackColor] forKey:@"textLabel.textColor"];
    helpButton.action.formSelector = @selector(helpClick);
    [section addFormRow:helpButton];
    
    
    XLFormRowDescriptor * settingButton = [XLFormRowDescriptor formRowDescriptorWithTag:kUserTrip rowType:XLFormRowDescriptorTypeButton title:@"Setting"];
    [settingButton.cellConfig setObject:@(NSTextAlignmentNatural) forKey:@"textLabel.textAlignment"];
    [settingButton.cellConfig setObject:[UIColor blackColor] forKey:@"textLabel.textColor"];
    settingButton.action.formSelector = @selector(settingClick);
    [section addFormRow:settingButton];
    
    self.form = form;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // change cell height of a particular cell
    if ([[self.form formRowAtIndex:indexPath].tag isEqualToString:kUserImage]){
        return 180;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    XLFormRowDescriptor* cell =  [self.form formRowWithTag:kUserImage];
    cell.value  = [UIImage imageNamed:@"test"];
    
    FIRUser *user = [FIRAuth auth].currentUser;
    if (user) {
        // The user's ID, unique to the Firebase project.
        // Do NOT use this value to authenticate with your backend server,
        // if you have one. Use getTokenWithCompletion:completion: instead.
//        NSString *uid = user.uid;
//        NSString *email = user.email;
//        NSURL *photoURL = user.photoURL;
        cell.title = user.displayName;

        // ...
    }

    [self reloadFormRow:cell];
    
}

-(void) userTripClick
{
    id<MenuViewControllerDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(menuViewControllerDidChooseUserHistory)]) {
        [strongDelegate menuViewControllerDidChooseUserHistory];
    }
}

-(void) scheduleClick
{
    id<MenuViewControllerDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(menuViewControllerDidChooseSchedule)]) {
        [strongDelegate menuViewControllerDidChooseSchedule];
    }
}

-(void) helpClick
{
    id<MenuViewControllerDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(menuViewControllerDidChooseHelp)]) {
        [strongDelegate menuViewControllerDidChooseHelp];
    }
}

-(void) settingClick
{
    NSLog(@"setting click");
    id<MenuViewControllerDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(menuViewControllerDidChooseSetting)]) {
        [strongDelegate menuViewControllerDidChooseSetting];
    }
}

-(void)didSelectFormRow:(XLFormRowDescriptor *)formRow
{
    [super didSelectFormRow:formRow];
    [self deselectFormRow:formRow];
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
