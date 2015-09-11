//
//  Constants.h
//  Tinder
//
//  Created by Vinay Raja on 07/12/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


extern NSString *TOKEN;


//WebServices

//Base URL
extern NSString *BASE_URL;

//Methods
extern NSString *MethodLogin;
extern NSString *MethodUpdatePreferences;
extern NSString *MethodUploadImage;
extern NSString *MethodDeleteImage;
extern NSString *MethodSetUserLikes;
extern NSString *MethodFindMatches;
extern NSString *MethodInviteAction;
extern NSString *MethodBlockUser;
extern NSString *MethodGetProfileMatches;
extern NSString *MethodGetNotifications;
extern NSString *MethodGetProfile;
extern NSString *MethodGetPreferences;
extern NSString *MethodEditProfile;
extern NSString *MethodUpdateLocation;
extern NSString *MethodSendMessage;
extern NSString *MethodGetChatHistory;
extern NSString *MethodGetChatMessage;
extern NSString *MethodLogout;
extern NSString *MethodUpdateSession;
extern NSString *MethodDeleteAccount;

//Common Request Params

extern NSString *RPSessionToken;
extern NSString *RPDeviceId;
extern NSString *RPFBId;
extern NSString *RPUserFBId;


//Request Params For login
extern NSString *RPLoginFirstName;
extern NSString *RPLoginLastName;
//extern NSString *RPLoginFBId;
extern NSString *RPLoginEmail;
extern NSString *RPLoginSex;
extern NSString *RPLoginCity;
extern NSString *RPLoginCountry;
extern NSString *RPLoginCurrentLatitude;
extern NSString *RPLoginCurrentLongitude;
extern NSString *RPLoginTagLine;
extern NSString *RPLoginPersonalDescription;
extern NSString *RPLoginDOB;
extern NSString *RPLoginPrefSex;
extern NSString *RPLoginPrefLowerAge;
extern NSString *RPLoginPrefUpperAge;
extern NSString *RPLoginRadius;
extern NSString *RPLoginLikes;
//extern NSString *RPLoginDeviceId;
extern NSString *RPLoginPushToken;
extern NSString *RPLoginQBId;
extern NSString *RPLoginDeviceType;
extern NSString *RPLoginAuthType;



//Request Params For updatePrefrance

//extern NSString *RPUpdatePreferedSessionToken;
//extern NSString *RPUpdatePreferedDeviceId;
extern NSString *RPUpdatePreferedSex;
extern NSString *RPUpdatePreferedPrefSex;
extern NSString *RPUpdatePreferedLowerAge;
extern NSString *RPUpdatePreferedUpperAge;
extern NSString *RPUpdatePreferedRadius;
extern NSString *RPUpdatePreferedDistanceType;


//Request Params For UploadImages

//extern NSString *RPUploadImageSessionToken;
//extern NSString *RPUploadImageDeviceId;
extern NSString *RPUploadImageProfileImage;
extern NSString *RPUploadImageOtherUrl;


//Request Params For DeleteImage

//extern NSString *RPDeleteImageSessionToken;
//extern NSString *RPDeleteImageDeviceId;
extern NSString *RPDeleteImageImageName;
extern NSString *RPDeleteImageflag;


//Request Params For getPrefrence

//extern NSString *RPGetPrefrenceSessionToken;
//extern NSString *RPGetPrefrenceDeviceId;


//Request Params For SetUserLike

//extern NSString *RPSetUserLikeSessionToken;
//extern NSString *RPSetUserLikeDeviceId;
extern NSString *RPSetUserLikeId;


//Request Params For FindMatches

//extern NSString *RPFindMatchesSessionToken;
//extern NSString *RPFindMatcheseDeviceId;



//Request Params For InviteAction

//extern NSString *RPInviteActionSessionToken;
//extern NSString *RPInviteActionDeviceId;
extern NSString *RPInviteActionFBId;
extern NSString *RPInviteActionUserAction;


//Request Params For BlockUser

//extern NSString *RPBlockUserSessionToken;
//extern NSString *RPBlockUserDeviceId;
//extern NSString *RPBlockUserFBId;
extern NSString *RPBlockUserflag;



//Request Params For GetUserLikeProfile

//extern NSString *RPGetUserLikeProfileSessionToken;
//extern NSString *RPGetUserLikeProfileDeviceId;
extern NSString *RPGetUserLikeProfileDateTime;


//Request Params For GetNotification

//extern NSString *RPGetNotificationSessionToken;
//extern NSString *RPGetNotificationeDeviceId;



//Request Params For GetUserProfile

//extern NSString *RPGetUserProfileSessionToken;
//extern NSString *RPGetUserProfileDeviceId;
//extern NSString *RPGetUserProfileFBId;


//Request Params For EditUserProfile

//extern NSString *RPEditUserProfileSessionToken;
//extern NSString *RPEditUserProfileDeviceId;
extern NSString *RPEditUserProfilePersonalDescription;


//Request Params For UploadLocation

//extern NSString *RPUploadLocationSessionToken;
//extern NSString *RPUploadLocationDeviceId;
extern NSString *RPUploadLocationCurrentLattitude;
extern NSString *RPUploadLocationUserCurrentLongitute;


//Request Params For SendMessage

//extern NSString *RPSendMessageSessionToken;
//extern NSString *RPSendMessageDeviceId;
//extern NSString *RPSendMessageUserFBId;
extern NSString *RPSendMessageUserMessage;


//Request Params For GetChatMessage

//extern NSString *RPGetChatMessageSessionToken;
//extern NSString *RPGetChatMessageDeviceId;
extern NSString *RPGetChatMessageMessageId;


//Request Params For GetChatHistory

//extern NSString *RPGetChatHistorySessionToken;
//extern NSString *RPGetChatHistoryDeviceId;
//extern NSString *RPGetChatHistoryUserFBId;
extern NSString *RPGetChatHistoryPageNumber;


//Request Params For LogOutUser

//extern NSString *RPLogOutUserSessionToken;
//extern NSString *RPLogOutUserDeviceId;


//Request Params For PushNotificationForIOS

//extern NSString *RPPushNotificationForIOSCertificate;
extern NSString *RPPushNotificationForIOSCertificatePassword;
extern NSString *RPPushNotificationForIOSCertificateType;
extern NSString *RPPushNotificationForIOSPushToken;
extern NSString *RPPushNotificationForIOSPushMessage;

//Request Params for Updating Session

//extern NSString *RPUpdateSessionToken;
//extern NSString *RPUpdateSessionDeviceId;
//extern NSString *RPUpdateSessionFBId;

//Request UserDefulatKey

extern NSString *UDFacebookDetail;
extern NSString *UDLoginRequest;






