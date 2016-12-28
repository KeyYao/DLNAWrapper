//
//  ViewController.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "MainViewController.h"

#import "Masonry.h"

#import "ExampleDefine.h"
#import "UIColor+ColorFormat.h"
#import "DeviceListViewController.h"
#import "DMCViewController.h"
#import "InputAddressViewController.h"
#import "AssetListViewController.h"

#import "DLNAUpnpServer.h"
#import "FileServer.h"

@interface MainViewController ()

@property UILabel *deviceCountLabel;
@property UILabel *deviceName;
@property UILabel *targetAddressLabel;

@property int deviceIndex;

@end

@implementation MainViewController

@synthesize deviceCountLabel;
@synthesize deviceName;
@synthesize targetAddressLabel;

@synthesize deviceIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.deviceIndex = -1;
    
    [self createView];
    
    [DLNAUpnpServer server].delegate = self;
    
    [[DLNAUpnpServer server] start];
    
    [[FileServer server] start];
}

- (void)createView
{
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    UIView *statusBarView = [[UIView alloc] initWithFrame:statusBarFrame];
    statusBarView.backgroundColor = THEME_COLOR;
    [self.view addSubview:statusBarView];
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = @"DLNATest";
    topLabel.textColor = [UIColor whiteColor];
    topLabel.backgroundColor = THEME_COLOR;
    topLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:topLabel];
    
    deviceCountLabel = [[UILabel alloc] init];
    deviceCountLabel.text = [[NSString alloc] initWithFormat:@"已发现设备数量：%d", 0];
    deviceCountLabel.textColor = [UIColor blackColor];
    deviceCountLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:deviceCountLabel];
    
    deviceName = [[UILabel alloc] init];
    deviceName.text = @"选择设备";
    deviceName.textColor = [UIColor blackColor];
    deviceName.textAlignment = NSTextAlignmentLeft;
    deviceName.numberOfLines = 1;
    deviceName.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.view addSubview:deviceName];
    
    UIImageView *deviceArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    [self.view addSubview:deviceArrowView];
    
    UILabel *selectLocalPhotoLabel = [[UILabel alloc] init];
    selectLocalPhotoLabel.text = @"选择本地相册图片";
    selectLocalPhotoLabel.textColor = [UIColor blackColor];
    selectLocalPhotoLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:selectLocalPhotoLabel];
    
    UIImageView *localPhotoArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    [self.view addSubview:localPhotoArrowView];
    
    UILabel *selectLocalVideoLabel = [[UILabel alloc] init];
    selectLocalVideoLabel.text = @"选择本地相册视频";
    selectLocalVideoLabel.textColor = [UIColor blackColor];
    selectLocalVideoLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:selectLocalVideoLabel];
    
    UIImageView *localVideoArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    [self.view addSubview:localVideoArrowView];
    
    UILabel *inputNetworkLabel = [[UILabel alloc] init];
    inputNetworkLabel.text = @"输入网络地址";
    inputNetworkLabel.textColor = [UIColor blackColor];
    inputNetworkLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:inputNetworkLabel];
    
    UIImageView *networkArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    [self.view addSubview:networkArrowView];
    
    UILabel *urlTitle = [[UILabel alloc] init];
    urlTitle.text = @"投屏地址：";
    urlTitle.textColor = [UIColor blackColor];
    urlTitle.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:urlTitle];
    
    targetAddressLabel = [[UILabel alloc] init];
    targetAddressLabel.text = @"";
    targetAddressLabel.textColor = [UIColor blackColor];
    targetAddressLabel.numberOfLines = 0;
    [targetAddressLabel sizeToFit];
    [self.view addSubview:targetAddressLabel];
    
    UIButton *routeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    routeBtn.layer.masksToBounds = YES;
    routeBtn.layer.cornerRadius = 8;
    [routeBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [routeBtn setTitle:@"开始DLNA投屏" forState:UIControlStateNormal];
    [routeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [routeBtn setBackgroundColor:THEME_COLOR];
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
    
    [deviceArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.centerY.equalTo(deviceName);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];
    
    [selectLocalPhotoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceName.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.height.equalTo(@48);
    }];
    
    [localPhotoArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.centerY.equalTo(selectLocalPhotoLabel);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];
    
    [selectLocalVideoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(selectLocalPhotoLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.height.equalTo(@48);
    }];
    
    [localVideoArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.centerY.equalTo(selectLocalVideoLabel);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];
    
    [inputNetworkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(selectLocalVideoLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.height.equalTo(@48);
    }];
    
    [networkArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.centerY.equalTo(inputNetworkLabel);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];
    
    [urlTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputNetworkLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@48);
    }];
    
    [targetAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(urlTitle.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left).offset(25);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
    
    [routeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(targetAddressLabel.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];
    
    
    UITapGestureRecognizer *selectDeviceGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDevice)];
    selectDeviceGR.numberOfTapsRequired = 1;
    deviceName.userInteractionEnabled = YES;
    [deviceName addGestureRecognizer:selectDeviceGR];
    
    UITapGestureRecognizer *selectPhotoGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhoto)];
    selectDeviceGR.numberOfTapsRequired = 1;
    selectLocalPhotoLabel.userInteractionEnabled = YES;
    [selectLocalPhotoLabel addGestureRecognizer:selectPhotoGR];
    
    UITapGestureRecognizer *selectVideoGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectVideo)];
    selectDeviceGR.numberOfTapsRequired = 1;
    selectLocalVideoLabel.userInteractionEnabled = YES;
    [selectLocalVideoLabel addGestureRecognizer:selectVideoGR];
    
    UITapGestureRecognizer *inputAddressGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputAddress)];
    selectDeviceGR.numberOfTapsRequired = 1;
    inputNetworkLabel.userInteractionEnabled = YES;
    [inputNetworkLabel addGestureRecognizer:inputAddressGR];
    
    
}

- (void)selectDevice {
    DeviceListViewController *deviceVC = [[DeviceListViewController alloc] init];
    deviceVC.selectedDevice = ^(int index) {
        self.deviceIndex = index;
        NSString *name = [[[[DLNAUpnpServer server] getDeviceList] objectAtIndex:index] name];
        NSLog(@"device name -- > %@", name);
        deviceName.text = name;
    };
    [self.navigationController pushViewController:deviceVC animated:YES];
}

- (void)selectPhoto {
    AssetListViewController *photoViewController = [[AssetListViewController alloc] init];
    photoViewController.isShowVideo = NO;
    photoViewController.address = ^(NSString *address) {
        targetAddressLabel.text = address;
    };
    [self.navigationController pushViewController:photoViewController animated:YES];
}

- (void)selectVideo {
    AssetListViewController *videoViewController = [[AssetListViewController alloc] init];
    videoViewController.isShowVideo = YES;
    videoViewController.address = ^(NSString *address) {
        targetAddressLabel.text = address;
    };
    [self.navigationController pushViewController:videoViewController animated:YES];
}

- (void)inputAddress {
    InputAddressViewController *inputAddress = [[InputAddressViewController alloc] init];
    inputAddress.address = ^(NSString *address) {
        targetAddressLabel.text = address;
    };
    [self.navigationController pushViewController:inputAddress animated:YES];
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
    dmcVC.url = targetAddressLabel.text;
    [self.navigationController pushViewController:dmcVC animated:YES];
}

- (void)onChange {
    int count = (int)[[[DLNAUpnpServer server] getDeviceList] count];
    deviceCountLabel.text = [[NSString alloc] initWithFormat:@"已发现设备数量：%d", count];
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
