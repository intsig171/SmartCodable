//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SmartCodable
import BTPrint

class Test2ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()


//        let dict: [String: Any] = [
//            "name": "Mccc",
//            "age": 20,
//        ]
//        
//        let model = StudentModel.deserialize(from: dict)
//        print(model?.name as Any)
//        print(model?.age as Any)
//        
//        let transDict = model?.toJSONString(prettyPrint: true) ?? ""
//        print("\n Model -> JSON")
//        print(transDict)
    }
    
    class BaseModel: SmartCodable {
        var name: String = ""
        required init() { }
    }
    
    @SmartSubclass
    class StudentModel: BaseModel {
        var age: Int?
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        testSmartCodableInherit()
    }
}




enum Gender: Int, SmartCaseDefaultable {
    case unknown
    case male
    case female
}

class SMCClassAnimal: SmartCodable {
    var age: Int = 0
    var sex: Gender = .unknown
    
    required init() { }
}

@SmartSubclass
class SMCClassPerson: SMCClassAnimal {
    var name: String?
    var motto: String?
    var height = 0
    var temp = 0
    var a = 1.1
    var b = false
    var c = ""
    var d = Date()
    var e = Date()
}

func testSmartCodableInherit() {
        let deJsonStr = """
        {
            "name": "张三丰",
            "age": "23",
            "motto": "nothing is possible.",
            "sex": 1,
            "height": 175
        }
        """
        let obj = SMCClassPerson.deserialize(from: deJsonStr)
    print("height:", obj?.height as Any)
}
