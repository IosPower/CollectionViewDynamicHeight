//
//  Messages.swift
//  CollectionViewDynamicHeight
//
//  Created by Admin on 16/11/19.
//  Copyright © 2019 Piyush. All rights reserved.
//

import Foundation

/// All the messages to be displayed in the app.
class Messages: NSObject {
    
    ///
    static let strReqTimeOut = "The request timed out, Please try again."
    ///
    static let internetAlertMsg = "Please check your internet connection."
    ///
    static let tryAgain: String = "Please try again."
    ///
    static let somethingWrong = "Something went wrong."
    
    // MARK: - Button title strings
    ///
    struct Button {
        ///
        static let okButton = "OK"
        ///
        static let cancelButton = "Cancel"
        ///
        static let yesButton = "Yes"
        ///
        static let noButton = "No"
    }
    
    // MARK: - Login Screen Messages
    ///
    struct LoginScreen {
        ///
        static let strEmailAndPassValidMsg = "You must enter a valid email address and password."
        ///
        static let strEmailIdMsg = "Please enter an email address."
        ///
        static let strValidEmailIdMsg = "Please enter a valid email address."
        ///
        static let strpasswordMsg = "Please enter password."
        ///
        static let strValidpasswordMsg = "password must be at least 8 characters long."
    }
}
