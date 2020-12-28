//
//  Constants.swift
//  Demo
//
//  Created by Maitri Dutta Banik on 28/12/20.
//

import UIKit

var mainQueue: DispatchQueue {
    DispatchQueue.main
}

var keyWindow: UIWindow? {
    UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
}

var safeAreaInsets: UIEdgeInsets {
    guard let window = keyWindow else { return .zero }
    let padding = window.safeAreaInsets
    return padding
}

// MARK: - Haptics

import CoreHaptics

@available(iOS 13.0, *)
enum Haptic {
    static func playFeedback(_ type: UINotificationFeedbackGenerator.FeedbackType = .success) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    /// The `Haptic` engine
    static var engine: CHHapticEngine?
    
    static func initialized() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            Self.engine = try CHHapticEngine()
            try Self.engine?.start()
        } catch {
            return
        }
        
        engine?.resetHandler = {
            print("The engine reset")
            
            do {
                try Self.engine?.start()
            } catch {
                print("Failed to restart the engine: \(error)")
            }
        }
    }
    
    static func playHaptic(type: HapticType, duration: HapticDuration) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        var intensity: CHHapticEventParameter
        var sharpness: CHHapticEventParameter
        var event: CHHapticEvent
        
        switch type {
        case .intense:
            intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        case .midl:
            intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5)
            sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        }
        
        switch duration {
        case .short:
            event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        case .long:
            event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 0.3)
        }
        
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    enum HapticType {
        case midl
        case intense
    }
    
    enum HapticDuration {
        case short
        case long
    }
}

typealias UICollectionViewable = UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
