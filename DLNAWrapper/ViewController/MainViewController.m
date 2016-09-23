//
//  ViewController.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "Masonry.h"
#import "KissXML/KissXML.h"

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DeviceListViewController.h"
#import "DMCViewController.h"

#import "DLNAUpnpServer.h"

@interface MainViewController ()

@property UILabel *deviceCountLabel;
@property UILabel *deviceName;
@property UITextField *urlField;

@property int deviceIndex;

@end

@implementation MainViewController

@synthesize deviceCountLabel;
@synthesize deviceName;
@synthesize urlField;

@synthesize deviceIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.deviceIndex = -1;
    
    [self createView];
    
    [DLNAUpnpServer server].delegate = self;
    
    [[DLNAUpnpServer server] start];
}

- (void)createView
{
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    UIView *statusBarView = [[UIView alloc] initWithFrame:statusBarFrame];
    statusBarView.backgroundColor = [AppDelegate getColor:@"3f51b5"];
    [self.view addSubview:statusBarView];
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = @"DLNATest";
    topLabel.textColor = [UIColor whiteColor];
    topLabel.backgroundColor = [AppDelegate getColor:@"3f51b5"];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:topLabel];
    
    deviceCountLabel = [[UILabel alloc] init];
    deviceCountLabel.text = [[NSString alloc] initWithFormat:@"已发现设备数量：%d", 0];
    deviceCountLabel.textColor = [UIColor blackColor];
    deviceCountLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:deviceCountLabel];
    
    deviceName = [[UILabel alloc] init];
    deviceName.text = @"请选择设备";
    deviceName.textColor = [UIColor blackColor];
    deviceName.textAlignment = NSTextAlignmentLeft;
    deviceName.numberOfLines = 1;
    deviceName.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.view addSubview:deviceName];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    [self.view addSubview:arrowView];
    
    urlField = [[UITextField alloc] init];
    urlField.text = @"http://192.168.1.9:8080/video/temp/Snow_halation.mp4";
    [urlField setBorderStyle:UITextBorderStyleRoundedRect];
    urlField.placeholder = @"请输入投射的媒体url";
    urlField.returnKeyType = UIReturnKeyDone;
    urlField.clearButtonMode = UITextFieldViewModeWhileEditing;
    urlField.delegate = self;
    [self.view addSubview:urlField];
    
    UIButton *routeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    routeBtn.layer.masksToBounds = YES;
    routeBtn.layer.cornerRadius = 8;
    [routeBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [routeBtn setTitle:@"开始DLNA投射" forState:UIControlStateNormal];
    [routeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [routeBtn setBackgroundColor:[AppDelegate getColor:@"3f51b5"]];
    [routeBtn addTarget:self action:@selector(route:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:routeBtn];
    
    
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(statusBarView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@50);
    }];
    
    [deviceCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@48);
    }];
    
    [deviceName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceCountLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.height.equalTo(@48);
    }];
    
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.centerY.equalTo(deviceName);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];
    
    [urlField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceName.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
    
    [routeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(urlField.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
//        make.width.equalTo(@200);
    }];
    
    
    UITapGestureRecognizer *selectDeviceGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDevice)];
    selectDeviceGR.numberOfTapsRequired = 1;
    deviceName.userInteractionEnabled = YES;
    [deviceName addGestureRecognizer:selectDeviceGR];
    
}

- (void)selectDevice {
    DeviceListViewController *deviceVC = [[DeviceListViewController alloc] init];
    deviceVC.selectedDevice = ^(int index) {
        self.deviceIndex = index;
        NSString *name = [[[[DLNAUpnpServer server] deviceArray] objectAtIndex:index] name];
        NSLog(@"device name -- > %@", name);
        deviceName.text = name;
    };
    [self.navigationController pushViewController:deviceVC animated:YES];
}

- (void)route:(id)sender {
    if (deviceIndex == -1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先选择设备" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    DMCViewController *dmcVC = [[DMCViewController alloc] init];
    dmcVC.deviceIndex = self.deviceIndex;
    dmcVC.url = urlField.text;
    [self.navigationController pushViewController:dmcVC animated:YES];
}

- (void)onChange {
    int count = (int)[[[DLNAUpnpServer server] deviceArray] count];
    deviceCountLabel.text = [[NSString alloc] initWithFormat:@"已发现设备数量：%d", count];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.urlField resignFirstResponder];
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
