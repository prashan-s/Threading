class ThreadSafeCounter {
    private var value: Int
    private let mutex: DispatchSemaphore
    
    init() {
        value = 0
        mutex = DispatchSemaphore(value: 1)
    }
    
    func increment() {
        mutex.wait() // Acquire the mutex lock
        value += 1
        mutex.signal() // Release the mutex lock
    }
    
    func getValue() -> Int {
        mutex.wait() // Acquire the mutex lock
        let temp = value
        mutex.signal() // Release the mutex lock
        return temp
    }
}

let counter = ThreadSafeCounter()

// Create concurrent queue
let queue = DispatchQueue(label: "com.example.queue", attributes: .concurrent)

// Dispatch 10 tasks to increment the counter
for _ in 1...10 {
    queue.async {
        counter.increment()
    }
}

// Wait for all tasks to complete
queue.sync(flags: .barrier) {}

print("Counter value is: \(counter.getValue())")  // Should print "Counter value is: 10"
