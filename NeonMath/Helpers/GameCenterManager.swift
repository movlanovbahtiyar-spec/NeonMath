import GameKit
import SwiftUI
import Combine

@MainActor
public final class GameCenterManager: NSObject, ObservableObject, GKGameCenterControllerDelegate {
    public static let shared = GameCenterManager()
    
    @Published public var isAuthenticated = false
    
    private override init() {
        super.init()
    }
    
    /// Authenticates the local player with Game Center.
    /// If authentication is required, presents the sign-in view controller.
    public func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = { [weak self] viewController, error in
            Task { @MainActor in
                if let viewController = viewController {
                    // Present game center login view controller
                    if let rootVC = UIApplication.shared.connectedScenes
                        .compactMap({ $0 as? UIWindowScene })
                        .first?.windows.first?.rootViewController {
                        rootVC.present(viewController, animated: true)
                    }
                } else if localPlayer.isAuthenticated {
                    self?.isAuthenticated = true
                    print("Game Center: Local player authenticated successfully.")
                } else {
                    self?.isAuthenticated = false
                    if let error = error {
                        print("Game Center: Authentication failed with error: \(error.localizedDescription)")
                    } else {
                        print("Game Center: Authentication failed or disabled.")
                    }
                }
            }
        }
    }
    
    /// Submits a high score directly to the Game Center leaderboard.
    public func reportScore(score: Int) {
        guard GKLocalPlayer.local.isAuthenticated else {
            print("Game Center: Cannot report score, player is not authenticated.")
            return
        }
        
        let leaderboardID = "com.bahtiyar.NeonMath.Leaderboard"
        GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [leaderboardID]) { error in
            if let error = error {
                print("Game Center: Failed to report score \(score) to leaderboard \(leaderboardID): \(error.localizedDescription)")
            } else {
                print("Game Center: Score \(score) reported successfully to leaderboard \(leaderboardID).")
            }
        }
    }
    
    /// Displays the default Game Center leaderboard overlay.
    public func showLeaderboard() {
        guard GKLocalPlayer.local.isAuthenticated else {
            print("Game Center: Player is not authenticated. Triggering login flow.")
            authenticateLocalPlayer()
            return
        }
        
        let gcViewController = GKGameCenterViewController(state: .leaderboards)
        gcViewController.gameCenterDelegate = self
        
        if let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first?.rootViewController {
            rootVC.present(gcViewController, animated: true)
        }
    }
    
    // MARK: - GKGameCenterControllerDelegate
    
    nonisolated public func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        Task { @MainActor in
            gameCenterViewController.dismiss(animated: true, completion: nil)
        }
    }
}
