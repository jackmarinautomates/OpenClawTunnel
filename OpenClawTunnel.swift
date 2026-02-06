import Foundation
import AppKit

class TunnelManager {
    let host = "178.156.134.97"
    let user = "jack"
    let sshPort = 4956
    let localPort = 18789
    
    func startTunnel() {
        // Verify SSH key exists
        let sshKeyPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".ssh/id_ed25519")
        guard FileManager.default.fileExists(atPath: sshKeyPath.path) else {
            showErrorAlert(message: "No SSH key found at \(sshKeyPath.path). Please generate an SSH key.")
            return
        }
        
        let task = Process()
        task.launchPath = "/usr/bin/ssh"
        task.arguments = [
            "-N",
            "-L", "127.0.0.1:\(localPort):127.0.0.1:18789",
            "-p", "\(sshPort)",
            "-o", "ExitOnForwardFailure=yes",
            "-o", "ServerAliveInterval=30",
            "-o", "ServerAliveCountMax=3",
            "-o", "StrictHostKeyChecking=yes",
            "\(user)@\(host)"
        ]
        
        let pipe = Pipe()
        task.standardError = pipe
        
        do {
            try task.run()
            
            // Show success alert on main thread
            DispatchQueue.main.async {
                let alert = NSAlert()
                alert.messageText = "OpenClaw Tunnel"
                alert.informativeText = "Tunnel established to \(self.host). Access at http://127.0.0.1:\(self.localPort)"
                alert.alertStyle = .informational
                alert.addButton(withTitle: "Open Web UI")
                alert.addButton(withTitle: "Close")
                
                let response = alert.runModal()
                if response == .alertFirstButtonReturn {
                    NSWorkspace.shared.open(URL(string: "http://127.0.0.1:\(self.localPort)")!)
                }
            }
            
            task.waitUntilExit()
        } catch {
            showErrorAlert(message: "Could not establish SSH tunnel: \(error.localizedDescription)")
        }
    }
    
    private func showErrorAlert(message: String) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "Tunnel Error"
            alert.informativeText = message
            alert.alertStyle = .critical
            alert.runModal()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    let tunnelManager = TunnelManager()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        tunnelManager.startTunnel()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

@main
struct OpenClawTunnelApp {
    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }
}