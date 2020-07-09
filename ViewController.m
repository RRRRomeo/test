//
//  ViewController.m
//  地址二级联动案例
//
//  Created by 芝麻汤圆 on 2020/6/17.
//  Copyright © 2020 芝麻汤圆. All rights reserved.
//

#import "ViewController.h"
#import "TTProvince.h"
@interface ViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (nonatomic, strong) NSArray *provinces;

@property (nonatomic, strong) TTProvince *selectedProvince;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self pickerView:self.pickView didSelectRow:0 inComponent:0];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [pickerView reloadComponent:1];
    }
    
    //将文字内容显示到label上
    //省市的行索引
    NSInteger selectedProvinceIndex = [pickerView selectedRowInComponent:0];
    NSInteger selectedCityIndex = [pickerView selectedRowInComponent:1];
    //获取模型数据
    TTProvince *provinceModel = self.provinces[selectedProvinceIndex];
    
    //赋值到label
    self.provinceLabel.text = provinceModel.state;
    self.cityLabel.text = self.selectedProvince.cities[selectedCityIndex];   //数组怎么一直越界！！！！！
}

//懒加载
-(NSArray *)provinces {
    if (!_provinces) {
        
        NSArray *arrayDict = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"location.plist" ofType:nil]];
        NSMutableArray *arraymodels = [NSMutableArray array];
        for (NSDictionary *dict in arrayDict) {
            TTProvince *mdoel = [TTProvince provinceWithDict:dict];
            [arraymodels addObject:mdoel];
        }
        _provinces = arraymodels;
    }
    return _provinces;
}

#pragma mark -显示数据到pickView上
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    //判断是那一列
    if (component == 0) {
        return self.provinces.count;
    } else {
        NSInteger selectedProvinceIndex =  [pickerView selectedRowInComponent:0];
        TTProvince *selectedProvince = self.provinces[selectedProvinceIndex];
        self.selectedProvince = selectedProvince;
//        NSInteger citiesCount = selectedProvince.cities.count;
//        NSLog(@"%d",(int)citiesCount);
        return self.selectedProvince.cities.count;
    }
}

//设置pickerView上的显示数据
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //先拿到模型数据
    //判断component
    //第一列显示省份
    //第二列显示所选省份的市
    if (component == 0) {
        TTProvince *province = self.provinces[row];
        return province.state;
    } else {
        //选的省份的索引
//        NSInteger selectedProvinceIndex = [pickerView selectedRowInComponent:0];
//        TTProvince *selectedProvince =  self.provinces[selectedProvinceIndex];
        
        return self.selectedProvince.cities[row];
    }

}


@end
