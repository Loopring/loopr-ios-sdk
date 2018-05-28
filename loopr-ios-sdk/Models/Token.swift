//
//  Token.swift
//  loopr-ios
//
//  Created by kenshin on 2018/3/6.
//  Copyright © 2018年 Loopring. All rights reserved.
//

import Foundation
import UIKit

class Token {

    let symbol: String
    let source: String
    let isMarket: Bool
    let decimals: Int
    let protocol_value: String
    let deny: Bool
    
    // TODO: not sure about whether we need icon in Token
    var icon: UIImage?

    init(json: JSON) {
        self.symbol = json["symbol"].stringValue
        self.source = json["source"].stringValue
        self.isMarket = json["isMarket"].boolValue
        self.decimals = json["decimals"].stringValue.count - 1
        self.protocol_value = json["protocol"].stringValue
        self.deny = json["deny"].boolValue
        self.icon = UIImage(named: self.symbol)
        // TODO: ETH doesn't have a protocol value in tokens.json
        if symbol == "ETH" {
            print(protocol_value)
        }
    }
    
    // TODO: do we need this initialization?
    init?(symbol: String) {
        let token = TokenDataManager.shared.getTokenBySymbol(symbol)
        guard token != nil else {
            return nil
        }
        self.symbol = token!.symbol
        self.source = token!.source
        self.isMarket = token!.isMarket
        self.decimals = token!.decimals
        self.protocol_value = token!.protocol_value
        self.deny = token!.deny
        self.icon = UIImage(named: self.symbol)
    }
    
    static func == (lhs: Token, rhs: Token) -> Bool {
        if lhs.symbol.lowercased() == rhs.symbol.lowercased() {
            return true
        } else {
            return false
        }
    }
}
