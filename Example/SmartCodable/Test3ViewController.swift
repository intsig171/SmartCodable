import SmartCodable

class Test3ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict: [String: Any] = [
            "type": "String",
            "value": "Mccc"
        ]
        
        let dict1: [String: Any] = [
            "type": "Boolean",
            "value": true
        ]
        
        guard let model = Model.deserialize(from: dict) else { return }
        print(model)
        
        
        guard let model1 = Model.deserialize(from: dict1) else { return }
        print(model1)
    }
    
    struct Model: SmartCodable {
        @SmartAny
        private var value: Any?
        private var type: String = ""
        
        public var enumValue: Value? = .error
        
        mutating func didFinishMapping() {
          
            guard let value = value else { return }
            
            switch type {
            case "String":
                if let s = value as? String {
                    enumValue = Value.string(s)
                }
                
            case "Boolean":
                if let b = value as? Bool {
                    enumValue = Value.bool(b)
                }
            default:
                break
            }
        }
    }
    
    
    enum Value: SmartAssociatedEnumerable {
        static var defaultCase: Value = .error
        case error
        case string(String)
        case bool(Bool)
    }
}
