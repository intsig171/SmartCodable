//
//  BTBubble+Menu.swift
//  BTBubble
//
//  Created by Mccc on 2022/11/21.
//
import Foundation

extension BTBubble {
    
    /// 初始化菜单气泡
    /// - Returns: 气泡的实例
    public static func makeMenuBubble() -> BTBubble {
        let bubble = BTBubble()
        bubble.arrowOffset = .center(0)
        bubble.edgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
        bubble.fillColor = UIColor.hex("212121")
        return bubble
    }
}


extension BTBubble {
 
    /// 菜单样式
    public struct Menu { }
}


extension BTBubble.Menu {
    
    
    /// 菜单的样式配置
    public struct Config {
        /// 菜单Item的宽度
        public var width: ContainerWidth = .auto(80)
        /// 菜单Item的高度
        public var height: CGFloat = 42
        
        public init() { }
        
        public enum ContainerWidth {
            /// 自动计算宽度，关联值是最大宽度
            case auto(CGFloat)
            /// 固定宽度，关联值是宽度值
            case fixed(CGFloat)
        }
    }
    

    
    /// 菜单元素
    public struct Item {
        
        /// 文案
        public var text: String = ""
        /// 标记 （如果文案是动态的情况，可以用这个标记）
        public var identifier: String = ""
        /// 居左图标（如有需要的话）
        public var image: UIImage?
        
        public init(text: String, identifier: String, image: UIImage?) {
            self.text = text
            self.identifier = identifier
            self.image = image
        }
    }
}






/// 菜单View
public class BTBubbleMenu: UIView {
    
    
    /// 点击选中之后的回调
    public var selectItemBlock: ((BTBubble.Menu.Item) -> Void)?
    
    
    /// 菜单View的初始化方法
    /// - Parameters:
    ///   - items: 菜单元素
    ///   - config: 菜单配置
    public init(items: [BTBubble.Menu.Item], config: BTBubble.Menu.Config? = nil) {
        super.init(frame: .zero)
        self.items = items
        self.config = config
        
        frame = getFrame()
        backgroundColor = UIColor.hex("212121")
        
        tableView.backgroundColor = UIColor.hex("212121")
        tableView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        addSubview(tableView)
        tableView.reloadData()
    }
    
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func getFrame() -> CGRect {
        var tempConfig = BTBubble.Menu.Config()
        if let tem = config {
            tempConfig = tem
        }
        
        let height: CGFloat = CGFloat(items.count) * tempConfig.height

        
        switch tempConfig.width {
        case .auto(let max):
            
            var textWidth: CGFloat = 0
            
            for item in items {
                let text = item.text
                var width: CGFloat = text.getWidth(font: UIFont.systemFont(ofSize: 12), height: 20)
                
                if let image = item.image {
                    width += (image.size.width + 5)
                }
                
                if width > textWidth {
                    textWidth = width
                }
            }
            return CGRect(x: 0, y: 0, width: min(textWidth, max), height: height)
        case .fixed(let width):
            return CGRect(x: 0, y: 0, width: width, height: height)
        }
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: .zero, style: .plain)
        tb.delegate = self
        tb.dataSource = self
        tb.separatorStyle = .none
        
        tb.estimatedRowHeight = 0
        tb.estimatedSectionHeaderHeight = 0
        tb.estimatedSectionFooterHeight = 0
        
        tb.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")
        return tb
    }()
    
    var items: [BTBubble.Menu.Item] = []
    var config: BTBubble.Menu.Config?
}


extension BTBubbleMenu: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell: MenuCell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.selectionStyle = .none
        if items.count > indexPath.row {
            let item = items[indexPath.row]
            cell.item = item
            cell.isHiddenLine = (items.count - 1) == indexPath.row
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return config?.height ?? 42
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if items.count > indexPath.row {
            let item = items[indexPath.row]
            selectItemBlock?(item)
        }
    }
}

class MenuCell: UITableViewCell {
    
    var item: BTBubble.Menu.Item? {
        didSet {
            contentlabel.text = item?.text
            
            if let image = item?.image {
                iconImageView.image = image
                iconImageView.isHidden = false
                
                let imgX: CGFloat = 0
                let imgY: CGFloat = (self.contentView.frame.size.height - image.size.height)/2
                iconImageView.frame = CGRect(x: imgX, y: imgY, width: image.size.width, height: image.size.height)

                let labelX: CGFloat = iconImageView.frame.maxX + 5
                let labelWidth: CGFloat = self.contentView.frame.size.width - labelX
                let labelHeight: CGFloat = self.contentView.frame.size.height
                contentlabel.frame = CGRect(x: labelX, y: 0, width: labelWidth, height: labelHeight)
                
            } else {
                iconImageView.isHidden = true
                contentlabel.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
            }
            
            lineView.frame = CGRect(x: 0, y: self.contentView.frame.size.height - 0.5, width: self.contentView.frame.size.width, height: 0.5)
        }
    }
    
    var isHiddenLine: Bool = false {
        didSet {
            lineView.isHidden = isHiddenLine
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.hex("212121")
    
        contentView.addSubview(iconImageView)
        contentView.addSubview(contentlabel)
        contentView.addSubview(lineView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var contentlabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.isHidden = true
        return iv
    }()
}
