//
//  Card.swift
//  CardGame
//
//  Created by Daheen Lee on 26/06/2019.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

class Card: CustomStringConvertible {
    
    // 4가지 기호 - case 별로 처리하기에 적절하다고 판단하여 enum 으로 구현
    enum Suit: Character, CustomStringConvertible, CaseIterable {
        case spade   = "\u{2660}\u{FE0F}" //♠︎
        case club    = "\u{2663}\u{FE0F}" //♣︎
        case heart   = "\u{2764}\u{FE0F}" //♥︎
        case diamond = "\u{2666}\u{FE0F}" //♦︎
        
        var description: String {
            return "\(self.rawValue)"
        }
    }
    
    // 1~13 - 케이스 유한집합이므로 enum 선택
    // class 시도해보았으나, 범위 확인하는 처리로 인해 복잡도 증가했음
    enum Rank: Int, CustomStringConvertible, CaseIterable {
        case ace = 1
        case two, three, four, five, six, seven, eight, nine, ten
        case jack, queen, king
        
        var description: String {
            switch self {
            case .ace:
                return "A"
            case .jack:
                return "J"
            case .queen:
                return "Q"
            case .king:
                return "K"
            default:
                return "\(self.rawValue)"
            }
        }
    }
    
    let rank: Rank
    let suit: Suit
    
    init(_ rank: Rank, of suit: Suit) {
        self.suit = suit
        self.rank = rank
    }
    
    var description: String {
        return "\(suit)\(rank)"
    }
}

extension Card.Rank: Comparable {
    static func < (lhs: Card.Rank, rhs: Card.Rank) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

extension Card.Rank {
    func next() -> Card.Rank? {
        guard let next = Card.Rank(rawValue: self.rawValue + 1) else {
            return nil
        }
        return next
    }
}
