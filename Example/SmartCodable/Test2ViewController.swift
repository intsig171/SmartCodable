//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable
import HandyJSON



class Test2ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let json = """
        {
            "printer_temp_tab": [
                {
                    "detail_list": [
                        {
                            "name": "实线纸",
                            "original": "https://ss-cdn.camscanner.com/10000_778773f1a68a40f666a95e9e4d2532e5.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_778773f1a68a40f666a95e9e4d2532e5.jpg"
                        },
                        {
                            "name": "虚线纸",
                            "original": "https://ss-cdn.camscanner.com/10000_f74d7e5f99b78d432a1f56af7f7bc487.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_f74d7e5f99b78d432a1f56af7f7bc487.jpg"
                        },
                        {
                            "name": "田字格1",
                            "original": "https://ss-cdn.camscanner.com/10000_2f1caa04103d1e0011615717b1c6418b.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_2f1caa04103d1e0011615717b1c6418b.jpg"
                        },
                        {
                            "name": "田字格2",
                            "original": "https://ss-cdn.camscanner.com/10000_62a166c74b911f61b58c2e1b169bd455.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_62a166c74b911f61b58c2e1b169bd455.jpg"
                        },
                        {
                            "name": "田字格3",
                            "original": "https://ss-cdn.camscanner.com/10000_d92886186c5263ec3ed1beda3fccb22b.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_d92886186c5263ec3ed1beda3fccb22b.jpg"
                        },
                        {
                            "name": "米字格1",
                            "original": "https://ss-cdn.camscanner.com/10000_f829bccee29116650a5135dc9c4dc62d.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_f829bccee29116650a5135dc9c4dc62d.jpg"
                        },
                        {
                            "name": "米字格2",
                            "original": "https://ss-cdn.camscanner.com/10000_1d0f3b25c81f3f6221ef6809f6f69a41.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_1d0f3b25c81f3f6221ef6809f6f69a41.jpg"
                        },
                        {
                            "name": "米字格3",
                            "original": "https://ss-cdn.camscanner.com/10000_8ff04d801075b9bc84d487a1a211752c.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_8ff04d801075b9bc84d487a1a211752c.jpg"
                        },
                        {
                            "name": "语文作文纸",
                            "original": "https://ss-cdn.camscanner.com/10000_dd08503dd6bd6559233271ffbae5eb50.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_dd08503dd6bd6559233271ffbae5eb50.jpg"
                        },
                        {
                            "name": "拼音纸",
                            "original": "https://ss-cdn.camscanner.com/10000_e3c55525d29979e549e852a1f7c028db.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_e3c55525d29979e549e852a1f7c028db.jpg"
                        },
                        {
                            "name": "英语作业纸",
                            "original": "https://ss-cdn.camscanner.com/10000_fddde9ac83c96331eb893a9855c69a6e.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_fddde9ac83c96331eb893a9855c69a6e.jpg"
                        },
                        {
                            "name": "英语作文纸",
                            "original": "https://ss-cdn.camscanner.com/10000_b23e07e22a24f3377c4a66a033eca7c3.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_b23e07e22a24f3377c4a66a033eca7c3.jpg"
                        },
                        {
                            "name": "数学作业纸1",
                            "original": "https://ss-cdn.camscanner.com/10000_eb47c60c8e2c7d13feda7256850aaf74.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_eb47c60c8e2c7d13feda7256850aaf74.jpg"
                        },
                        {
                            "name": "数学作业纸2",
                            "original": "https://ss-cdn.camscanner.com/10000_df176bb22db27b78fa98de889bcbf10b.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_df176bb22db27b78fa98de889bcbf10b.jpg"
                        },
                        {
                            "name": "数学方格纸",
                            "original": "https://ss-cdn.camscanner.com/10000_77074b527ad8891c592f6ee243290b4f.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_77074b527ad8891c592f6ee243290b4f.jpg"
                        },
                        {
                            "name": "信纸-单线",
                            "original": "https://ss-cdn.camscanner.com/10000_0bdcf78f54d57742f04ab2e131a36fbb.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_0bdcf78f54d57742f04ab2e131a36fbb.jpg"
                        },
                        {
                            "name": "信纸-双线",
                            "original": "https://ss-cdn.camscanner.com/10000_904c09a896c58dd59ee97d60470bb2cc.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_904c09a896c58dd59ee97d60470bb2cc.jpg"
                        },
                        {
                            "name": "信纸-装订线",
                            "original": "https://ss-cdn.camscanner.com/10000_4362c6b26129396048b3b24abafb00a2.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_4362c6b26129396048b3b24abafb00a2.jpg"
                        }
                    ],
                    "icon_url": "https://ss-cdn.camscanner.com/10000_43a7e569bb204db279e9079086591251.png",
                    "title": "书写纸",
                    "type": 1
                },
                {
                    "detail_list": [
                        {
                            "name": "课程表1",
                            "original": "https://ss-cdn.camscanner.com/10000_b76fafaf71ead238bee16a92106475ed.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_b76fafaf71ead238bee16a92106475ed.jpg"
                        },
                        {
                            "name": "课程表2",
                            "original": "https://ss-cdn.camscanner.com/10000_cd639c44a3976604e7f134688a96ed75.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_cd639c44a3976604e7f134688a96ed75.jpg"
                        },
                        {
                            "name": "课程表3",
                            "original": "https://ss-cdn.camscanner.com/10000_b12f567e0237c08c962f591e0c54ec7e.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_b12f567e0237c08c962f591e0c54ec7e.jpg"
                        },
                        {
                            "name": "课程表4",
                            "original": "https://ss-cdn.camscanner.com/10000_7acd8c08e57e4527b4963c42a4a97c7d.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_7acd8c08e57e4527b4963c42a4a97c7d.jpg"
                        },
                        {
                            "name": "课程表-粉",
                            "original": "https://ss-cdn.camscanner.com/10000_d3800a0d693adaff53cf57de49d10704.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_d3800a0d693adaff53cf57de49d10704.jpg"
                        },
                        {
                            "name": "课程表-褐",
                            "original": "https://ss-cdn.camscanner.com/10000_26058e2190a1d336d259a069a44767eb.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_26058e2190a1d336d259a069a44767eb.jpg"
                        },
                        {
                            "name": "课程表-蓝",
                            "original": "https://ss-cdn.camscanner.com/10000_4932ab36ebf84dbed9a041b737c73a8f.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_4932ab36ebf84dbed9a041b737c73a8f.jpg"
                        },
                        {
                            "name": "课程表-渐变",
                            "original": "https://ss-cdn.camscanner.com/10000_a8562fa759af82caaee446e079b71298.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_a8562fa759af82caaee446e079b71298.jpg"
                        },
                        {
                            "name": "课程表-蓝灰线条",
                            "original": "https://ss-cdn.camscanner.com/10000_68a3a6a33130dfafa6a0083dda7c0b5c.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_68a3a6a33130dfafa6a0083dda7c0b5c.jpg"
                        },
                        {
                            "name": "课程表-蓝灰方块",
                            "original": "https://ss-cdn.camscanner.com/10000_ab7e6d2fcd70b29872aeeb6506c48924.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_ab7e6d2fcd70b29872aeeb6506c48924.jpg"
                        }
                    ],
                    "icon_url": "https://ss-cdn.camscanner.com/10000_359a56e51544b6e415e8946957362532.png",
                    "title": "课程表",
                    "type": 2
                },
                {
                    "detail_list": [
                        {
                            "name": "学习计划表",
                            "original": "https://ss-cdn.camscanner.com/10000_71a03a5a92cdcf58439774dd92c37b04.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_71a03a5a92cdcf58439774dd92c37b04.jpg"
                        },
                        {
                            "name": "学习计划表-日计划",
                            "original": "https://ss-cdn.camscanner.com/10000_6486f388fe91cf7d869f7b9003ac37e0.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_6486f388fe91cf7d869f7b9003ac37e0.jpg"
                        },
                        {
                            "name": "学习计划表-周计划",
                            "original": "https://ss-cdn.camscanner.com/10000_ad0c04964e8e73fc91d0f73d7871d4ae.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_ad0c04964e8e73fc91d0f73d7871d4ae.jpg"
                        },
                        {
                            "name": "学习计划表-橙白",
                            "original": "https://ss-cdn.camscanner.com/10000_8a7bca94ce2f7ec3f53b745b78fe917b.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_8a7bca94ce2f7ec3f53b745b78fe917b.jpg"
                        },
                        {
                            "name": "学习计划表-绿白",
                            "original": "https://ss-cdn.camscanner.com/10000_8e343053cf1f7d0d8933a11e65b5572b.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_8e343053cf1f7d0d8933a11e65b5572b.jpg"
                        },
                        {
                            "name": "学习计划表-黄米",
                            "original": "https://ss-cdn.camscanner.com/10000_91ff24b00a90ff32bd2a3d3829677745.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_91ff24b00a90ff32bd2a3d3829677745.jpg"
                        },
                        {
                            "name": "学习计划表-蓝白",
                            "original": "https://ss-cdn.camscanner.com/10000_c4fa5a2ba37f9deeac8b387d0367fb13.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_c4fa5a2ba37f9deeac8b387d0367fb13.jpg"
                        },
                        {
                            "name": "学习计划表-深蓝",
                            "original": "https://ss-cdn.camscanner.com/10000_a07ed76d1e7ef0bae6c9340b726c4c4d.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_a07ed76d1e7ef0bae6c9340b726c4c4d.jpg"
                        },
                        {
                            "name": "学习计划表-白蓝",
                            "original": "https://ss-cdn.camscanner.com/10000_7b1314d2a1b57bbdaf81fb1d6904b867.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_7b1314d2a1b57bbdaf81fb1d6904b867.jpg"
                        },
                        {
                            "name": "工作计划表",
                            "original": "https://ss-cdn.camscanner.com/10000_d11fa9085046a2e693761b9af517cb75.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_d11fa9085046a2e693761b9af517cb75.jpg"
                        },
                        {
                            "name": "读书计划表",
                            "original": "https://ss-cdn.camscanner.com/10000_033fe17de668e25ae6878ffea79088bf.jpg",
                            "thumb": "https://ss-cdn.camscanner.com/10000_033fe17de668e25ae6878ffea79088bf.jpg"
                        }
                    ],
                    "icon_url": "https://ss-cdn.camscanner.com/10000_40265fa7acc2d92dcf13fef51a95c55e.png",
                    "title": "计划表",
                    "type": 3
                }
            ]
        }
        
        """
        guard let model = PrinterTempTab.deserialize(from: json) else {
            return
        }
        let printList1 = model.printer_temp_tab
//        print("\n\n\n")
        let printListModels = [CEPrinterTemplateTotal].deserialize(from: printList1)
        print(printListModels?.count)

    }
}


struct CEPrinterTemplateItem: SmartCodable {
//    required init() { }
    /// 打印类型名称
    var name: String?
    /// 原图
    var original: String?
    /// 缩略图
    var thumb: String?
    /// 类型名称
    var typeName: String?
}

struct CEPrinterTemplateTotal: SmartCodable {
//    required init() { }
    /// 类型名称
    var title: String?
    /// 类型图片
    var icon_url: String?
    /// 打印类型列表数据
    var detail_list: [CEPrinterTemplateItem] = []
}

class PrinterTempTab: SmartCodable {
    required init() { }
    /// 打印类型列表数据
    var printer_temp_tab: [[String: SmartAny]] = []
}
