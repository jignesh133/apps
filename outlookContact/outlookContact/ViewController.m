//
//  ViewController.m
//  outlookContact
//
//  Created by OWNER on 03/08/17.
//  Copyright © 2017 OWNER. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    outlookview = [OutlookContacts initWithNIB];
    [outlookview setDelegate:self];
    outlookview.frame = self.view.frame;
    
    // ADDED ANIMATATINO FOR TRANSITION
    CATransition *transition = [CATransition animation];
    transition.duration = 3.3;
    transition.type = kCATransitionFade; //choose your animation
    [outlookview.layer addAnimation:transition forKey:nil];
    [self.view addSubview:outlookview];
    
    // METHOD AUTHORIZATATION TO GET DATA
    [outlookview methodAuthorizatation];
    
}
//***********************************************************************************************************************
//********************************************************* OutlookContactsDelegate *************************************

-(void)methodGetDataSuccess:(id)data{
    
    dispatch_async (dispatch_get_main_queue(), ^{
        if([outlookview isDescendantOfView:self.view])
        {
            [outlookview.layer removeAllAnimations];
            [outlookview removeFromSuperview];
        }
    });
    
}
-(void)methodGetDataFailler:(id)data{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
