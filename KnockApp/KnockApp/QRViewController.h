//
//  QRViewController.h
//  KnockApp
//
//  Created by Fangzhou Sun on 11/24/15.
//  Copyright © 2015 Fangzhou Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Canvas.h"

@interface QRViewController : UIViewController

- (IBAction)btnQRBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet CSAnimationView *cSAV_view;
@end
