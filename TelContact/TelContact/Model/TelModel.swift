//
//  TelModel.swift
//  TelContact
//
//  Created by Molder on 2021/8/12.
//

import Foundation

class TelModel: NSObject {
    // id
    var id: String?
    // 姓名
    var name: String?
    // 暱稱
    var nikeName: String?
    // 電話
    var phones: [Phone]?
    // 地址
    var address: [Address]?
    // email
    var emails: [Email]?
    // 生日
    var birthdays: [Birthday]?
    // 紀念日
    var anniversarys: [Anniversary]?
    // url超連結
    var urls: [UrlLink]?
    // 即時通訊IM
    var ims: [IMS]?
    // 連結的聯絡人
    var relations: [Relations]?
    // 備註
    var note: String?
    // 公司名稱
    var organizationName: String?
    // 職位
    var jobTitle: String?
    // 部門名稱
    var departmentName: String?
    
}

class Phone: NSObject {
    // 標籤
    var tagLabel: String?
    // 電話
    var number: String?
    
    init(tagLabel: String, number: String) {
        self.tagLabel = tagLabel
        self.number = number
    }
}

class Address: NSObject {
    // 標籤
    var tagLabel: String?
    // 國家
    var contry: String?
    // 省
    var state: String?
    // 城市
    var city: String?
    // 街道
    var street: String?
    // 郵遞區號
    var code: String?
    // 全部
    var address: String?
    
    init(tagLabel: String, contry: String, state: String, city: String, street: String, code: String, address: String) {
        self.tagLabel = tagLabel
        self.contry = contry
        self.state = state
        self.city = city
        self.street = street
        self.code = code
        self.address = address
    }
}

class Email: NSObject {
    // 標籤
    var tagLabel: String?
    // 電子郵件
    var email: String?
    
    init(tagLabel: String, email: String) {
        self.tagLabel = tagLabel
        self.email = email
    }
}

class Birthday: NSObject {
    // 標籤
    var tagLabel: String?
    // 生日
    var birthday: String?
    
    init(tagLabel: String, birthday: String) {
        self.tagLabel = tagLabel
        self.birthday = birthday
    }
}

class Anniversary: NSObject {
    // 標籤
    var tagLabel: String?
    // 紀念日
    var anniversary: String?
    
    init(tagLabel: String, anniversary: String) {
        self.tagLabel = tagLabel
        self.anniversary = anniversary
    }
}

class UrlLink: NSObject {
    // 標籤
    var tagLabel: String?
    // 超連結
    var url: String?
    
    init(tagLabel: String, url: String) {
        self.tagLabel = tagLabel
        self.url = url
    }
}

class IMS: NSObject {
    // 標籤
    var tagLabel: String?
    // 超連結
    var url: String?
    
    init(tagLabel: String, url: String) {
        self.tagLabel = tagLabel
        self.url = url
    }
}

class Relations: NSObject {
    // 標籤
    var tagLabel: String?
    // 連結聯絡人
    var relation: String?
    
    init(tagLabel: String, relation: String) {
        self.tagLabel = tagLabel
        self.relation = relation
    }
}
