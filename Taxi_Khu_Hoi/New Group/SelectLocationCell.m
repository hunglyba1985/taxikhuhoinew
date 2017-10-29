//
//  SelectLocationCell.m
//  Taxi_Khu_Hoi
//
//  Created by Hung_mobilefolk on 10/27/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import "SelectLocationCell.h"

NSString * const SelectLocationCellWithNib = @"SelectLocationCellWithNib";


@implementation SelectLocationCell

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:NSStringFromClass([SelectLocationCell class]) forKey:SelectLocationCellWithNib];
}


-(void) configure
{
    // set configure here
    
}

-(void) update
{
    self.titleLabel.text = [NSString stringWithFormat:@"  %@",self.rowDescriptor.title];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)cellSelected:(id)sender {
    
    NSLog(@"select cell click");
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterRegion;
    filter.country = @"VN";
    
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.autocompleteFilter = filter;
    acController.delegate = self;
    [self.formViewController  presentViewController:acController animated:YES completion:nil];
}

#pragma mark - GMSAutocompleteViewControllerDelegate
// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    NSLog(@"didAutocompleteWithPlace");
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    self.valueLabel.text = place.formattedAddress;
    self.rowDescriptor.value = place.formattedAddress;
    [self.formViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    // TODO: handle the error.
    NSLog(@"error: %ld", [error code]);
    [self.formViewController dismissViewControllerAnimated:YES completion:nil];
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    NSLog(@"Autocomplete was cancelled.");
    [self.formViewController dismissViewControllerAnimated:YES completion:nil];
}




@end
