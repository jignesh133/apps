//
//  ViewController.h
//  outlookContact
//
//  Created by OWNER on 03/08/17.
//  Copyright © 2017 OWNER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OutlookContacts.h"

@interface ViewController : UIViewController<OutlookContactsDelegate>
{
 OutlookContacts *outlookview;
}

@end

