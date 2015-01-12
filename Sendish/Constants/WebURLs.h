//
//  WebURLs.h
//  Sendish
//
//  Created by Rajat Sharma on 03/01/15.
//  Copyright (c) 2015 Rajat Sharma. All rights reserved.
//

#ifndef Sendish_WebURLs_h
#define Sendish_WebURLs_h

#define BasePath @"http://api.sendish.com/"

#define Login @"api/v1.0/user-profile"
#define Register @"api/v1.0/registration"
#define ResetPassword @"api/v1.0/registration/reset-password"

#define UpdateLocation @"api/v1.0/user-profile/update-location"

#define SendSendish @"api/v1.0/photos/sendish-upload"
#define ReceivedSendishList @"api/v1.0/photos/received"

#define SentSendishList @"api/v1.0/photos/sent"
#define GetSentImage @"api/v1.0/photos/sent/%@/view"

#endif

