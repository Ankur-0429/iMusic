import SwiftUI
import AVFoundation

class VolumeManager: ObservableObject {
    @Published var volume: Double = Double(AVAudioSession.sharedInstance().outputVolume)
    private var volumeObserver: NSKeyValueObservation?
    
    init() {
        volumeObserver = AVAudioSession.sharedInstance().observe(\.outputVolume) { [weak self] (_, _) in
            self?.volume = Double(AVAudioSession.sharedInstance().outputVolume)
        }
    }
}
