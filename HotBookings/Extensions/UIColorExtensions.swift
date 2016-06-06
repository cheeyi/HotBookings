//
//  UIColorExtensions.swift
//  ExpediaBookings
//
//  Created by Barry Brown on 1/11/16.
//  Copyright © 2016 Mobiata. All rights reserved.
//

/*
 *  Design Document with Color information can be found at
 *  https://github.com/ExpediaInc/ewe-mobile-design-style-guide/wiki/iOS#colors
 */

import Foundation
import UIKit

extension UIColor {

    /// Jet Blue @ 85%
    class func jetBlueDarkColor() -> UIColor {
        return jetBlueColor(0.85)
    }

    /// Jet Blue @ 80%
    class func jetBlueDarkGrayColor() -> UIColor {
        return jetBlueColor(0.8)
    }

    /// Jet Blue @ 60%
    class func jetBlueGrayColor() -> UIColor {
        return jetBlueColor(0.6)
    }

    /// Jet Blue @ 50%
    class func jetBlueMediumGrayColor() -> UIColor {
        return jetBlueColor(0.5)
    }

    /// Jet Blue @ 40%
    class func jetBlueLightGrayColor() -> UIColor {
        return jetBlueColor(0.4)
    }

    /// Jet Blue @ 20%
    class func jetBlueMediumLightGrayColor() -> UIColor {
        return jetBlueColor(0.2)
    }

    /// Jet Blue @ 10%
    class func jetBlueVeryLightGrayColor() -> UIColor {
        return jetBlueColor(0.1)
    }

    /// Jet Blue @ 4%
    class func jetBlueLightestGrayColor() -> UIColor {
        return jetBlueColor(0.04)
    }

    /// Jet Blue @ 3%
    class func loadingAnimationStripeColor() -> UIColor {
        return UIColor.jetBlueColor(0.03)
    }

    /// First Class Blue
    class func firstClassBlueColor() -> UIColor {
        return UIColor(red: 8.0/255.0, green: 91.0/255.0, blue: 165.0/255.0, alpha: 1.0)
    }

    /// Greener Pastures
    class func greenerPasturesColor() -> UIColor {
        return UIColor(red: 25.0/255.0, green: 191.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }

    /// Mediterranean Blue
    class func packagesDarkBlueColor() -> UIColor {
        return UIColor(red: 10.0/255.0, green: 61.0/255.0, blue: 107.0/255.0, alpha: 1.0)
    }

    /// Red Eye
    class func redEyeColor() -> UIColor {
        return UIColor(hexString: "FF5747")
    }

    /// Tuscan Sun
    class func tuscanSunColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 216.0/255.0, blue: 60.0/255.0, alpha: 1.0)
    }

    /// Tuscan Sunset
    class func tuscanSunsetColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 196.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }

    ///Light color e.g. /night in price/night in rooms and rates screen
    class func packagesTableViewCellSubtitleAttributedLightTextColor() -> UIColor {
        return jetBlueMediumGrayColor()
    }

    class func packagesHotelCellNavyColor() -> UIColor {
        return UIColor(red: 42.0/255.0, green: 80.0/255.0, blue: 105.0/255.0, alpha: 1.0)
    }

    class func packagesStrikethroughPriceGreyColor() -> UIColor {
        return UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 1.0)
    }

    class func packagesAmenityGreyColor() -> UIColor {
        return UIColor(red: 195.0/255.0, green: 199.0/255.0, blue: 202.0/255.0, alpha: 1.0)
    }

    // MARK: Private helper function
    // H:002D4A
    private class func jetBlueColor(alpha: CGFloat) -> UIColor {
        return UIColor(red: 0.0/255.0, green: 45.0/255.0, blue: 74.0/255.0, alpha: alpha)
    }

    // H:4CA0FF
    private class func mileHighBlueColor(alpha: CGFloat) -> UIColor {
        return UIColor(red: 76.0/255.0, green: 160.0/255.0, blue: 255.0/255.0, alpha: alpha)
    }
}

// MARK: Windows colors
extension UIColor {

    class func windowTintColor() -> UIColor {
        return UIColor(red: 242.0/255.0, green: 213.0/255.0, blue: 97.0/255.0, alpha: 1.0)
    }
}

// MARK: Common colors
extension UIColor {

    class func jetBlueColor() -> UIColor {
        return jetBlueColor(1.0)
    }

    class func mileHighBlueColor() -> UIColor {
        return mileHighBlueColor(1.0)
    }

    class func mileHighBlueLightColor() -> UIColor {
        return mileHighBlueColor(0.4)
    }

    class func ebLightGrayColor() -> UIColor {
        return UIColor(red: 229.0/255.0, green: 234.0/255.0, blue: 236.0/255.0, alpha: 1.0)
    }

    class func grayBackgroundColor() -> UIColor {
        return jetBlueColor(0.06)
    }

    class func timelineColor() -> UIColor {
        return UIColor(red: 27.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
    }

    class func backgroundTranslucentColor() -> UIColor {
        return UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.25)
    }

    class func textFieldPlaceHolderTextColor() -> UIColor {
        return jetBlueMediumGrayColor()
    }
}

// MARK: Button colors
extension UIColor {

    // H:E8E8E8
    class func facebookButtonLabelTextColor() -> UIColor {
        return UIColor(red: 232.0/255.0, green: 232.0/255.0, blue: 232.0/255.0, alpha: 1.0)
    }

    // H: 4667A3
    class func facebookButtonColor() -> UIColor {
        return UIColor(red: 70.0/255.0, green: 103.0/255.0, blue: 163.0/255.0, alpha: 1.0)
    }
}

// MARK: Helpers
extension UIColor {

    /// code snippet borrowed from http://stackoverflow.com/a/33397427
    convenience init(hexString: String) {

        let hex = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var int = UInt32()

        NSScanner(string: hex).scanHexInt(&int)
        let a, r, g, b: UInt32

        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

// MARK: Rails colors
extension UIColor {

    class func railsSubtextColor() -> UIColor {
        return UIColor(red: 133.0/255.0, green: 150.0/255.0, blue: 161.0/255.0, alpha: 1.0)
    }
}

// MARK: Info View colors
extension UIColor {

    // H:4CA0FF
    class func infoViewTintColor() -> UIColor {
        return mileHighBlueColor()
    }

    // H:002D4A a:0.5
    class func infoViewCellDetailTextLabelTextColor() -> UIColor {
        return jetBlueMediumGrayColor()
    }

    // H:002D4A
    class func accountScreenLoggedInHeaderColor() -> UIColor {
        return jetBlueColor(1.0)
    }

    class func accountScreenLoggedOutHeaderColor() -> UIColor {
        return groupTableViewBackgroundColor()
    }

    class func infoViewNavigationBarTintColor() -> UIColor {
        return whiteColor()
    }
}

// MARK: Additional Functionality
extension UIColor {
    
    func isLightColor() -> Bool {
        var white = CGFloat(0)
        self.getWhite(&white, alpha: nil)
        return (white >= 0.5)
    }
    
}
