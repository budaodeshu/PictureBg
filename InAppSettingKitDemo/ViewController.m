//
//  ViewController.m
//  InAppSettingKitDemo
//
//  Created by zheng on 13-5-10.
//  Copyright (c) 2013年 zheng. All rights reserved.
//

#import "ViewController.h"
#import <MessageUI/MessageUI.h>
@interface ViewController ()<UIPopoverControllerDelegate>
- (void)settingDidChange:(NSNotification *)notification;
@property (nonatomic) UIPopoverController *currentPopoverController;

@end

@implementation ViewController
@synthesize appSettingsViewController;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IASKAppSettingsViewController *)appSettingsViewController
{
    if (!appSettingsViewController) {
        appSettingsViewController = [[IASKAppSettingsViewController alloc] init];
        appSettingsViewController.delegate = self;
        BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"AutoConnect"];
        appSettingsViewController.hiddenKeys = enabled ? nil : [NSSet setWithObjects:@"AutoConnectLogin", @"AutoConnectPassword", nil];
    }
    return appSettingsViewController;
}

- (IBAction)showSettingsModal:(id)sender
{
    UINavigationController *aNavController = [[UINavigationController alloc] initWithRootViewController:self.appSettingsViewController];
    self.appSettingsViewController.showDoneButton = YES;
    [self presentModalViewController:aNavController animated:YES];
    [aNavController release];
}

#pragma mark -
#pragma mark IASKAppSettingsViewControllerDelegate protocol
- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
    [self dismissModalViewControllerAnimated:YES];
	
	// your code here to reconfigure the app for changed settings
}

#pragma mark - UITableView cell customization
- (CGFloat)tableView:(UITableView*)tableView heightForSpecifier:(IASKSpecifier*)specifier
{
    if ([specifier.key isEqualToString:@""])
    {
        return 44*3;
    }
    return 0;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForSpecifier:(IASKSpecifier*)specifier
{
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:specifier.key];
	
	if (!cell) {
		cell = (UITableViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"CustomViewCell"
															   owner:self
															 options:nil] objectAtIndex:0];
	}
	cell.textLabel.text= [[NSUserDefaults standardUserDefaults] objectForKey:specifier.key] != nil ?
    [[NSUserDefaults standardUserDefaults] objectForKey:specifier.key] : [specifier defaultStringValue];
	//cell.textLabel.delegate = self;
	[cell setNeedsLayout];
	return cell;

}
/*
- (void)showSettingsPopover:(id)sender
{
    if (self.currentPopoverController)
    {
        [self dismissCurrentPopover];
        return;
    }
    
    self.appSettingsViewController.showDoneButton = NO;
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:self.appSettingsViewController] autorelease];
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navController];
    popover.delegate = self;
    [popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:NO];
    self.currentPopoverController = popover;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.currentPopoverController) {
        [self dismissCurrentPopover];
    }
}
- (void)dismissCurrentPopover
{
    [self.currentPopoverController dismissPopoverAnimated:YES];
    self.currentPopoverController = nil;
}

- (CGFloat)settingsViewController:(id<IASKViewController>)settingsViewController tableView:(UITableView *)tableView heightForHeaderForSection:(NSInteger)section
{
    NSString *key = [settingsViewController.settingsReader keyForSection:section];
    if ([key isEqualToString:@"IASKLogo"])
    {
        return [UIImage imageNamed:@"Icon.png"].size.height + 25;
    }
    else if ([key isEqualToString:@"ISAKCustomHeaderStyle"])
    {
        return 55.0f;
    }
    return 0;
}

- (UIView *)settingsViewController:(id<IASKViewController>)settingsViewController
                          tableView:(UITableView *)tableView
            viewForHeaderForSection:(NSInteger)section
{
    NSString *key = [settingsViewController.settingsReader keyForSection:section];
    
}*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




















