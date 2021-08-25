//
//  ListViewController.swift
//  TelContact
//
//  Created by Molder on 2021/8/12.
//

import UIKit
import Contacts

class ListViewController: UIViewController {

    // 通訊錄Array
    var telArray = [TelModel]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
        
        contactAuthorizationStatus()
    }
    
    /// 查看通訊錄授權狀態
    private func contactAuthorizationStatus() {
        // 取得授權狀態
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        switch status {
        case .authorized: // 已同意授權過，開始讀取通訊錄清單
            getContactList {
                print("通訊錄清單讀取完成")
                // 更新 tableView
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } failHandle: {
                print("通訊錄清單讀取失敗")
            }
        case .denied: // 如果用戶拒絕，導引用戶到手機的設定 -> Demo APP 裡
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            DispatchQueue.main.async {
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)")
                    })
                }
            }
        case .notDetermined: // 從未詢問過通訊錄權限
            let contactStore = CNContactStore()
            // 詢問通訊錄權限
            contactStore.requestAccess(for: .contacts) { (result, err) in
                if result { // 用户同意授權，開始讀取通訊錄清單
                    self.getContactList {
                        print("通訊錄清單讀取完成")
                        // 更新 tableView
                        DispatchQueue.main.async(execute: {
                            self.tableView.reloadData()
                        })
                    } failHandle: {
                        print("通訊錄清單讀取失敗")
                    }
                } else {
                    print("用户未同意授權")
                }
            }
        default:
            print("其他錯誤")
        }
    }
    
    /// 取得通訊錄清單
    private func getContactList(successHandle: @escaping () -> (),
                                failHandle: @escaping () -> () ) {
        // 建立通訊錄管理物件
        let store = CNContactStore()
        // 設定想要取得通訊錄資訊的key
        let key = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactNicknameKey,CNContactEmailAddressesKey, CNContactIdentifierKey,CNContactPostalAddressesKey]
        // 建立請求物件
        let request = CNContactFetchRequest(keysToFetch: key as [CNKeyDescriptor])
        do {
            // 發出請求
            try store.enumerateContacts(with: request, usingBlock: { (contact: CNContact, stop: UnsafeMutablePointer<ObjCBool>) in
                // 建立自訂義通訊錄模組
                let telModel:TelModel = TelModel()
                
                // id
                telModel.id = contact.identifier
                
                // 姓名
                let lastName = contact.familyName
                let firstName = contact.givenName
                telModel.name = "\(lastName)\(firstName)"

                // 暱稱
                telModel.nikeName = contact.nickname
                
                // 電話
                var phoneList = [Phone]()
                let phoneNumbers = contact.phoneNumbers
                for phoneNumber in phoneNumbers {
                    guard let phoneLabel = phoneNumber.label else { return }
                    // 取得 phone 的標籤，例如：行動電話、市話等等
                    let label = CNLabeledValue<NSString>.localizedString(forLabel: phoneLabel)
                    print("標籤:\(label), 電話：\(phoneNumber.value.stringValue)")
                    let tmpPhone = Phone(tagLabel: label, number: phoneNumber.value.stringValue)
                    phoneList.append(tmpPhone)
                }
                telModel.phones = phoneList
                
                // 地址
                var addressList = [Address]()
                for address in contact.postalAddresses {
                    guard let addressLabel = address.label else { return }
                    // 取得 address 的標籤，例如：住家、公司等等
                    let label = CNLabeledValue<NSString>.localizedString(forLabel: addressLabel)
                    let detail = address.value
                    let contry = detail.value(forKey: CNPostalAddressCountryKey) as? String ?? ""
                    let state = detail.value(forKey: CNPostalAddressStateKey) as? String ?? ""
                    let city = detail.value(forKey: CNPostalAddressCityKey) as? String ?? ""
                    let street = detail.value(forKey: CNPostalAddressStreetKey) as? String ?? ""
                    let code = detail.value(forKey: CNPostalAddressPostalCodeKey) as? String ?? ""
                    let str = "國家:\(contry) 省:\(state) 城市:\(city) 街道:\(street) 郵遞區號:\(code)"
                    print("標籤:\(label), 地址：\(str)")
                    
                    let tmpAddress = Address(tagLabel: label, contry: contry, state: state, city: city, street: street, code: code, address: str)
                    addressList.append(tmpAddress)
                    
                }
                telModel.address = addressList
                
                // email
                var emailList = [Email]()
                for email in contact.emailAddresses {
                    guard let emailLabel = email.label else { return }
                    // 取得 email 的標籤，例如：住家、公司等等
                    let label = CNLabeledValue<NSString>.localizedString(forLabel: emailLabel)
                    let value = String(email.value)
                    print("標籤:\(label), email：\(value)")
                    let tmpEmail = Email(tagLabel: label, email: value)
                    emailList.append(tmpEmail)
                }
                telModel.emails = emailList
                
                self.telArray.append(telModel)
            })
            successHandle()
        } catch {
            print("讀取通訊錄錯誤")
            failHandle()
        }
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return telArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell") as? ListTableViewCell ?? ListTableViewCell()
        var tel = TelModel()
        if telArray.count > indexPath.row { tel = telArray[indexPath.row] }
        cell.name.text = tel.name ?? ""
        cell.phone.text = tel.phones?.first?.number ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var tel = TelModel()
        if telArray.count > indexPath.row { tel = telArray[indexPath.row] }
        guard let vcs = self.navigationController?.viewControllers else { return }
        for vc in vcs {
            if vc is TelController {
                guard let telVC = vc as? TelController else { return }
                telVC.showNumber.text = tel.phones?.first?.number ?? ""
                DispatchQueue.main.async {
                    self.navigationController?.popToViewController(telVC, animated: true)
                }
            }
        }
    }
    
}
