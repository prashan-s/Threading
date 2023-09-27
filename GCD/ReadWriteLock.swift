import Foundation

class ReadWriteLock {
    private var counter = 0
    private let readSemaphore = DispatchSemaphore(value: 1)
    private let writeSemaphore = DispatchSemaphore(value: 1)
    
    func read<T>(_ block: () -> T) -> T {
        readSemaphore.wait()
        counter += 1
        if counter == 1 {
            writeSemaphore.wait()
        }
        readSemaphore.signal()
        
        let result = block()
        
        readSemaphore.wait()
        counter -= 1
        if counter == 0 {
            writeSemaphore.signal()
        }
        readSemaphore.signal()
        
        return result
    }
    
    func write(_ block: () -> Void) {
        writeSemaphore.wait()
        block()
        writeSemaphore.signal()
    }
}

// Usage
let lock = ReadWriteLock()
let queue = DispatchQueue(label: "com.example.queue", attributes: .concurrent)
var sharedResource = 0

// Reading
queue.async {
    lock.read {
        print("Read value: \(sharedResource)")
    }
}

// Writing
queue.async {
    lock.write {
        sharedResource += 1
        print("Wrote value: \(sharedResource)")
    }
}

queue.sync(flags:.barrier){}

print("Hello")
