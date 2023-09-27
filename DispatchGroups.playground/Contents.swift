import Foundation



let group1 = DispatchGroup()


let queue = DispatchQueue.global()


queue.async(group: group1) {
    
    print("Task 1 Started")
    sleep(2)
    print("Task 1 Finished")
    
}

queue.async(group: group1) {
    
    print("Task 2 Started")
    sleep(2)
    print("Task 2 Finished")
    
}

queue.async {
    
    print("Task 3 Started")
    sleep(2)
    print("Task 3 Finished")
    
}
