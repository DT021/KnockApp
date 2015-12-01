//
//  ViewController.h
//  KnockApp
//
//  Created by Fangzhou Sun on 11/15/15.
//  Copyright © 2015 Fangzhou Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Canvas.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet CSAnimationView *cSAV_passwordPad;
@property (weak, nonatomic) IBOutlet UILabel *uILbl_enteredPassword;
- (IBAction)didTapPad_1:(id)sender;
- (IBAction)didTapPad_2:(id)sender;
- (IBAction)didTapPad_3:(id)sender;
- (IBAction)didTapPad_4:(id)sender;
- (IBAction)didTapPad_5:(id)sender;
- (IBAction)didTapPad_6:(id)sender;
- (IBAction)didTapPad_7:(id)sender;
- (IBAction)didTapPad_8:(id)sender;
- (IBAction)didTapPad_9:(id)sender;
- (IBAction)didTapPad_0:(id)sender;
- (IBAction)didTapPad_backspace:(id)sender;
- (IBAction)didTapPad_logout:(id)sender;

@property (weak, nonatomic) IBOutlet CSAnimationView *cSAV_touchID;

- (IBAction)didTapLoginWithTouchID:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginWithTouchID;
@property (weak, nonatomic) IBOutlet CSAnimationView *cSAV_info;
@property (weak, nonatomic) IBOutlet UILabel *uILbl_info;
@property (weak, nonatomic) IBOutlet UIButton *uIButton_touchID;

@end

