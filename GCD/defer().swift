import Foundation


func testDefer(){
     defer{
        print("Hello D1")
    }
   
    print("Hello Main")
}

testDefer()