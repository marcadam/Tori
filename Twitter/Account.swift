//
//  Account.swift
//  Twitter
//
//  Created by Marc Anderson on 2/28/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import Foundation

class Account {
    static var accounts = [Account]()

    var accessToken: String?
    var user: User?

    init(accessToken: String, user: User) {
        self.accessToken = accessToken
        self.user = user
    }

    class func addAccount(_ accessToken: String, user: User) {
        Account.accounts.append(Account(accessToken: accessToken, user: user))
    }
}
