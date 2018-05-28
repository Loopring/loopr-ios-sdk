//
//  Asset.swift
//  loopr-ios
//
//  Created by Xiao Dou Dou on 2/1/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import Foundation
import UIKit
import BigInt

class Asset: CustomStringConvertible, Equatable {

    let symbol: String
    var name: String   // TODO: not used?
    var icon: UIImage?
    var enable: Bool
    var balance: Double
    var allowance: Double
    var display: String
    var description: String
    
    init(json: JSON) {
        self.enable = true
        self.balance = 0.0
        self.allowance = 0.0
        self.display = Double(0).currency
        self.symbol = json["symbol"].stringValue
        self.icon = UIImage(named: self.symbol) ?? nil
        self.name = TokenDataManager.shared.getTokenBySymbol(symbol)?.source ?? "unknown token"
        self.description = self.name
        if let balance = Asset.getAmount(of: symbol, fromWeiAmount: json["balance"].stringValue) {
            self.balance = balance
        }
        if let allowance = Asset.getAmount(of: symbol, fromWeiAmount: json["allowance"].stringValue) {
            self.allowance = allowance
        }
    }
    
    init(symbol: String) {
        self.symbol = symbol
        self.name = ""
        self.enable = true
        self.description = self.name
        self.icon = UIImage(named: self.symbol) ?? nil
        self.balance = 0.0
        self.allowance = 0.0
        self.display = Double(0).currency
    }

    static func getAmount(of symbol: String, fromWeiAmount weiAmount: String) -> Double? {
        var index: String.Index
        var result: Double? = nil
        // hex string
        if weiAmount.lowercased().starts(with: "0x") {
            let hexString = weiAmount.dropFirst(2)
            let decString = BigUInt(hexString, radix: 16)!.description
            return getAmount(of: symbol, fromWeiAmount: decString)
        } else if let token = TokenDataManager.shared.getTokenBySymbol(symbol) {
            var amount = weiAmount
            guard token.decimals < 100 || token.decimals >= 0 else {
                return result
            }
            if amount == "0" {
                return 0
            }
            if token.decimals >= amount.count {
                let prepend = String(repeating: "0", count: token.decimals - amount.count + 1)
                amount = prepend + amount
            }
            index = amount.index(amount.endIndex, offsetBy: -token.decimals)
            amount.insert(".", at: index)
            result = Double(amount)
        }
        return result
    }

    static func == (lhs: Asset, rhs: Asset) -> Bool {
        return lhs.symbol == rhs.symbol
    }
}
