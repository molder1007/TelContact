//
//  TelController.swift
//  TelContact
//
//  Created by Molder on 2021/8/12.
//

import UIKit
import ContactsUI

class TelController: UIViewController, CNContactPickerDelegate {

    @IBOutlet weak var showNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func telAction(_ sender: Any) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        contactPicker.modalPresentationStyle = .fullScreen
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    // detail頁
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {

        let contact = contactProperty.contact
        let identifier = contactProperty.identifier
        let name = CNContactFormatter.string(from: contact, style: .fullName)
        print("name: \(name ?? "")")
        for number in contact.phoneNumbers {
            if number.identifier == identifier {
                guard let mobile = number.value.value(forKey: "digits") as? String else { return }
                print("phone:\(mobile)")
                if mobile.count >= 10 && mobile.count < 14 {
                    self.showNumber.text = mobile
                }
            }
        }
    }
    
    // list 頁
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
//        picker.dismiss(animated: true, completion: nil)
//        let name = CNContactFormatter.string(from: contact, style: .fullName)
//        print("name: \(name ?? "")")
//        for number in contact.phoneNumbers {
//            let mobile = number.value.value(forKey: "digits") as? String
//            print("phone:\(mobile ?? "")")
//            if (mobile?.count)! > 7 {
//                // your code goes here
//                self.showNumber.text = mobile ?? ""
//            }
//        }
//    }
}
