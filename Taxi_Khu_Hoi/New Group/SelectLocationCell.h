//
//  SelectLocationCell.h
//  Taxi_Khu_Hoi
//
//  Created by Hung_mobilefolk on 10/27/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GoogleMaps.h>

extern NSString * const SelectLocationCellWithNib;


@interface SelectLocationCell : XLFormBaseCell <GMSAutocompleteViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;



@end
