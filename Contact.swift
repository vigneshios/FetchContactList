//
//  Contact.swift
//  FetchContactList
//
//  Created by Vignesh on 03/04/19.
//  Copyright © 2019 Vignesh. All rights reserved.
//

import Foundation

struct Contact {
    var name: String
    var phoneNum: String
    
    init(name: String, phoneNum: String) {
        self.name = name
        self.phoneNum = phoneNum
    }
}
