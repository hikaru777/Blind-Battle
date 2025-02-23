import AVFoundation

class AudioManager: ObservableObject {
    private var engine = AVAudioEngine()
    private var sourceNode: AVAudioSourceNode?
    private var sampleRate: Double = 44100.0
    private var phase: Double = 0.0
    private var frequency: Double = 440.0  // 初期値 A4 (440Hz)
    
    init() {
        setupAudio()
    }
    
    private func setupAudio() {
        let mainMixer = engine.mainMixerNode
        sampleRate = mainMixer.outputFormat(forBus: 0).sampleRate

        sourceNode = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            
            let phaseIncrement = (2.0 * Double.pi * self.frequency) / self.sampleRate
            
            for frame in 0..<Int(frameCount) {
                let sampleVal = Float(sin(self.phase))  // サイン波を生成
                self.phase += phaseIncrement
                if self.phase >= 2.0 * Double.pi {
                    self.phase -= 2.0 * Double.pi
                }
                
                for buffer in ablPointer {
                    let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                    buf[frame] = sampleVal
                }
            }
            return noErr
        }
        
        guard let sourceNode = sourceNode else { return }
        engine.attach(sourceNode)
        engine.connect(sourceNode, to: mainMixer, format: nil)
        
        do {
            try engine.start()
        } catch {
            print("Error starting audio engine: \(error)")
        }
    }
    
    func updatePitch(frequency: Float) {
        self.frequency = Double(frequency)  // リアルタイムで周波数を変更
    }
}
