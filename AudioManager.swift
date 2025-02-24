import AVFoundation

class AudioManager: ObservableObject {
    private var engine = AVAudioEngine()
    private var sourceNode: AVAudioSourceNode?
    private var sampleRate: Double = 44100.0
    private var phase: Double = 0.0
    private var frequency: Double = 440.0  // 初期値 440Hz (A4)
    @Published var isPlaying: Bool = false
    private var mainMixer: AVAudioMixerNode  // 🔹 ミキサーノード
    private var volume: Float = 1.0 // 🔹 デフォルト音量（最大）

    init() {
        mainMixer = engine.mainMixerNode  // 🔹 メインミキサーノードを取得
        setupAudio()
    }

    private func setupAudio() {
        sampleRate = mainMixer.outputFormat(forBus: 0).sampleRate
        
        sourceNode = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            let phaseIncrement = (2.0 * Double.pi * self.frequency) / self.sampleRate
            
            for frame in 0..<Int(frameCount) {
                let sample: Float = self.isPlaying ? Float(sin(self.phase)) * self.volume : 0 // 🔹 音量を適用
                self.phase += phaseIncrement
                if self.phase >= 2.0 * Double.pi {
                    self.phase -= 2.0 * Double.pi
                }
                for buffer in ablPointer {
                    let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                    buf[frame] = sample
                }
            }
            return noErr
        }
        
        if let sourceNode = sourceNode {
            engine.attach(sourceNode)
            engine.connect(sourceNode, to: mainMixer, format: nil)
        }
        
        do {
            try engine.start()
        } catch {
            print("Error starting audio engine: \(error)")
        }
    }

    func updatePitch(frequency: Float) {
        self.frequency = Double(frequency)
        isPlaying = true
    }

    func stopSound() {
        isPlaying = false
    }

    // 🔊 **音量を変更するメソッドを追加**
    func setVolume(_ newVolume: Float) {
        volume = max(0.0, min(newVolume, 1.0)) // 🔹 0.0（無音）〜 1.0（最大音量）の範囲に制限
        mainMixer.outputVolume = volume // 🔹 AVAudioMixerNode の音量を変更
    }
}
