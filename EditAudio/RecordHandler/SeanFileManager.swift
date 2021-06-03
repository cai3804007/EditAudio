//
//  SeanFileManager.swift
//  EditAudio
//
//  Created by yoyochecknow on 2021/5/20.
//

import Foundation

fileprivate let homeDir = NSHomeDirectory()
fileprivate let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
fileprivate let cachetDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
fileprivate let temp = NSTemporaryDirectory()

class SeanFileManager {
    enum FileType {
        case home
        case document
        case temp
        case cache
        case audio
        case editAudio
        case syntheticAudio
    }
    
    let fileManager: FileManager = .default
    
    static func urlSting(type:FileType) -> String{
        switch type {
        case .home:
            return homeDir
        case .document:
            return documentDir
        case .cache:
            return cachetDir
        case .temp:
            return temp
        case .audio:
            let path = cachetDir + "/audio"
            if !fileExists(atPath: path) {
                createDirectory(atPath: path)
            }
            return path
        case .editAudio:
            let path = cachetDir + "/editAudio"
            if !fileExists(atPath: path) {
                createDirectory(atPath: path)
            }
            return path
        case .syntheticAudio:
            let path = cachetDir + "/syntheticAudio"
            if !fileExists(atPath: path) {
                createDirectory(atPath: path)
            }
            return path
        }
    }
    
    static func fileExists(atPath path: String) -> Bool{
        return FileManager.default.fileExists(atPath: path)
    }
    
    static func createDirectory(atPath: String) {
        if fileExists(atPath: atPath) {
            return
        }
        do {
            try FileManager.default.createDirectory(atPath: atPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("文件夹创建失败: %@", atPath)
        }
    }

    
    static func fileUrl(fileName: String,_ type:FileType = .audio) -> URL? {
//        let path = SeanFileManager.urlSting(type: type)
        
        let url = URL(fileURLWithPath:SeanFileManager.urlSting(type: type))// + "/\(fileName)")
        let name = url.appendingPathComponent(fileName)
        return name
    }
    
    static func removeFile(fileName: String ,_ type:FileType = .audio) {
        do {
            guard
                let url = fileUrl(fileName: fileName),
                SeanFileManager.fileExists(atPath: url.path)
            else {
                print("文件不存在")
                return
            }
            try FileManager.default.removeItem(at: url)
            print("文件删除成功")
        } catch {
            print("文件的删除失败了。", error)
        }
    }
    
    static func copy(atUrl: URL, toUrl: URL) {
        do {
            // 复制文件失败了。
            try FileManager.default.copyItem(at: atUrl, to: toUrl)
            print("复制文件成功了。")
        } catch {
            print("复制文件失败了。", error)
        }
    }
    
    
    // 移动文件到目标位置
    static  func movingFile(atUrl:String, toUrl:String){
        let fileManager = FileManager.default
        let toUrl = toUrl
        print("targetUrl = \(toUrl)")
        do{
            try fileManager.moveItem(atPath: atUrl, toPath: toUrl)
            print("Succsee to move file.")
        }catch{
            print("Failed to move file.")
        }
    }
    
    
    static func audioName() -> String{
        
        return (String.random(5) + ".m4a")
    }
    
    static func editAudioName() -> String{
        return (String.random(5) + ".m4a")
    }
    
    static func getAudios() -> Array<String>?{
        
        let audios = FileManager.default.subpaths(atPath: urlSting(type: .audio))
        
        return audios
    }
    
    
    static func getTempAudioWithAudiokit() -> String?{
        
        let audios = FileManager.default.subpaths(atPath: urlSting(type: .temp))
        
        return audios?.first
    }
    
    
    
    static func getBundlePath(name:String,type:String) -> String{
      guard  let bundle = Bundle.main.path(forResource: name, ofType: type)
      else {return ""}
      return bundle
    }
    
}
