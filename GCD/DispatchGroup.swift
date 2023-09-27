import Foundation

let group1 = DispatchGroup()
let queue = DispatchQueue.global()
print(Thread.isMainThread)


queue.async(group:group1) {
        
    print("Task 1 Started")
    sleep(1)
    print("Task 1 Finished")
       
    group1.leave()
}

queue.async(group:group1) {
    print("Task 2 Started")
    sleep(1)
    print("Task 2 Finished")
    group1.leave()
}
    
queue.async {

    print("Task 3 Started")
    sleep(1)
    print("Task 3 Finished")
       
}
    
group1.notify(queue: .main){
    print("Tasks Completed")
}




