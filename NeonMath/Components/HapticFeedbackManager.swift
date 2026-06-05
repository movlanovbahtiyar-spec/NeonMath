import UIKit

/// Manages tactile haptic feedback using UIKit's feedback generators.
/// Leverages premium haptic feedback to enhance game immersion on iOS devices.
public final class HapticFeedbackManager {
    
    /// The shared singleton instance.
    public static let shared = HapticFeedbackManager()
    
    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
    private let rigidImpact = UIImpactFeedbackGenerator(style: .rigid)
    private let softImpact = UIImpactFeedbackGenerator(style: .soft)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    
    private init() {
        // Warm up generators to minimize latency during gameplay.
        lightImpact.prepare()
        mediumImpact.prepare()
        heavyImpact.prepare()
        rigidImpact.prepare()
        softImpact.prepare()
        notificationGenerator.prepare()
    }
    
    /// Triggers a light tactile sensation for standard button taps or UI hover events.
    public func playTap() {
        lightImpact.impactOccurred()
    }
    
    /// Triggers a soft, subtle haptic for minor UI transitions.
    public func playSoftImpact() {
        softImpact.impactOccurred()
    }
    
    /// Triggers a rigid impact, ideal for puzzle pieces aligning or matching.
    public func playRigidImpact() {
        rigidImpact.impactOccurred()
    }
    
    /// Triggers a medium haptic for more substantial events, e.g. selecting options or state transitions.
    public func playMediumImpact() {
        mediumImpact.impactOccurred()
        // Re-prepare for next usage.
        mediumImpact.prepare()
    }
    
    /// Triggers a heavy haptic, suitable for game-over or big game changes.
    public func playHeavyImpact() {
        heavyImpact.impactOccurred()
        heavyImpact.prepare()
    }
    
    /// Plays a success notification haptic (three quick vibrations) when a correct answer is chosen.
    public func playSuccess() {
        notificationGenerator.notificationOccurred(.success)
        notificationGenerator.prepare()
    }
    
    /// Plays an error notification haptic (rapid warning vibrations) when an incorrect answer is chosen.
    public func playFailure() {
        notificationGenerator.notificationOccurred(.error)
        notificationGenerator.prepare()
    }
    
    /// Plays a warning notification haptic when timer is low.
    public func playWarning() {
        notificationGenerator.notificationOccurred(.warning)
        notificationGenerator.prepare()
    }
}
