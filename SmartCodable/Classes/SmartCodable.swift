/** 要兼容的场景
 * 1. 【完成】接口多返回了一个字段
 * 2. 【完成】接口少返回了一个字段
 * 3. 【完成】key的名称不对应
 * 4. 【完成】返回值中，有nil，null等的处理。
 * 4. 【完成】嵌套结构
 * 5. 【完成】处理枚举值， 枚举值命中不了的兜底方案。
 * 6. 【完成】Bool类型兼容，0，1， true，false 字符串或Int
 * 7. 【完成】兼容 Int 转 String. 定义为String，但是给的是Int类型。 看看HandyJson 怎么实现的
 * 8.
 * 9. 【完成】如果重写了init方法， 就不兼容了。 看看如何提供封装的方法。
 * 10.【完成】当前类解析失败的默认值。
 *
 
 //            if let userInfoKey = CodingUserInfoKey.originModelKey, let dict = superDe.userInfo[userInfoKey] {
 //
 //                let mrr = Mirror(reflecting: dict)
 //                for child in mrr.children {
 //                    if child.label == key.stringValue {
 //                        print(child.value)
 //                        if let temp = child.value as? T {
 //                            return temp
 //                        }
 //                    }
 //                }
 //            }

 */

//todo 重写init方法，放弃SmartValue。 或者将SmartValue作为补充值。看看BT
//todo 看看Encode需要处理么？

/** 特色功能
 1. 【完成】 字段解析失败的，print输出， 当前类型是什么。 给的类型是什么？ 值是什么？
 2. 【完成】多种调用形式， josnStr，Dict，各种转换。
 3. 【完成】多个存在的字段映射到同一个值，优先级。 期望是用第一个。
 4. 属性包裹器，期望可以设置默认值。
 5. 自定义取值路径
 6. 反向编码的能力。 model 转 dict 转jsonStr
 */


/** 劣势：
 3. 【完成】因为Any并不能实现Codable。所以包含Any的字典类型，数组类型，均不可以。 解决办法： 指定类型： 【String：String】。 或者使用范型 struct ABC《T： Codable》
 4. 无法自动兼容枚举映射失败的情况，需要自己实现协议。  哪怕是设置为可选类型。
 5. 默认值设置无效，会被兼容替换掉。拿不到设置的默认值，暂时没法处理。【完成】默认值的处理方案，在didFinish里面处理。
 6. 不兼容decodeIfPresent方法，如果属性设置为可选，将走decodeIfPresent解析路径。目前无所兼容该场景。 
 */


/** 资源
 * https://blog.csdn.net/u010259906/article/details/119748827
 * https://juejin.cn/post/6844903566730067982
 * https://juejin.cn/post/7044871144091942925
 * https://juejin.cn/post/7057839007396266014
 */



public typealias SmartCodable = SmartDecodable & SmartEncodable


