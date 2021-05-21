//
//  RecorderFileHandler.swift
//  EditAudio
//
//  Created by yoyochecknow on 2021/5/20.
//

import Foundation
class RecorderFileHandler {
    
    let fileManager: FileManager = .default
    
    func fileUrl(fileName: String) -> URL? {
        fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first?.appendingPathComponent(fileName)
    }
    
    func removeFile(fileName: String) {
        do {
            guard
                let url = fileUrl(fileName: fileName),
                fileManager.fileExists(atPath: url.path)
            else {
                return
            }
            try FileManager.default.removeItem(at: url)
            print("文件删除成功")
        } catch {
            print("文件的删除失败了。", error)
        }
    }
    
    func copy(atUrl: URL, toUrl: URL) {
        do {
            // 复制文件失败了。
            try FileManager.default.copyItem(at: atUrl, to: toUrl)
        } catch {
            print("复制文件失败了。", error)
        }
    }
}
