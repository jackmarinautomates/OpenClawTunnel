import Foundation
import AppKit

class TunnelManager {
    let host = "178.156.134.97"
    let user = "jack"
    let sshPort = 4956
    let localPort = 18789
    
    func startTunnel() {
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
            
            // Show success alert
            let alert = NSAlert()
            alert.messageText = "OpenClaw Tunnel"
            alert.informativeText = "Tunnel established to \(host). Access at http://127.0.0.1:\(localPort)"
            alert.alertStyle = .informational
            alert.addButton(withTitle: "Open Web UI")
            alert.addButton(withTitle: "Close")
            
            let response = alert.runModal()
            if response == .alertFirstButtonReturn {
                NSWorkspace.shared.open(URL(string: "http://127.0.0.1:\(localPort)")!)
            }
            
            task.waitUntilExit()
        } catch {
            // Show error alert
            let alert = NSAlert()
            alert.messageText = "Tunnel Error"
            alert.informativeText = "Could not establish SSH tunnel: \(error.localizedDescription)"
            alert.alertStyle = .critical
            alert.runModal()
        }
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

class AppDelegate: NSObject, NSApplicationDelegate {
    let tunnelManager = TunnelManager()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        tunnelManager.startTunnel()
    }
}