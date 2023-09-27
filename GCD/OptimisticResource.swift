import Foundation

class OptimisticResource {
    private var value: Int
    private var version: UInt64
    
    init(value: Int) {
        self.value = value
        self.version = 0
    }
    
    func read() -> (Int, UInt64) {
        return (value, version)
    }
    
    func compareAndSwap(oldValue: Int, newValue: Int, oldVersion: UInt64) -> Bool {
        if value == oldValue && version == oldVersion {
            value = newValue
            version += 1
            return true
        }
        return false
    }
}

// Usage
let resource = OptimisticResource(value: 0)
let queue = DispatchQueue(label: "com.example.queue", attributes: .concurrent)
let queue1 = DispatchQueue(label: "com.example.queue1", attributes: .concurrent)

for x in (1...1000){
   
    var queue1Task1:(Bool) -> Void = {_ in}
    queue1Task1 = { retry in
        queue.async {
            let (oldValue, version) = resource.read()
            // Perform some computation based on oldValue.
            let newValue = oldValue + 1
            if resource.compareAndSwap(oldValue: oldValue, newValue: newValue, oldVersion: version) {
                //print("Successfully updated resource")
                if retry {
                    print("Resource Update Retry Success...")
                }
            } else {
                if retry {
                    print("Resource Update Retry Failed...")
                }else{
                    print("Resource was updated by another thread. Retrying...")
                }
                // Retry logic can go here.
                queue1Task1(true)
                
            }
        }
    }
    queue1Task1(false)
    
    var queue2Task1:(Bool) -> Void = {_ in}
    queue2Task1 = { retry in
        queue1.async {
            let (oldValue, version) = resource.read()
            // Perform some computation based on oldValue.
            let newValue = oldValue + 1
            if resource.compareAndSwap(oldValue: oldValue, newValue: newValue, oldVersion: version) {
                //print("Successfully updated resource")
                if retry {
                    print("Resource Update Retry Failed...")
                }
            } else {
                if retry {
                    print("Resource Update Retry Success...")
                }else{
                    print("Resource was updated by another thread. Retrying...")
                }
                // Retry logic can go here.
                queue2Task1(true)
                    
            }
        }
    }
    queue2Task1(false)
}
queue.sync(flags: .barrier) {
    print("Final Values", resource.read())
    
}
