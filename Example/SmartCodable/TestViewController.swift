//
//  TestViewController.swift
//  SmartCodable_Example
//
//  Created by Mccc on 2023/9/1.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SmartCodable
import HandyJSON
import CleanJSON
import BTPrint



/** 字典的值情况
 * 无key
 * 值为null
 * 值类型错误
 */

/** 字典的类型情况
 * 非可选基础字典
 * 可选基础字典
 *
 * 非可续Model
 * 可选Model
 *
 * 使用 SmartAny 修饰
 * 使用 SmartPlat 修饰
 *
 */





class TestViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SmartConfig.debugMode = .none
        

        
        let json = """

                {
                    "baseAppDrainage": "",
                    "adChannel": "0",
                    "versionInfo": {
                        "version": "1.0.0",
                        "build": 1,
                        "createTime": "2024-07-02 18:59:28",
                        "id": 1257772650835476480,
                        "packageName": "com.elevrin.app"
                    },
                    "configDefault": {
                        "IPFiltration": [
                            "CHINA",
                            "CHINESE",
                            "CINEMA",
                            "CN",
                            "COMIC",
                            "CONSTANTIN",
                            "DISNEY",
                            "DREAMWORK",
                            "ENTERTAINMENT",
                            "EUROPACORP",
                            "FILM",
                            "FOCUS",
                            "GAUMONT",
                            "GOOGLE",
                            "HEIDI",
                            "HOLLYWOOD",
                            "HULU",
                            "IMAGE",
                            "IQIYI",
                            "LARICK",
                            "LEGENDARY",
                            "LIONSGATE",
                            "MARVEL",
                            "MEDIA",
                            "MIRAMAX",
                            "NETFLIX",
                            "NEW LINE",
                            "PARAMOUNT",
                            "PEACOCK",
                            "PHILO",
                            "PICTURE",
                            "PIXAR",
                            "SONY",
                            "STARLIGHT",
                            "STARZ",
                            "STUDIO",
                            "STX",
                            "TENCENT",
                            "TOUCHSTONE",
                            "TUBI",
                            "TV",
                            "UNIVERSAL",
                            "CHINANET",
                            "VIKI",
                            "ZEUS",
                            "VUDU",
                            "WARNER",
                            "WEINSTEIN"
                        ]
                    },
                    "eventConfig": {
                        "returnDetail": [],
                        "eventType": "",
                        "returnDetailAd": "",
                        "adType": []
                    },
                    "messagePush": "",
                    "com.elevrin.app": [],
                    "Home_Data": [
                        {
                            "data": [
                                {
                                    "vodeo": 28407,
                                    "type": "movie"
                                },
                                {
                                    "vodeo": 28493,
                                    "type": "movie"
                                },
                                {
                                    "vodeo": 24179,
                                    "type": "movie"
                                },
                                {
                                    "vodeo": 28367,
                                    "type": "movie"
                                },
                                {
                                    "vodeo": 20791,
                                    "type": "movie"
                                }
                            ],
                            "level": 0,
                            "mode": 0,
                            "name": "Home Carousel"
                        },
                        {
                            "data": [
                                {
                                    "vodeo": 20791,
                                    "type": "movie"
                                },
                                {
                                    "vodeo": 28303,
                                    "type": "movie"
                                },
                                {
                                    "vodeo": 28211,
                                    "type": "movie"
                                },
                                {
                                    "vodeo": 28236,
                                    "type": "movie"
                                },
                                {
                                    "vodeo": 28220,
                                    "type": "movie"
                                }
                            ],
                            "level": 1,
                            "mode": 0,
                            "name": "Trending",
                            "id": 1
                        },
                        {
                            "data": [
                                {
                                    "vodeo": 14064,
                                    "type": "tv"
                                },
                                {
                                    "vodeo": 14053,
                                    "type": "tv"
                                },
                                {
                                    "vodeo": 14056,
                                    "type": "tv"
                                },
                                {
                                    "vodeo": 14043,
                                    "type": "tv"
                                },
                                {
                                    "vodeo": 14052,
                                    "type": "tv"
                                }
                            ],
                            "level": 2,
                            "mode": 0,
                            "name": "Popular TV Shows",
                            "id": 2
                        },
                        {
                            "data": [
                                {
                                    "vodeo": 27915,
                                    "type": "movie"
                                },
                                {
                                    "vodeo": 25650,
                                    "type": "movie"
                                },
                                {
                                    "vodeo": 28380,
                                    "type": "movie"
                                },
                                {
                                    "vodeo": 28383,
                                    "type": "movie"
                                },
                                {
                                    "vodeo": 28381,
                                    "type": "movie"
                                }
                            ],
                            "level": 3,
                            "mode": 0,
                            "name": "Popular Movies",
                            "id": 3
                        }
                    ],
                    "playSubTypeRatio": [],
                    "privacyLink": "https://catfight.top"
                }
        
        """
        
        
        if let model = NNInfos.deserialize(from: json) {
            smartPrint(value: model)
        }

    }
    struct NNInfos: SmartCodable {
        var version: String = ""
        var build: Int = -1
        var ipfilters: [String] = []
        var privacyLink: String = ""
        
        static func mappingForKey() -> [SmartKeyTransformer]? {
            let versionKey = "versionInfo".fixValue + "." + "version".fixValue
            let buildKey = "versionInfo".fixValue + "." + "build".fixValue
            let ipfilesKey = "configDefault".fixValue + "." + "IPFiltration".fixValue
            return [
                CodingKeys.version <--- versionKey,
                CodingKeys.build <--- buildKey,
                CodingKeys.ipfilters <--- ipfilesKey,
                CodingKeys.privacyLink <--- "privacyLink".fixValue
            ]
        }
    }
}
extension String {
    var fixValue: String {
        return self
    }
}
