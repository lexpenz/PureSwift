//
//  Appearance.swift
//  PureSwift
//
//  Created by Aleksei Penzentcev on 02/06/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import UIKit

struct Appearance {
    struct Colors {
        static let mainTint = UIColor("#FF7F4C")
        static let mainTintLightBackground = Colors.mainTint.withAlphaComponent(0.1)
        static let lightTitle = UIColor("#FFFFFF")
        static let whiteBackground = UIColor("#FFFFFF")
        static let lightBackground = UIColor.lightGray.withAlphaComponent(0.2)
        static let darkText = UIColor("#1E2224")
        static let steelGray = UIColor("#797E83")
        static let lightText = Colors.steelGray.withAlphaComponent(0.7)
    }
}
