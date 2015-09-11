//
//  Constants.m
//  Tinder
//
//  Created by Vinay Raja on 07/12/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import "AppConstants.h"


NSString *TOKEN                          = @"TOKEN";

//WebServices

//Base URL
NSString *BASE_URL                      //=@"http://www.skcript.com/appdupe/flamer2/process.php/";//live
                                        //=@"http://192.168.0.114/PHP_Server/phpserver/process.php/";//local
                                         =@"http://elluminati.in/tinder_web/process.php/";
//Methods
NSString *MethodLogin                    = @"login";
NSString *MethodUpdatePreferences        = @"updatePreferences";
NSString *MethodUploadImage              = @"uploadImage";
NSString *MethodDeleteImage              = @"deleteImage";
NSString *MethodSetUserLikes             = @"setLikes";
NSString *MethodFindMatches              = @"findMatches";
NSString *MethodInviteAction             = @"inviteAction";
NSString *MethodBlockUser                = @"blockUser";
NSString *MethodGetProfileMatches        = @"getProfileMatches";
NSString *MethodGetNotifications         = @"getNotifications";
NSString *MethodGetProfile               = @"getProfile";
NSString *MethodGetPreferences           = @"getPreferences";
NSString *MethodEditProfile              = @"editProfile";
NSString *MethodUpdateLocation           = @"updateLocation";
NSString *MethodSendMessage              = @"sendMessage";
NSString *MethodGetChatHistory           = @"getChatHistory";
NSString *MethodGetChatMessage           = @"getChatMessage";
NSString *MethodLogout                   = @"logout";
NSString *MethodUpdateSession            = @"updateSession";
NSString *MethodDeleteAccount            =@"deleteAccount";

//Requests

//Common Request Params

NSString *RPSessionToken                 = @"ent_sess_token";
NSString *RPDeviceId                     = @"ent_dev_id";
NSString *RPFBId                         = @"ent_fbid";
NSString *RPUserFBId                     = @"ent_user_fbid";

//Request Params For Login
NSString *RPLoginFirstName               = @"ent_first_name";
NSString *RPLoginLastName                = @"ent_last_name";
//@"ent_fbid";
NSString *RPLoginEmail                   = @"ent_email";
NSString *RPLoginSex                     = @"ent_sex";
NSString *RPLoginCity                    = @"ent_city";
NSString *RPLoginCountry                 = @"ent_country";
NSString *RPLoginCurrentLatitude         = @"ent_curr_lat";
NSString *RPLoginCurrentLongitude        = @"ent_curr_long";
NSString *RPLoginTagLine                 = @"ent_tag_line";
NSString *RPLoginPersonalDescription     = @"ent_pers_desc";
NSString *RPLoginDOB                     = @"ent_dob";
NSString *RPLoginPrefSex                 = @"ent_pref_sex";
NSString *RPLoginPrefLowerAge            = @"ent_pref_lower_age";
NSString *RPLoginPrefUpperAge            = @"ent_pref_upper_age";
NSString *RPLoginRadius                  = @"ent_pref_radius";
NSString *RPLoginLikes                   = @"ent_likes";
//@"ent_dev_id";
NSString *RPLoginPushToken               = @"ent_push_token";
NSString *RPLoginQBId                    = @"ent_qbid";
NSString *RPLoginDeviceType              = @"ent_device_type";
NSString *RPLoginAuthType                = @"ent_auth_type";

//Request Params For updatePrefrance

//@"ent_sess_token";
//@"ent_dev_id";
 NSString *RPUpdatePreferedSex          = @"ent_sex";
 NSString *RPUpdatePreferedPrefSex      = @"ent_pref_sex";
 NSString *RPUpdatePreferedLowerAge     = @"ent_pref_lower_age";
 NSString *RPUpdatePreferedUpperAge     = @"ent_pref_upper_age";
 NSString *RPUpdatePreferedRadius       = @"ent_pref_radius";
 NSString *RPUpdatePreferedDistanceType = @"ent_distance_type";


//Request Params For UploadImages

//@"ent_sess_token";
//@"ent_dev_id";
 NSString *RPUploadImageProfileImage    = @"ent_prof_url";
 NSString *RPUploadImageOtherUrl        = @"ent_other_urls";


//Request Params For DeleteImage

//@"ent_sess_token";
//@"ent_dev_id";
 NSString *RPDeleteImageImageName       = @"ent_image_name";
 NSString *RPDeleteImageflag            = @"ent_image_flag";


//Request Params For getPrefrence

//@"ent_sess_token";
//@"ent_dev_id";


//Request Params For SetUserLike

//@"ent_sess_token";
//@"ent_dev_id";
 NSString *RPSetUserLikeId              = @"ent_likes";


//Request Params For FindMatches

//@"ent_sess_token";
//@"ent_dev_id";



//Request Params For InviteAction

//@"ent_sess_token";
//@"ent_dev_id";
 NSString *RPInviteActionFBId           = @"ent_invitee_fbid";
 NSString *RPInviteActionUserAction     = @"ent_user_action";


//Request Params For BlockUser

//@"ent_sess_token";
//@"ent_dev_id";
//@"ent_user_fbid";
 NSString *RPBlockUserflag             = @"ent_flag";



//Request Params For GetUserLikeProfile

//@"ent_sess_token";
//@"ent_dev_id";
 NSString *RPGetUserLikeProfileDateTime      = @"ent_datetime";


//Request Params For GetNotification

//@"ent_sess_token";
//@"ent_dev_id";



//Request Params For GetUserProfile

//@"ent_sess_token";
//@"ent_dev_id";
//@"ent_user_fbid";


//Request Params For EditUserProfile

//@"ent_sess_token";
//@"ent_dev_id";
 NSString *RPEditUserProfilePersonalDescription  = @"ent_pers_desc";


//Request Params For UploadLocation

//@"ent_sess_token";
//@"ent_dev_id";
 NSString *RPUploadLocationCurrentLattitude      = @"ent_curr_lat";
 NSString *RPUploadLocationUserCurrentLongitute  = @"ent_curr_long";


//Request Params For SendMessage

//@"ent_sess_token";
//@"ent_dev_id";
//@"ent_user_fbid";
 NSString *RPSendMessageUserMessage              = @"ent_message";


//Request Params For GetChatMessage

//@"ent_sess_token";
//@"ent_dev_id";
 NSString *RPGetChatMessageMessageId             = @"ent_msg_id";


//Request Params For GetChatHistory

//@"ent_sess_token";
//@"ent_dev_id";
//@"ent_user_fbid";
 NSString *RPGetChatHistoryPageNumber            = @"ent_chat_page";


//Request Params For LogOutUser

//@"ent_sess_token";
//@"ent_dev_id";


//Request Params For PushNotificationForIOS

 NSString *RPPushNotificationForIOSCertificate            = @"ent_ios_cer";
 NSString *RPPushNotificationForIOSCertificatePassword    = @"ent_cer_pass";
 NSString *RPPushNotificationForIOSCertificateType        = @"ent_cer_type";
 NSString *RPPushNotificationForIOSPushToken              = @"ent_push_token";
 NSString *RPPushNotificationForIOSPushMessage            = @"ent_message";

//Request Params for Updating Session

//@"ent_sess_token";
//@"ent_dev_id";
//@"ent_fbid";


//UserDeafults Keys

//Request UserDefulatKey

 NSString *UDFacebookDetail =@"FBUSERDETAIL";
 NSString *UDLoginRequest =@"FBUserDetail1";



