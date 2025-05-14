import CodableWrapper

class Test3ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    @Codable
    class Model {
        var name: String = ""
    }
    
    @CodableSubclass
    class SubModel: Model {
//        var age = [:]
        var age1: Int?
    }
}

