import Foundation
import Darwin

let signalSource = DispatchSource.makeSignalSource(signal: SIGTERM, queue: DispatchQueue.global())
signalSource.setEventHandler {
    print("Received SIGTERM")
    exit(0)
}
signal(SIGTERM, SIG_IGN) // Ignore default handling
signalSource.resume()

// Simulate receiving a SIGTERM signal after a delay
DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
    kill(getpid(), SIGTERM)
}

sleep(5)
