//  ____                               _      ____               _           _       _          _
// / ___|   _ __ ___     __ _   _ __  | |_   / ___|   ___     __| |   __ _  | |__   | |   ___  | |
// \___ \  | '_ ` _ \   / _` | | '__| | __| | |      / _ \   / _` |  / _` | | '_ \  | |  / _ \ | |
//  ___) | | | | | | | | (_| | | |    | |_  | |___  | (_) | | (_| | | (_| | | |_) | | | |  __/ |_|
// |____/  |_| |_| |_|  \__,_| |_|     \__|  \____|  \___/   \__,_|  \__,_| |_.__/  |_|  \___| (_)
//


public typealias SmartCodable = SmartDecodable & SmartEncodable


extension Array: SmartCodable where Element: SmartCodable { }
extension Dictionary: SmartCodable where Key == String, Value == SmartAny { }


//MARK: - =========== 版本Todo List ===========

// MARK: 继承Model的解码支持
/**
 * 1. ❌ 继承Model的解码支持
 *   - 说明：model继承时，编译器只给`ClassModel`添加了`init(from decoder: Decoder)`，`ClassSubModel`则没有。
 *   - 结论：在解码时，判断当前是否ClassSubModel，如果是的话，执行 `try super.init(from: decoder)`。
 */

// MARK: 性能优化
/**
 * 2. ❌ 性能优化
 *   - 说明：理论上SmartCodable的解析性能是劣于Codable，强于HandyJSON的。
 *          希望通过优化算法/逻辑实现/减少类型判断和转换，提升解析性能。
 *   - 结论：todo
 */



//MARK: - =========== 版本更新记录 ===========
// 【❌未完成   ✅已完成】

//MARK: - ～> V4 版本



//MARK: - ～> V3 版本
// MARK: V3.3.0
/**
 * 1. ✅ 支持自定义的value解析规则
 *   - 说明：支持value的解析规则，比如Date，可以设置解析策略做不同的实现。
 *   - 结论：SmartValueTransformer
 *
 * 2. ✅ 修复包含SmartAny的数据，转json失败问题。
 *   - 说明：转换之前对数据进行类型判断，合适的时机进行解包。
 *   - 结论：已完成
 *
 * 3. ✅ 修复json中包含null，进行模型化处理失败问题。
 *   - 说明：json中某一个字段的值是json字符串，但是对应的属性是模型。
 *   - 结论：已完成
 */




// MARK: V3.2.1
/**
 * 1. ✅ 删除SmartCaseDefaultable的defaultCase
 *   - 说明：删除SmartCaseDefaultable的默认defaultCase实现。
 *   - 结论：本来defaultCase是为了解析枚举异常的填充值，现在解析失败会使用初始化值进行填充。
 */




// MARK: V3.2.0
/**
 * 1. ✅ 支持自定义解析路径
 *   - 说明：可以像HandyJSON一样，跨路径解析。例如 "nameDict.name" 将nameDict字典里的name自动解析到name属性上。
 *   - 结论：在数据层做文章，将路径对应的value获取到，添加到当前的字典中（判断字典是否有这个key）。
 *
 * 2. ✅ 支持全局的key映射
 *   - 说明：蛇形转驼峰，首字母大写转小写
 *   - 结论：SmartDecodingOption中新增keyStrategy，支持全局key的解码策略。
 *
 * 3. ✅ 支持手动加壳
 *   - 说明：Any -> SmartAny, [Any] -> [SmartAny], [String: Any] -> [String: SmartAny]
 *   - 结论：新增cover方法。
 */


// MARK: V3.1.0
/**
 * 1. ✅ 平替HandyJSON
 *   - 说明：尽量减少替换HandyJSON的工作量。
 *   - 结论：将deserialize(dict:) deserialize(json:) deserialize(data:) 优化为 deserialize(from:)。与HandyJSON的调用一致。
 */


// MARK: V3.0.5
/**
 * 1. ✅ 修复SmartAny解析失败问题
 *   - 说明：SmartAny是为了处理Any类型解析新引入的解析类型，未能正确在decoder的unbox方法中进行处理。
 *   - 结论：新增了SmartAny类型的unbox方法。
 */


// MARK: V3.0.4
/**
 * 1. ✅ 支持macOS
 */


// MARK: V3.0.0
/**
 * 1. ✅ 默认值支持
 *   - 说明：解码失败并且类型兼容失败，使用Model属性设置的默认值填充。
 *   - 结论：重写解码器，解码Model类型的时候，初始化该类型，通过Mirror方式获取并记录属性名以及对应的值。
 *
 * 2. ✅ 删除SmartDecodingOptional
 *   - 说明：不使用属性包装器解决模型属性的可选解析
 *   - 结论：放弃重写系统的JSONKeyedDecodingContainer的协议方法，该用重写整改解码器，自然就不会导致循环调用。
 *
 * 3. ✅ 属性包装器支持修饰struct
 *   - 说明：考虑到didfinishMapping的使用，属性包装器只能修饰class。
 *   - 结论：同2
 *
 * 4. ✅ 支持内置json字符串的对象化解析
 *   - 说明：字典中的值是可对象的json字符串（可以转字典或数组），目前不支持转义为对象解析。
 *   - 结论：内部判断类型，如果属性类型继承了SmartCodable，并且数据值是可对象的json字符串，就转义处理。
 *
 * 5. ✅ 解析key的映射支持Model内处理
 *   - 说明：像HandyJSON的mapping方法一样，支持Model内进行key的映射。
 *   - 结论：当前解码类型继承了SmartCodable，对当前codingPath路径下的key对应关系进行映射处理，
 *          即：ModelKeyMapper的功能。
 *
 * 6. ✅ 日志捕获优化
 *   - 说明：当解析失败，需要兼容时候，期望抛出相关日志，引起开发者警觉，做相应的优化处理（优化数据/优化属性声明）。
 *   - 结论：已经完成。
 *
 * 7. ✅ 整体测试
 *   - 说明：穷尽测试场景，包含但不限于：
 *        数据测试：
 *          * 支持的所有类型的可选属性的测试（keyless / null / typeMismatch）
 *          * 支持的所有类型的非选属性的测试（keyless / null / typeMismatch）
 *          * 特殊类型（Date / Data / URL 等）
 *          * 多层级的嵌套结构
 *        功能测试：
 *          * key的映射
 *          * 解码完成的回调
 *          * WCDB的兼容性
 *
 * 8. ✅ 更新Readme
 */

