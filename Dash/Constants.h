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
    kHighlightLinesColor = 0x878787,
    kDashNavBarBGColor = 0x454545,
    kPlaceOrangeBGColor = 0xffedd6,
    kPlaceOrangeTextColor = 0xff9933,
    kHighlightTextColor = 0x434546,
    kHighlightAuthorColor = 0x7b7b7b,
    kHighlightLikesColor = 0x4d4d4d,
    kPlaceCategoriesTextColor = 0x434546,
    kPlaceTitlesTextColor = 0x434546,
    kPlaceToolbarTextColor = 0xcfcaca,
    kMoreInfoTextColor = 0x4d4d4d,
    kRecommendedPlaceTitleColor = 0x434546,
    kRecommendedPlaceSubtitleColor = 0x7b7b7b,
    kSearchTextFieldBGColor = 0xf5f5f5,
    kFeedBlurbColor = 0x434546,
    kFeedTimestampColor = 0x7b7b7b,
    kFeedLinesColor = 0xacacac,
    kProfileHeaderNameFontColor = 0x333333,
};

enum {
    kHighlightCharacterLimit = 64,
};

// Text
extern NSString * const kWelcomeText;
extern NSString * const kIntroText;
extern NSString * const kSignUpText;
extern NSString * const kMoreInfoAddress;
extern NSString * const kMoreInfoPhone;
extern NSString * const kMoreInfoHours;
extern NSString * const kLoginAlertTitle;
extern NSString * const kLoginAlertMessage;

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
extern NSString * const kPlaceMoreInfoOpenCellIdentifier;
extern NSString * const kPlaceMoreInfoCellIdentifier;
extern NSString * const kPlaceBadgesCellIdentifier;
extern NSString * const kPlaceHighlightCellIdentifier;
extern NSString * const kPlaceCreateHighlightCellIdentifier;
extern NSString * const kPlaceTitleCellIdentifier;
extern NSString * const kSearchAutocompleteCellIdentifier;
extern NSString * const kProfileHeaderCellIdentifier;

// Segues
extern NSString * const kShowLoginViewControllerSegueIdentifier;
extern NSString * const kShowPlaceActionDetailsSegueIdentifier;
extern NSString * const kShowFeedItemDetailsSegueIdentifier;
extern NSString * const kShowDashViewDetailsSegueIdentifier;
extern NSString * const kShowProfileViewDetailsIdentifier;
extern NSString * const kPresentFilterViewController;
extern NSString * const kShowSearchResultDetailView;
extern NSString * const kShowCreateHighlightSegueIdentifier;
extern NSString * const kShowMapViewControllerSegueIdentifier;


// Distance cutoff
static double const kDistanceCutoff = 50.0;
extern NSString * const kDistanceCutOffString;

// FB Connect
extern NSString *const kFBAppID;