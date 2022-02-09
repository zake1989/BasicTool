//
//  AuthorizeUtils.swift
//  Vskit
//
//  Created by Stephen zake on 2019/1/23.
//  Copyright © 2019 Transsnet. All rights reserved.
//

import Foundation
import Photos
import AVKit

extension PHAuthorizationStatus{
    var isAvaliable: Bool{
        switch self {
        case .notDetermined,.restricted,.denied:
            return false
        case .authorized,.limited:
            return true
        @unknown default:
            return false
        }
    }
    
    var isLimited: Bool{
        if #available(iOS 14, *){
            return self == .limited
        }
        return false
    }
}

// MARK: video audio etc.
class AuthorizeUtils {
    class func captureMediaStatus(mediaType: AVMediaType) -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: mediaType)
    }
    
    class func checkCaptureDeviceForMediaType(mediaType: AVMediaType) -> Bool {
        switch captureMediaStatus(mediaType: mediaType) {
        case .authorized:
            return true
        default:
            return false
        }
    }
    
    class func authorizeCaptureDeviceForMediaType(_ mediaType: AVMediaType, completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            if AVCaptureDevice.default(for: mediaType) != nil {
                AVCaptureDevice.requestAccess(for: mediaType, completionHandler: { (granted) in
                    completion(granted)
                })
            } else {
                completion(false)
            }
        @unknown default:
            break
        }
    }
}

// MARK: Notification
extension AuthorizeUtils {
    class func NotificationEnableAuthorization(){
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (result, error) in
                
            }
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }

    
    /// 检查推送授权状态
    ///
    /// - Parameter from: TabBarController 呈现时判断
    class func NotificationTipsAuthorization(){
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { (settings) in
                //权限是否开启上报
            }
            
        } else {
            return
        }
    }
    
    class func currentNotificationStatus() -> Bool {
        let center = UNUserNotificationCenter.current()
        let semasphore = DispatchSemaphore(value: 0)
        var authorized: Bool = false
        center.getNotificationSettings { (settings) in
            authorized = settings.authorizationStatus == .authorized
            semasphore.signal()
        }
        semasphore.wait()
        return authorized
    }
}

// MARK: Photo Album
extension AuthorizeUtils {
    class func checkPhotoLibraryAccess() -> Bool {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            return true
        default:
            return false
        }
    }
    
    class func photoAddStatus() -> PHAuthorizationStatus{
        if #available(iOS 14, *){
            return PHPhotoLibrary.authorizationStatus(for: .addOnly)
        }else{
            return PHPhotoLibrary.authorizationStatus()
        }
    }
    
    class func photoStatus() -> PHAuthorizationStatus{
        if #available(iOS 14, *){
            return PHPhotoLibrary.authorizationStatus(for: .readWrite)
        }else{
            return PHPhotoLibrary.authorizationStatus()
        }
    }
    
    class func authorizePhotoLibrary(_ completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
//        PHPhotoLibrary.authorizationStatus(for: .addOnly)
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        case .limited:
            break
        @unknown default:
            break
        }
    }
    
    class func photoLibrary(_ addOnly: Bool = false,completion: @escaping (PHAuthorizationStatus) -> Void){
        let status = addOnly ? photoAddStatus() : photoStatus()
        
        switch status {
        case .notDetermined:
            let resultCB: (PHAuthorizationStatus) -> Void = { reqStatus in
                if reqStatus.isAvaliable {

                }
                completion(reqStatus)
            }
            
            if #available(iOS 14, *){
                let level: PHAccessLevel = addOnly ? .addOnly : .readWrite
                PHPhotoLibrary.requestAuthorization(for: level) { (reqStatus) in
                    resultCB(reqStatus)
                }
            }else{
                PHPhotoLibrary.requestAuthorization { (reqStatus) in
                    resultCB(reqStatus)
                }
            }
        case .restricted, .denied,.authorized,.limited:
            completion(status)
        @unknown default:
            break
        }
    }
}

// MARK: 请求相机/相册权限被denied之后，每次弹出普通提示框
extension AuthorizeUtils {
    
    enum PermissionType {
        case photoLibrary
        case saveMediaToPhoto
        case camera
        case audio
        
        var msg:(title: String, message: String) {
            switch self {
            case .photoLibrary:
                return ("Allow Access to Photos",
                        "Please go to \"Settings\">\"\" and allow access to Photos to select photo.")
            case .saveMediaToPhoto:
                return ("Allow Access to Photos",
                        "Please go to \"Settings\">\"\" and allow access to Photos to download.")
            case .camera:
                return ("Allow Access to Photos",
                        "Please go to \"Settings\">\"\" and allow access to Camera to take photo.")
            case .audio:
                return ("Allow Access to Microphone",
                        "Use to turn on the microphone when recording videos.")
            }
        }
    }
    
    static func popoutPhotoPermissionAlertIfDenied(permissionType: PermissionType, in viewController: UIViewController, cancelClosure: (() -> ())? = nil) {
        
        let titleString: String = permissionType.msg.title
        let messageString: String = permissionType.msg.message
        
        let alertController = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Not now", style: .default, handler: { _ in
            if let cancelClosure = cancelClosure {
                cancelClosure()
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.open(settingsURL)
                }
            }
        }))
        
        if Thread.current.isMainThread {
            viewController.present(alertController, animated: true, completion: nil)
        } else {
            DispatchQueue.main.async {
                viewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension AuthorizeUtils {
    static func authorized() -> Bool {
        let cameraAccess = AuthorizeUtils.captureMediaStatus(mediaType: AVMediaType.video)
        let micAccess = AuthorizeUtils.captureMediaStatus(mediaType: AVMediaType.audio)
        let photoAccess = AuthorizeUtils.photoStatus()
        return cameraAccess == .authorized && micAccess == .authorized && photoAccess.isAvaliable
    }
}
