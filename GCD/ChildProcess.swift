import Foundation
import Darwin

let processId = fork()
if processId == 0 { // This is the child process
    // Child process code
} else { // This is the parent process
    let source = DispatchSource.makeProcessSource(identifier: processId, eventMask: [.exit], queue: DispatchQueue.global())
    source.setEventHandler {
        let exitStatus = source.data
        print("Child process exited with status: \(exitStatus)")
    }
    source.resume()
}