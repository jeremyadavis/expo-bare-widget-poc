//
//  CountdownBundle.swift
//  Countdown
//
//  Created by Jeremy Davis on 12/1/22.
//

import WidgetKit
import SwiftUI

@main
struct CountdownBundle: WidgetBundle {
    var body: some Widget {
        Countdown()
        CountdownLiveActivity()
    }
}
