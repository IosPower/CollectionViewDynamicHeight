//
//  FileManageHelper.swift
//  Hochiki
//
//  Created by Admin on 05/12/19.
//  Copyright © 2019 Piyush. All rights reserved.
//

import UIKit

/// It will be managing all file related stuffs
class FileManageHelper: NSObject {
    // MARK: - Documents Directory
    
    ///Document Directory
    class func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    /**
     check here if files available in document directory or not if available so get file path
     */
    class func isFileExistDocumentDirAndGetPath(fileName: String?) -> (Bool, URL?) {
        guard let fileNewName = fileName else {
            return (false, nil)
        }
        let documentsPath = FileManageHelper.documentsDirectory().appendingPathComponent(fileNewName)
        let fileExists = FileManager.default.fileExists(atPath: documentsPath.path)
        return (fileExists, documentsPath)
    }
    /**
     check here if files available in bundle directory or not if available so get file path
     */
    class func getVideoFromBundle(fileName: String, exten: String) -> URL? {
        guard let bundleFileUrl = Bundle.main.url(forResource: fileName, withExtension: exten) else {return nil}
        return  bundleFileUrl
    }
    /**
     check here if files available in document directory or not
     */
    class func isFileExistDocumentDir(fileName: String?) -> Bool {
        guard let fileNewName = fileName else {
            return false
        }
        let documentsPath = FileManageHelper.documentsDirectory().appendingPathComponent(fileNewName)
        let fileExists = FileManager.default.fileExists(atPath: documentsPath.path)
        return fileExists
    }
    /**
     get save file url
     */
    class func getSaveFileUrl(fileName: String) -> URL {
        let documentsURL = FileManageHelper.documentsDirectory()
        let nameUrl = URL(string: fileName)
        // Hemant Change
        let fileURL = documentsURL.appendingPathComponent((nameUrl?.lastPathComponent) ?? "")
        return fileURL
    }
    
    // MARK: - Create Folder To Document Directory
    /**
     create folder in document directory
     */
    class func createFolderInDocumentDir(folderName: String) -> URL? {
        let fileManager = FileManager.default
        let documentDirectory = FileManageHelper.documentsDirectory()
        let filePath = documentDirectory.appendingPathComponent(folderName)
        if !fileManager.fileExists(atPath: filePath.path) {
            do {
                try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        return filePath
    }
    
    // MARK: - All File List From Document Directory
    /**
     Get Particular extension Files From Document Directory
     */
    class func allFileListFromDocumentDir(whichExtension: String?) -> [URL]? {
        let fileManager = FileManager.default
        let documentDirectory = FileManageHelper.documentsDirectory()
        do {
            let fileUrls = try fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil, options: [])
            if let pathExtension = whichExtension {
                let specificFiles = fileUrls.filter { $0.pathExtension == pathExtension }
                return specificFiles
            } else {
                return fileUrls
            }
        } catch {
            print("Error while enumerating files \(documentDirectory.path): \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Remove From Document Directory
    /**
     Here Single file from document directory
     */
    class func removeSingleFileFromDocumentDir(fileName: String) {
        let documentDirectory = FileManageHelper.documentsDirectory()
        removeFileFromDocumentDirectory(documentDirectory: documentDirectory, path: fileName)
    }
    fileprivate class func removeFileFromDocumentDirectory(documentDirectory: URL, path: String) {
        let fileManager = FileManager.default
        let deletePath = documentDirectory.appendingPathComponent(path)
        do {
            try fileManager.removeItem(at: deletePath)
            print("removed file from document dir: \(deletePath.lastPathComponent) ")
        } catch {
            // Non-fatal: file probably doesn't exist
        }
    }
    
    /**
     Here remove all files from document directory
     */
    class func removeFromDocumentDirectory() {
        let documentDirectory = FileManageHelper.documentsDirectory()
        let fileManager = FileManager.default
        do {
            let fileUrls = try fileManager.contentsOfDirectory(atPath: documentDirectory.path)
            for path in fileUrls {
                removeFileFromDocumentDirectory(documentDirectory: documentDirectory, path: path)
            }
        } catch {
            print("Error while enumerating files \(documentDirectory.path): \(error.localizedDescription)")
        }
    }
    
    // MARK: - Temp Directory
    ///Temp Directory
    class func tempDirectory() -> URL {
        let tempDirectoryURL = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
        return tempDirectoryURL
    }
}
