//
//  OutlookContacts.h
//  googleData
//
//  Created by OWNER on 03/08/17.
//  Copyright © 2017 OWNER. All rights reserved.
//

#import <UIKit/UIKit.h>


// DECELARE THE OUTLOOK DELEGATE
@protocol OutlookContactsDelegate <NSObject>
-(void)methodGetDataSuccess:(id)data;
-(void)methodGetDataFailler:(id)data;
@end

@interface OutlookContacts : UIView<UIWebViewDelegate>{
    IBOutlet UIWebView *objWebLinkedIn;
    IBOutlet UIActivityIndicatorView *objActivity;
}
-(void)methodAuthorizatation;
-(IBAction)methodCancelClick:(id)sender;


@property (nonatomic,retain) id<OutlookContactsDelegate> delegate;

+(OutlookContacts *)initWithNIB;

@end
