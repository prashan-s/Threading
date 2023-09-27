import Foundation
import Dispatch

// Immutable Data Model
struct DataModel {
    let data: String
}

// Cache with Optimistic Concurrency
class OptimisticCache {
    private var cache: [String: DataModel] = [:]
    private var version: UInt64 = 0
    private let lock = DispatchSemaphore(value: 1) // Mutex
    
    func read(key: String) -> (DataModel?, UInt64) {
        lock.wait()
        defer { lock.signal() }
        return (cache[key], version)
    }
    
    func compareAndSwap(key: String, oldValue: DataModel?, newValue: DataModel, oldVersion: UInt64) -> Bool {
        lock.wait()
        defer { lock.signal() }
        
        if version == oldVersion {
            cache[key] = newValue
            version += 1
            return true
        }
        return false
    }
}

let cache = OptimisticCache()

let queue1 = DispatchQueue(label: "com.example.queue1")
let queue2 = DispatchQueue(label: "com.example.queue2")

// Simulate updating cache on Queue 1
queue1.async {
    let key = "item1"
    let (oldValue, oldVersion) = cache.read(key: key)
    let newValue = DataModel(data: "newData1")
    if cache.compareAndSwap(key: key, oldValue: oldValue, newValue: newValue, oldVersion: oldVersion) {
        print("Queue1: Successfully updated cache.")
    } else {
        print("Queue1: Cache was updated by another thread. Retrying...")
    }
}

// Simulate updating cache on Queue 2
queue2.async {
    let key = "item1"
    let (oldValue, oldVersion) = cache.read(key: key)
    let newValue = DataModel(data: "newData2")
    if cache.compareAndSwap(key: key, oldValue: oldValue, newValue: newValue, oldVersion: oldVersion) {
        print("Queue2: Successfully updated cache.")
    } else {
        print("Queue2: Cache was updated by another thread. Retrying...")
    }
}

// Give some time for the async operations to complete
sleep(2)
queue1.sync(flags: .barrier) {
    
}


queue2.sync(flags: .barrier) {
    
}
