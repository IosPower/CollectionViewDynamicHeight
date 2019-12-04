//
//  ApiManager.swift
//  CollectionViewDynamicHeight
//
//  Created by Admin on 16/11/19.
//  Copyright © 2019 Piyush. All rights reserved.
//

import UIKit
import Reachability
import Alamofire

/// ApiManager for call webservice class
class ApiManager: NSObject {
    //
    static var isInternetAvailable: Bool = true
    ///
    fileprivate var reachability: Reachability?
    ///
    static let sharedManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = ApiConfiguration.timeoutIntervalForResource
        configuration.timeoutIntervalForResource = ApiConfiguration.timeoutIntervalForResource
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    ///
    class var sharedInstance: ApiManager {
        struct Static {
            static var instance: ApiManager?
            static var token: Int = 0
        }
        if Static.instance == nil {
            Static.instance = ApiManager()
        }
        return Static.instance ?? ApiManager()
    }
    ///
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
        do {
            reachability = try Reachability.init()
            try reachability?.startNotifier()
        } catch {
        }
    }
    
    // MARK: - Request Method
    func requestFor(urlPath: String, param: [String: Any]?, httpMethod: HTTPMethod, includeHeader: Bool, success:@escaping (_ response: [[String: Any]]) -> Void, failure:@escaping (_ response: [String: Any], _ error: Error?) -> Void) {
        
        let completeURL = ApiConfiguration.sharedInstance.serverURL + urlPath
       // let completeURL = urlPath

        var headerParam: HTTPHeaders?
        if includeHeader {
            let strToken = Constant.storeService.strToken ?? ""
            headerParam = [ModelKeys.ApiHeaderKeys.contentType: ModelKeys.ApiHeaderKeys.applicationOrJson,
                           ModelKeys.ApiHeaderKeys.token: strToken]
            //
            //headerParam = ["Content-Type": "application/x-www-form-urlencoded"]
        }
        
        ApiManager.sharedManager.request(completeURL, method: httpMethod, parameters: param, encoding: JSONEncoding.default, headers: headerParam).validate().responseJSON { response in
            //debug//print(response)
            switch response.result {
            case .success:
                // here response may be in dic or in array
                if let responseDict = response.value as? [[String: Any]] {
                    if let accessToken = response.response?.allHeaderFields["x-access-token"] as? String {
                        print("accessToken", accessToken)
                        Constant.storeService.strToken = accessToken
                    }
                    success(responseDict)
                } else {
                    failure([ModelKeys.ResponseKeys.message: Messages.somethingWrong], response.error)
                }
            case .failure (let error):
                if let responseDict = response.value as? [String: Any] {
                    //print("Response Error In WebServie:  ", error)
                    failure(responseDict, response.error)
                } else {
                    print(error.localizedDescription)
                    print(error._code)
                    self.getFailResponse(encodingError: error, failure: { (reponseDic) in
                        failure(reponseDic, error)
                    })
                }
            }
        }
    }
    
    /*
    
    /// Custom Multipart API Calling methods. We can call any rest API With this common API calling method.
    ///
    /// - Parameters:
    ///   - path: API path
    ///   - ver: firmware version
    ///   - httpMethod: http Method.
    ///   - queue: queue object.
    ///   - success: success block.
    ///   - failure: failure block.
    func uploadRequest(parameter: Parameters?, images: [UIImage]?, imageKeysArray: [String], serverUrl: String, httpMethod: HTTPMethod, queue: DispatchQueue? = nil, isLoder: Bool = true, success:@escaping(_ response: [String: Any]) -> Void, failure:@escaping( _ error: Error?) -> Void) {
        
        let completeURL = ApiConfiguration.sharedInstance.serverURL + serverUrl
        
        // Set header
        let strToken = Constant.storeService.strToken ?? ""
        let headerParam = [ModelKeys.ApiHeaderKeys.contentType: ModelKeys.ApiHeaderKeys.multipartOrFormData,
                           ModelKeys.ApiHeaderKeys.token: strToken]
        
        ApiManager.sharedManager.upload(multipartFormData: { (multipartFormData) in
            if let images = images, imageKeysArray.count == images.count {
                for (index, image) in images.enumerated() {
                    let imageKey = imageKeysArray[index]
                    guard let data = image.jpegData(compressionQuality: 1.0) else {
                        continue
                    }
                    let imageName = CommonMethods.randomString(length: 10)
                    multipartFormData.append(data, withName: imageKey, fileName: imageName + ".jpg", mimeType: ModelKeys.MimeType.jpg)
                }
            }
            
            for (key, value) in (parameter ?? [:]) {
                guard let data = "\(value)".data(using: String.Encoding.utf8) else { continue }
                multipartFormData.append(data, withName: key as String)
            }
            
        }, usingThreshold: UInt64.init(), to: completeURL, method: .post, headers: headerParam, encodingCompletion: { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    print(response)
                    if let responseDict = response.result.value as? [String: Any] {
                        success(responseDict)
                    } else {
                        failure(response.result.error)
                    }
                }
            case .failure(let error):
                if isLoder {
                    Constant.window?.hideHud()
                }
                failure(error)
            }
        })
    }
    */
    
    // MARK: - Fail Response
    /// getFailResponse
    ///
    /// - Parameters:
    ///   - encodingError: encodingError
    ///   - failure: failure
    func getFailResponse(encodingError: Error, failure:@escaping (_ response: [String: Any]) -> Void) {
        print(encodingError._code)
        if encodingError._code == NSURLErrorTimedOut {
            failure([ModelKeys.ResponseKeys.message: Messages.strReqTimeOut])
        } else if encodingError._code == NSURLErrorNotConnectedToInternet {
            failure([ModelKeys.ResponseKeys.message: Messages.internetAlertMsg])
        } else if encodingError._code == 404 {
            failure([ModelKeys.ResponseKeys.message: Messages.internetAlertMsg])
        } else {
            failure([ModelKeys.ResponseKeys.message: encodingError.localizedDescription])
        }
    }
}
// MARK: - Rechability
extension ApiManager {
    /// reachabilityChanged
    @objc func reachabilityChanged(_ notification: Notification) {
        if let reachability = notification.object as? Reachability {
            switch reachability.connection {
            case .wifi, .cellular:
                ApiManager.isInternetAvailable = true
                print("Reachable via WiFi or Cellular")
            case .none:
                ApiManager.isInternetAvailable = false
                print("Network not reachable")
            case .unavailable:
                ApiManager.isInternetAvailable = false
            }
        } else {
            ApiManager.isInternetAvailable = false
            //print("Network not reachable")
        }
        print("ApiManager.isInternetAvailable", ApiManager.isInternetAvailable)
    }
}
