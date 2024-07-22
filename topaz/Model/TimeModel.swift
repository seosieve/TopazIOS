//
//  TimeModel.swift
//  topaz
//
//  Created by 서충원 on 2021/12/29.
//

import UIKit

struct Time {
    func convertTime(_ currentTime :Int) -> String {
        switch currentTime {
        case 8..<20:
            return "Morning"
        case 20...21:
            return "Evening"
        default:
            return "Night"
        }
    }
}
