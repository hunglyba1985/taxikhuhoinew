//
//  Define.h
//  Taxi_Khu_Hoi
//
//  Created by Hung_mobilefolk on 10/18/17.
//  Copyright © 2017 Mobilefolk. All rights reserved.
//

#ifndef Define_h
#define Define_h

// Location function
#define NotifyGetLocation             @"Notify Get Location"
#define OldLocation                   @"Old Location"
#define Latitude    @"Latitude"
#define Longtitude @"Longtitude"
#define CurrentLocationInfo  @"current location info"


// User register
#define AuthVerificationID  @"authVerificationID"
#define UserNameUpdate @"User name update"

// Firebase model define
#define UserCollectionData @"users"
#define DriverCollectionData @"drivers"
#define LocationCollectionData @"locations"
#define EventCollectionData @"events"


// Client Model object
#define UserId    @"userId"
#define UserType  @"userType"
#define UserName  @"name"
#define UserPhone @"phone"
#define UserImage @"image_url"
#define UserHometown @"hometown"
#define UserNameId @"nameId"

#define TaxiBrand @"taxi_brand"
#define CarNumber @"car_number"
#define CarName   @"car_name"

#define UserLongtitude @"longtitude"
#define UserLatitude @"latitude"


#define TypeUser @"type user"
#define TypeDriver @"type driver"


#define UserData @"userData"

// Client Model object event
#define UserDestination @"destination"
#define UserStartTime @"startTime"
#define UserPrice @"price"
#define UserFrom @"from"
#define UserNote @"note"


#define SearchKeyFrom @"search_key_from"
#define SearchKeyDestination @"search_key_destination"


typedef NS_ENUM(NSUInteger, UserRegistedType) {
    kUser,
    kDriver,
};

#define ArrayProvince  @[@"Hà Nội",@"Hà Giang",@"Cao Bằng",@"Bắc Kạn",@"Tuyên Quang",@"Lào Cai",@"Điện Biên",@"Lai Châu",@"Sơn La",@"Yên Bái",@"Hòa Bình",@"Thái Nguyên",@"Lạng Sơn",@"Quảng Ninh",@"Bắc Giang",@"Phú Thọ",@"Vĩnh Phúc",@"Bắc Ninh",@"Hải Dương",@"Hải Phòng",@"Hưng Yên",@"Thái Bình",@"Hà Nam",@"Nam Định",@"Ninh Bình",@"Thanh Hóa",@"Nghệ An",@"Hà Tĩnh",@"Quảng Bình",@"Quảng Trị",@"Thừa Thiên–Huế",@"Đà Nẵng",@"Quảng Nam",@"Quảng Ngãi",@"Bình Định",@"Phú Yên",@"Khánh Hòa",@"Ninh Thuận",@"Bình Thuận",@"Kon Tum",@"Gia Lai",@"Đắk Lắk",@"Đắk Nông",@"Lâm Đồng",@"Bình Phước",@"Tây Ninh",@"Bình Dương",@"Đồng Nai",@"Bà Rịa Vũng Tàu",@"Thành phố Hồ Chí Minh",@"Long An",@"Tiền Giang",@"Bến Tre",@"Trà Vinh",@"Vĩnh Long",@"Đồng Tháp",@"An Giang",@"Kiên Giang",@"Cần Thơ",@"Hậu Giang",@"Sóc Trăng",@"Bạc Liêu",@"Cà Mau"]


#define ProvinceWithoutAccented @[@"HaNoi",@"HaGiang",@"CaoBang",@"BacKan",@"TuyenQuang",@"LaoCai",@"DienBien",@"LaiChau",@"SonLa",@"YenBai",@"HoaBinh",@"ThaiNguyen",@"LangSon",@"QuangNinh",@"BacGiang",@"PhuTho",@"VinhPhuc",@"BacNinh",@"HaiDuong",@"HaiPhong",@"HungYen",@"ThaiBinh",@"HaNam",@"NamDinh",@"NinhBinh",@"ThanhHoa",@"NgheAn",@"HaTinh",@"QuangBinh",@"QuangTri",@"ThuaThienHue",@"DaNang",@"QuangNam",@"QuangNgai",@"BinhDinh",@"PhuYen",@"KhanhHoa",@"NinhThuan",@"BinhThuan",@"KonTum",@"GiaLai",@"DakLak",@"DakNong",@"LamDong",@"BinhPhuoc",@"TayNinh",@"BinhDuong",@"DongNai",@"BaRiaVungTau",@"ThanhphoHoChiMinh",@"LongAn",@"TienGiang",@"BenTre",@"TraVinh",@"VinhLong",@"DongThap",@"AnGiang",@"KienGiang",@"CanTho",@"HauGiang",@"SocTrang",@"BacLieu",@"CaMau"]



#endif /* Define_h */





















