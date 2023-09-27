import Foundation

let process = Process()
process.launchPath = "/usr/bin/env"
process.arguments = ["ls", "-l"]

let outputPipe = Pipe()
process.standardOutput = outputPipe

process.launch()
process.waitUntilExit()

let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
if let output = String(data: outputData, encoding: .utf8) {
    print("Output: \(output)")
}
