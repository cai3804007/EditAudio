//
//  String+SeanAdd.swift
//  SwiftFrame
//
//  Created by yoyochecknow on 2020/9/10.
//  Copyright © 2020 SeanOrganization. All rights reserved.
//

import UIKit
extension String {
    
    func textSize(attributes : [NSAttributedString.Key : Any] , size : CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) -> CGSize {
        let labelSize = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
        return labelSize
    }
    
    // JSONString转换为字典
    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    func getArrayFromJSONString(jsonString:String) ->NSArray{
        let jsonData:Data = jsonString.data(using: .utf8)!
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if array != nil {
            return array as! NSArray
        }
        return array as! NSArray
        
    }
    /**
     字典转换为JSONString
     - parameter dictionary: 字典参数
     - returns: JSONString
     */
    func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try! JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData?
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    //数组转json
    func getJSONStringFromArray(array:NSArray) -> String {
        
        if (!JSONSerialization.isValidJSONObject(array)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try! JSONSerialization.data(withJSONObject: array, options: []) as NSData?
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    

    
    //MARK:- 字符串转时间戳
    func timeStrChangeTotimeInterval(_ dateFormat:String? = "yyyy-MM-dd HH:mm:ss") -> String {
        if self.isEmpty {
            return ""
        }
        let format = DateFormatter.init()
        format.dateStyle = .medium
        format.timeStyle = .short
        if dateFormat == nil {
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            format.dateFormat = dateFormat
        }
        let date = format.date(from: self)
        return String(date!.timeIntervalSince1970)
    }
    
    /// 获取当前 秒级 时间戳 - 10位
    static  var timeStamp : String {
        let date = Date.init()
        let timeInterval: TimeInterval = date.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    
    /// 获取当前 毫秒级 时间戳 - 13位
    static  var milliStamp : String {
        let date = Date.init()
        let timeInterval: TimeInterval = date.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    
    /// 生成随机字符串
      ///
      /// - Parameters:
      ///   - count: 生成字符串长度
      ///   - isLetter: false=大小写字母和数字组成，true=大小写字母组成，默认为false
      /// - Returns: String
      static func random(_ count: Int, _ isLetter: Bool = false) -> String {
          
          var ch: [CChar] = Array(repeating: 0, count: count)
          for index in 0..<count {
              
              var num = isLetter ? arc4random_uniform(58)+65:arc4random_uniform(75)+48
              if num>57 && num<65 && isLetter==false { num = num%57+48 }
              else if num>90 && num<97 { num = num%90+65 }
              
              ch[index] = CChar(num)
          }
          
          return String(cString: ch)
      }
    
    
}

extension NSMutableAttributedString{
    func add(_ string: String?,_ att: [NSAttributedString.Key : Any] = [:]) {
        let priceString = NSMutableAttributedString(string: string ?? "", attributes:att)
        self.append(priceString)
    }
    
    func addAttString(_ str: String?, font: CGFloat, color: UIColor?) {
        var string: NSMutableAttributedString? = nil
        if let color = color {
            string = NSMutableAttributedString(string: str ?? "", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: font),
                NSAttributedString.Key.foregroundColor: color
            ])
        }
        if let string = string {
            append(string)
        }
    }
    
    func addImage(_ image: UIImage?, bounds: CGRect) {
        if let image = image {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = image
            imageAttachment.bounds = bounds
            let imgAttr = NSAttributedString(attachment: imageAttachment)
            self.append(imgAttr)
        }
    }
    
    
    class func initString(with str: String?, font: CGFloat, color: UIColor?) -> NSMutableAttributedString? {

        var string: NSMutableAttributedString? = nil
        if let color = color {
            string = NSMutableAttributedString(string: str ?? "", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: font),
                NSAttributedString.Key.foregroundColor: color
            ])
        }
        return string
    }
     
    func addCenterLine() {
        self.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber.init(value: 1), range: NSRange(location: 0, length: self.length))
    }
    
    func addBottomLine() {
        self.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber.init(value: 1), range: NSRange(location: 0, length: self.length))
    }
    
    
}




extension Double{
      //时间戳转成字符串
      func timeIntervalChangeToTimeStr(dateFormat:String? = "yyyy-MM-dd HH:mm:ss") -> String {
          var time = self
          if time > 10000000000.0 {
              time = time/1000.0;
          }
          let date:NSDate = NSDate.init(timeIntervalSince1970: time)
          let formatter = DateFormatter.init()
          if dateFormat == nil {
              formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          }else{
              formatter.dateFormat = dateFormat
          }
          let string = formatter.string(from: date as Date)
          return string
      }
}



