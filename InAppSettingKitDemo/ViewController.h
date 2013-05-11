//
//  ViewController.h
//  InAppSettingKitDemo
//
//  Created by zheng on 13-5-10.
//  Copyright (c) 2013年 zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../InAppSettingsKit/Controllers/IASKAppSettingsViewController.h"
@interface ViewController : UIViewController<IASKSettingsDelegate>
{
    IASKAppSettingsViewController *appSettingsViewController;
}
@property (nonatomic, retain) IASKAppSettingsViewController *appSettingsViewController;
- (IBAction)showSettingsModal:(id)sender;
@end
