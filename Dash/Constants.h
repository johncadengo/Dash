//
//  Constants.h
//  Dash
//
//  Created by John Cadengo on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

// Colors
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
enum {
    kWelcomeTextColor = 0x6d6961,
    kWelcomeBGColor = 0xffedd5,
    kFilterLinesColor = 0xbfbfbf,
    kPlaceOrangeBGColor = 0xffedd6,
    kDashNavBarBGColor = 0x454545,
};

// Text
extern NSString * const kWelcomeText;
extern NSString * const kIntroText;
extern NSString * const kSignUpText;

// Fonts
extern NSString * const kPlutoExtraLight;
extern NSString * const kPlutoLight;
extern NSString * const kPlutoMedium;
extern NSString * const kPlutoRegular;
extern NSString * const kPlutoBlack;
extern NSString * const kPlutoBold;
extern NSString * const kPlutoHeavy;
extern NSString * const kPlutoCondExtraLight;
extern NSString * const kPlutoCondLight;
extern NSString * const kPlutoCondMedium;
extern NSString * const kPlutoCondRegular;
extern NSString * const kPlutoCondThin;
extern NSString * const kPlutoThin;
extern NSString * const kPlutoCondBlack;
extern NSString * const kPlutoCondBold;
extern NSString * const kPlutoCondHeavy;
extern NSString * const kHelveticaNeueBold;

// Identifiers
extern NSString * const kMyFirstConstant;
extern NSString * const kFeedItemCellIdentifier;
extern NSString * const kListModeCellIdentifier;
extern NSString * const kHighlightHeaderCellIdentifier;
extern NSString * const kHighlightFeedbackCellIdentifier;
extern NSString * const kHighlightCommentCellIdentifier;
extern NSString * const kListModeOne;
extern NSString * const kListModeTwo;

extern NSString * const kPlacesPlaceCellIdentifier;
extern NSString * const kPlaceHeaderCellIdentifier;
extern NSString * const kPlaceMoreInfoCellIdentifier;

// Segues
extern NSString * const kShowLoginViewControllerSegueIdentifier;
extern NSString * const kShowPlaceActionDetailsSegueIdentifier;
extern NSString * const kShowFeedItemDetailsSegueIdentifier;
extern NSString * const kShowDashViewDetailsSegueIdentifier;
extern NSString * const kPresentFilterViewController;
extern NSString * const kShowSearchResultDetailView;