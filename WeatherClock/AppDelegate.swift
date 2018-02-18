//
//  AppDelegate.swift
//  WeatherClock
//
//  Created by Norm Barnard on 2/18/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let rootPopover = NSPopover()
    
    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name("icon-statusbar"))
            button.action = #selector(toggleRootPopover(_:))
        }
        rootPopover.contentViewController = RootViewController()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func printQuote(_ sender: NSStatusBarButton) {
        let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
        let quoteAuthor = "Mark Twain"       
        print("\(quoteText) — \(quoteAuthor)")
    }

    @objc private func toggleRootPopover(_ sender: Any?) {
        if rootPopover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    private func showPopover(_ sender: Any?) {
        if let button = statusItem.button {
            rootPopover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    private func closePopover(_ sender: Any?) {
        rootPopover.performClose(sender)
    }
    
}

