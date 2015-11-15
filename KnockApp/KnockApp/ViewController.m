//
//  ViewController.m
//  KnockApp
//
//  Created by Fangzhou Sun on 11/15/15.
//  Copyright © 2015 Fangzhou Sun. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)authenicateUser {
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"";
    
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"Are you the device owner?"
                          reply:^(BOOL success, NSError *error) {
                              
                              if (error) {
                                  NSLog(@"error");
                                  return;
                              }
                              
                              if (success) {
                                  NSLog(@"success");
                                  return;
                                  
                              } else {
                                  NSLog(@"not owner");
                                  return;
                              }
                              
                          }];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Your device cannot authenticate using TouchID."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapLoginWithTouchID:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self authenicateUser];
    });
}
@end
