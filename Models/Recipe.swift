//
//  Recipe.swift
//  RecipeStocker
//
//  Created by ice_soi on 2020/01/04.
//  Copyright © 2020 ice_soi. All rights reserved.
//

import UIKit
import RealmSwift

class Recipe: Object ,Identifiable{
    
    @objc dynamic var id: String = NSUUID().uuidString       // ID
    @objc dynamic var name: String = ""                      // レシピ名
    //@objc dynamic var image: NSData? = nil                   // 画像
    dynamic private var _image: UIImage? = nil
    dynamic var image: UIImage? {
        set{
            self._image = newValue
            if let value = newValue {
                self.imageData = value.pngData() as NSData?
            }
        }
        get{
            if let image = self._image {
                return image
            }
            if let data = self.imageData {
                self._image = UIImage(data: data as Data)
                return self._image
            }
            return nil
        }
    }
    @objc dynamic private var imageData: NSData? = nil
    @objc dynamic var url:String = ""                        // URL
    @objc dynamic var tag: String = ""                       // タグ
    @objc dynamic var remark: String = ""                    // 備考
    @objc dynamic var delflg: Bool = false                   // 削除フラグ

    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["image", "_image"]
    }

}
