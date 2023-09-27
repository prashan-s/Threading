//
//  main.swift
//  Testc
//
//  Created by Prashan Samarathunge on 2023-09-27.
//


import Foundation

let group1 = DispatchGroup()

let queue1 = DispatchQueue(label: "Hello1")
let queue2 = DispatchQueue(label: "Hello2", attributes: .concurrent)

var a = 1;
var numA:[Int] = []
let semaphore = DispatchSemaphore(value: 1)
let start:Date = Date()

group1.notify(queue: .main) {
    print("All Tasks Are Finished!")
}

for _ in (0...100) {
    
    group1.enter()
    queue1.async {
        let s = 1000000.0
        usleep(useconds_t(0.01 * s))
        for x in (0...10) {
            defer {semaphore.signal()}
            print(x)
            a += 1;
            semaphore.wait(wallTimeout: .now() + 0.001)
            
            numA.append(a)
            
           
        }
        print("\n\nT1",a)
        group1.leave()
    }
    group1.enter()
    queue2.async(flags:.barrier) {
        let s = 1000000.0
        usleep(useconds_t(0.01 * s))
        for x in (11...20) {
            print(x)
            a += 1;
            semaphore.wait()
            numA.append(a)
            semaphore.signal()
        }
        a += 1;
        print("\n\nT2",a)
        group1.leave()
    }
}


print("M",a)
wait(nil)
sleep(30)
