//
//  Utilities.swift
//  OnlineEyeTest
//
//  Created by Keane Hui on 24/4/2022.
//

import Foundation
import SwiftUI

func getDistanceStatus(_ distance: Int) -> DistanceStatus {
    switch distance {
    case 0:
        return .missing
    case 1...(RANGE_L-1):
        return .tooClose
    case RANGE_L...RANGE_R:
        return .valid
    case (RANGE_R+1)...:
        return .tooFar
    default:
        return .missing
    }
}

func getDistanceDelta(_ distance: Int) -> Int {
    if distance >= RANGE_L && distance <= RANGE_R {
        return 0
    } else if distance < RANGE_L {
        return distance - RANGE_L
    } else if distance > RANGE_R {
        return distance - RANGE_R
    } else {
        return 0
    }
}

func isDistanceDeltaSmall(_ distance: Int) -> Bool {
    return abs(getDistanceDelta(distance)) <= WARNING_ZONE_OUT
}

func getDistanceColor(_ distance: Int) -> Color {
    if distance == 0 {
        return Color.blue
    }
    if distance < RANGE_L || distance > RANGE_R {
        let delta: Int = min(abs(distance-RANGE_L), abs(distance-RANGE_R))
        if delta < WARNING_ZONE_OUT {
            return Color.orange
        } else {
            return Color.red
        }
    }
    if distance >= RANGE_L && distance <= RANGE_R {
        let delta: Int = min(abs(distance-RANGE_L), abs(distance-RANGE_R))
        if delta > WARNING_ZONE_IN {
            return Color.green
        } else {
            return Color.yellow
        }
    }
    return Color.blue
}

enum DistanceStatus: String {
    case missing
    case tooClose
    case valid
    case tooFar
}
