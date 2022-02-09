//
//  AudioSessionHelper.swift
//  SwiftBasicTool
//
//  Created by Stephen.Zeng on 2022/1/20.
//

import AVFoundation

open class AudioSessionHelper {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public static let `default` = AudioSessionHelper()
    
    fileprivate(set) var isActive: Bool = false
    
    fileprivate var audioSession: AVAudioSession {
        return AVAudioSession.sharedInstance()
    }
    
    fileprivate init() {
        openAudioSession()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRouteChange),
                                               name: AVAudioSession.routeChangeNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(audioInterruption),
                                               name: AVAudioSession.interruptionNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(mediaServicesWereReset),
                                               name: AVAudioSession.mediaServicesWereResetNotification,
                                               object: nil)
    }
    
    func openAudioSession(_ category: AVAudioSession.Category = .playAndRecord, force: Bool = false) {
        guard force || audioSession.category != category else {
            return
        }
        
        do {
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(category, mode: .default, options: [.mixWithOthers,
                                                                                                    .allowBluetooth,
                                                                                                    .allowAirPlay,
                                                                                                    .allowBluetoothA2DP])
            } else {
                let options: [AVAudioSession.CategoryOptions] = [.mixWithOthers,
                                                                 .allowBluetooth]
                let selector = NSSelectorFromString("setCategory:withOptions:error:")
                AVAudioSession.sharedInstance().perform(selector, with: category, with: options)
            }
            
            if #available(iOS 13.0, *) {
                try audioSession.setAllowHapticsAndSystemSoundsDuringRecording(true)
            }
            
            try AVAudioSession.sharedInstance().setActive(true)
            isActive = true
        } catch {
            print("[SwiftyCam]: Failed to set background audio preference")
        }
    }
    
    func closeAudioSession() {
        guard isActive else {
            return
        }
        do {
            try audioSession.setActive(false)
            isActive = false
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    // 声道发生变化响应
    @objc
    fileprivate func handleRouteChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }
        
        // Switch over the route change reason.
        switch reason {
        case .newDeviceAvailable: // New device found.
            let headphonesConnected = hasHeadphones(in: audioSession.currentRoute)
            print("Has head phone \(headphonesConnected)")
        case .oldDeviceUnavailable: // Old device removed.
            if let previousRoute = userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
                let headphonesConnected = hasHeadphones(in: previousRoute)
                print("Has head phone \(headphonesConnected)")
            }
        case .categoryChange:
            print("Session category changed: \(audioSession.category.rawValue) \(userInfo.description)")
            break
        default:
            print("Route did change \(userInfo.description)")
        }
    }
    
    fileprivate func hasHeadphones(in routeDescription: AVAudioSessionRouteDescription) -> Bool {
        // Filter the outputs to only those with a port type of headphones.
        return !routeDescription.outputs.filter({$0.portType == .headphones}).isEmpty
    }
    
    // 声道被中断响应
    @objc
    func audioInterruption(notification: Notification) {
        guard let reasonRaw = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? NSNumber,
              let reason = AVAudioSession.InterruptionType(rawValue: reasonRaw.uintValue) else {
                  print("ERROR: Could not get Audio Interruption")
            return
        }
        print("Audio interruption: reason \(reason)")
    }
    
    /// 媒体服务重启
    @objc
    func mediaServicesWereReset(notification: Notification) {
        print("WARNING: Media service were reset!")
        DispatchQueue.main.async { [weak self] in
            guard let mine = self else {
                return
            }
            mine.isActive = false
            print("WARNING: Media service were reset! try to open session!")
            mine.openAudioSession(force: true)
        }
    }
    

}
