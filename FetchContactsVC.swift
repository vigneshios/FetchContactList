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
        ContactsManager.shared.retreiveContactsWithStore(store: store) { (_) in
            self.contactsTableView.reloadData()
        }
    }

}


extension FetchContactsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactsManager.shared.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let contact = ContactsManager.shared.contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.phoneNum
        return cell
        
    }
}
