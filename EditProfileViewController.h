//
//  EditProfileViewController.h
//  Tinder
//
//  Created by Vinay Raja on 05/12/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileViewController : UIViewController<UITextViewDelegate>
//+(void)croppedFacebookImage:(UIImage*)croppedImage;
{
    IBOutlet UITextView *txtView;
}

-(void)setUpImages:(NSArray*)images;

-(IBAction)addDeletePics:(id)sender;

@end
