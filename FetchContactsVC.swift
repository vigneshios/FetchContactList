//
//  FetchContactsVC.swift
//  FetchContactList
//
//  Created by Vignesh on 03/04/19.
//  Copyright © 2019 Vignesh. All rights reserved.
//

import UIKit
import ContactsUI

class FetchContactsVC: UIViewController {

    // Outlets
    @IBOutlet weak var contactsTableView: UITableView!
    
    // Constants
    var contacts = [Contact]()
    
    // Variables
    var storedArray = [CNContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getContacts()

       
    }
    
    func getContacts() {
        let store = CNContactStore()
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            retreiveContactsWithStore(store: store)
        case .notDetermined:
            store.requestAccess(for: .contacts) { (success, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }else {
                    self.retreiveContactsWithStore(store: store)
                }
            }
            
        default:
                print("Chk cases.. not properly handled..")
        }
    }
    
    
    func retreiveContactsWithStore(store: CNContactStore) {
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
        }
        DispatchQueue.main.async {
            self.contactsTableView.reloadData()
        }
    }

}


extension FetchContactsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let contact = contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.phoneNum
        return cell
        
    }
}
