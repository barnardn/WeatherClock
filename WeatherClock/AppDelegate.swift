//
//  AppDelegate.swift
//  WeatherClock
//
//  Created by Norm Barnard on 2/18/18.
//  Copyright © 2018 NormBarnard. All rights reserved.
//

import Cocoa
import ReactiveCocoa
import ReactiveSwift


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var mainRouter: MainRouter?
    let dependenyContainer = MainStateContainer()
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let rootPopover = NSPopover()
    private lazy var rootEventMonitor: RootEventMonitor = {
        let monitor = RootEventMonitor(mask: [.leftMouseDown, .rightMouseDown]) {
            [weak self] event in
                if self?.rootPopover.isShown == true {
                    self?.closePopover(nil)
                }
            }
        return monitor
    }()
    
    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name("icon-statusbar"))
            button.action = #selector(toggleRootPopover(_:))
        }
        statusItem.menu = mainMenu()
        let _router = MainRouter(dependencyContainer: dependenyContainer)
        let rootViewModel = RootViewModel.init(dependenyContainer, router: _router)
        rootPopover.contentViewController = RootViewController(viewModel: rootViewModel)
        mainRouter = _router
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    private func mainMenu() -> NSMenu {
        let menu = NSMenu()
        let openItem = NSMenuItem(title: "Open", action: #selector(toggleRootPopover(_:)), keyEquivalent: "o")
        menu.addItem(openItem)
        menu.addItem(NSMenuItem.separator())
        let quitItem = NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        menu.addItem(quitItem)
        return menu
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
            rootEventMonitor.start()
        }
    }
    
    private func closePopover(_ sender: Any?) {
        rootPopover.performClose(sender)
        rootEventMonitor.stop()
    }
    
}

