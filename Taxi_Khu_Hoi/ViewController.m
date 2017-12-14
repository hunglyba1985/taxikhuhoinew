//
//  ViewController.m
//  Taxi_Khu_Hoi
//
//  Created by Hung_mobilefolk on 10/17/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import "ViewController.h"
#import "UserRegister.h"
#import "DriverRegister.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"";
    self.navigationItem.backBarButtonItem = item;
    self.navigationItem.hidesBackButton = true;
    
}

-(void) testCommitToGit{
    NSLog(@"test how to commit to git work");
}

- (IBAction)userRegister:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserRegister *userRegister = [storyboard  instantiateViewControllerWithIdentifier:@"UserRegister"];
    userRegister.userRegistedType = TypeUser;
    [self.navigationController pushViewController:userRegister animated:true] ;
    
}

- (IBAction)driverRegister:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserRegister *userRegister = [storyboard  instantiateViewControllerWithIdentifier:@"UserRegister"];
    userRegister.userRegistedType = TypeDriver;
    [self.navigationController pushViewController:userRegister animated:true] ;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
