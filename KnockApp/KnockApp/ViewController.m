//
//  ViewController.m
//  KnockApp
//
//  Created by Fangzhou Sun on 11/15/15.
//  Copyright © 2015 Fangzhou Sun. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

enum ViewStatus {
    ViewStatus_unregistered,
    ViewStatus_waitingSignin,
};

@interface ViewController () {
    enum ViewStatus viewStatus;
    NSString *enteredCodeStr;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    viewStatus = ViewStatus_unregistered;
    [self UpdateViewByViewStatus];
}

- (void)UpdateViewByViewStatus {
    enteredCodeStr = @"";
    switch (viewStatus) {
        case ViewStatus_unregistered: {
            [self updateCodeLabel:-1];
            [self.btnLoginWithTouchID setTitle:@"Sign up" forState:UIControlStateNormal];
            
            self.cSAV_passwordPad.type = CSAnimationTypeZoomOut;
            self.cSAV_passwordPad.duration = 0.3;
            self.cSAV_passwordPad.delay = 0.0;
            [self.cSAV_passwordPad startCanvasAnimation];
            self.cSAV_passwordPad.alpha = 0.75;
            
            self.cSAV_touchID.hidden = YES;
            break;
        }
        case ViewStatus_waitingSignin: {
            [self updateCodeLabel:-1];
            [self.btnLoginWithTouchID setTitle:@"Log out" forState:UIControlStateNormal];
            
            self.cSAV_passwordPad.type = CSAnimationTypeBounceLeft;
            self.cSAV_passwordPad.duration = 0.3;
            self.cSAV_passwordPad.delay = 0.0;
            [self.cSAV_passwordPad startCanvasAnimation];
            self.cSAV_passwordPad.alpha = 0.75;
            
            LAContext *context = [[LAContext alloc] init];
            context.localizedFallbackTitle = @"";
            NSError *error = nil;
            if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
                self.cSAV_touchID.type = CSAnimationTypeBounceLeft;
                self.cSAV_touchID.duration = 0.3;
                self.cSAV_touchID.delay = 0.0;
                [self.cSAV_touchID startCanvasAnimation];
                self.cSAV_touchID.hidden = NO;
            } else {
                self.cSAV_touchID.hidden = YES;
            }
            break;
        }
        default:
            break;
    }
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
- (IBAction)didTapPad_1:(id)sender {
    [self updateCodeLabel: 1];
}
- (IBAction)didTapPad_2:(id)sender {
    [self updateCodeLabel: 2];
}
- (IBAction)didTapPad_3:(id)sender {
    [self updateCodeLabel: 3];
}
- (IBAction)didTapPad_4:(id)sender {
    [self updateCodeLabel: 4];
}
- (IBAction)didTapPad_5:(id)sender {
    [self updateCodeLabel: 5];
}
- (IBAction)didTapPad_6:(id)sender {
    [self updateCodeLabel: 6];
}
- (IBAction)didTapPad_7:(id)sender {
    [self updateCodeLabel: 7];
}
- (IBAction)didTapPad_8:(id)sender {
    [self updateCodeLabel: 8];
}
- (IBAction)didTapPad_9:(id)sender {
    [self updateCodeLabel: 9];
}
- (IBAction)didTapPad_0:(id)sender {
    [self updateCodeLabel: 0];
}
- (IBAction)didTapPad_backspace:(id)sender {
    [self updateCodeLabel:-1];
}
-(void)updateCodeLabel:(int)input {
    if (input>=0) {
        if (enteredCodeStr.length<4) {
            enteredCodeStr = [enteredCodeStr stringByAppendingString:[NSString stringWithFormat:@"%d", input]];
        } else {
            enteredCodeStr = [NSString stringWithFormat:@"%d", input];
        }
    } else if (input==-1) {
        if (enteredCodeStr.length>0)
            enteredCodeStr = [enteredCodeStr substringWithRange:NSMakeRange(0, enteredCodeStr.length-1)];
    }
    
    if (enteredCodeStr.length<1) {
        self.cSAV_info.hidden = NO;
        switch (viewStatus) {
            case ViewStatus_unregistered: {
                self.uILbl_info.text = @"\U0000266B  Enter 4-digit code to sign up";
                self.cSAV_info.type = CSAnimationTypeFlash;
                self.cSAV_info.duration = 0.3;
                self.cSAV_info.delay = 1;
                [self.cSAV_info startCanvasAnimation];
                self.cSAV_info.alpha = 0.75;
                break;
            }
            case ViewStatus_waitingSignin: {
                self.uILbl_info.text = @"\U0000266B  Enter 4-digit code to log in";
                self.cSAV_info.type = CSAnimationTypeFlash;
                self.cSAV_info.duration = 0.3;
                self.cSAV_info.delay = 1;
                [self.cSAV_info startCanvasAnimation];
                self.cSAV_info.alpha = 0.75;
                break;
            }
            default:
                break;
        }
    } else {
        self.cSAV_info.hidden = YES;
    }
    
    NSString *stringToDisplay=@"";
    for (int i=0; i<4; i++) {
        if (i<enteredCodeStr.length) {
            switch (viewStatus) {
                case ViewStatus_unregistered: {
                    stringToDisplay = [stringToDisplay stringByAppendingString:[enteredCodeStr substringWithRange:NSMakeRange(i, 1)]];
                    break;
                }
                case ViewStatus_waitingSignin: {
                    stringToDisplay = [stringToDisplay stringByAppendingString:@"\U000025A3"];
                    break;
                }
                default:
                    break;
            }
        } else {
            stringToDisplay = [stringToDisplay stringByAppendingString:@"\U000025A2"];
        }
    }
    self.uILbl_enteredPassword.text = stringToDisplay;
}

- (IBAction)didTapPad_logout:(id)sender {
    if (viewStatus==ViewStatus_unregistered) {
        viewStatus = ViewStatus_waitingSignin;
    } else if (viewStatus==ViewStatus_waitingSignin) {
        viewStatus = ViewStatus_unregistered;
    }
    
    [self UpdateViewByViewStatus];
}
@end
