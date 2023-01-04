//
//  main.swift
//  ZettelURLHandler
//
//  Created by Joachim Bargsten on 04/01/2023.
//

import Foundation
import SwiftUI
import AppKit
import UserNotifications

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
