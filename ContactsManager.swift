//
//  ContactsManager.swift
//  FetchContactList
//
//  Created by Vignesh on 03/04/19.
//  Copyright © 2019 Vignesh. All rights reserved.
//

import Foundation
import ContactsUI

typealias completionHandler = (_ success: Bool) -> ()

class ContactsManager {
    
    static let shared = ContactsManager()
    
    // Constants
    var contacts = [Contact]()
    
    // Variables
    var storedArray = [CNContact]()
    
    
    func retreiveContactsWithStore(store: CNContactStore, completion: @escaping completionHandler) {
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),CNContactPhoneNumbersKey,CNContactImageDataKey,CNContactEmailAddressesKey] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        var cnContacts = [CNContact]()
        do {
            try store.enumerateContacts(with: request){
                (contact, cursor) -> Void in
                cnContacts.append(contact)
                self.storedArray = cnContacts
            }
        } catch let error {
            print("Fetch contact error: \(error)")
        }
        
        for contact in cnContacts {
            let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
            for phoneNum in contact.phoneNumbers {
                if let num = phoneNum.value as? CNPhoneNumber,
                    let label = phoneNum.label {
                    let localisedLbl = CNLabeledValue<NSCopying & NSSecureCoding>.localizedString(forLabel: label)
                    
                    if ("\(localisedLbl)" == "home") {
                        contacts.append(Contact(name: fullName, phoneNum: num.stringValue))
                    }
                }
            }
            
            completion(true)
        }
    }
    
}
