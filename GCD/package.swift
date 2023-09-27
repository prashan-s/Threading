
import Foundation


let queue1 = DispatchQueue(label: "Hello1",qos:.userInteractive, attributes: .concurrent)
let queue2 = DispatchQueue(label: "Hello2", attributes: .concurrent)

var a = 1;
var numA:[Int] = []

 for _ in (0...10) {
queue1.async {
    
    for x in (0...10) {
        print(x)
        print(x)
        a += 1;
        numA.append(a)
        //print("Current at T1: ", numA[numA.count - 1])
    }
    print("\n\nT1",a)
}
queue2.async {
     for x in (11...20) {
        print(x)
        print(x)
        a += 1;
        numA.append(a)
       // print("Current at T2: ", numA[numA.count - 1])
    }
    a += 1;
    print("\n\nT2",a)
}
 }
print("M",a)
wait(nil)