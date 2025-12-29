import SwiftUI
import UIKit
import SwiftToolkit
import SwiftToolkitUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                List {
                    Section(header: Text("Basic Components")) {
                        NavigationLink("HUD Examples") {
                            HUDExampleWrapper()
                                .ignoresSafeArea()
                        }
                        NavigationLink("Alert Examples") {
                            AlertsExampleWrapper()
                                .ignoresSafeArea()
                        }
                        NavigationLink("Button Examples") {
                            ButtonsExampleWrapper()
                                .ignoresSafeArea()
                        }
                    }
                }
                .navigationTitle("SwiftToolkit Examples")
            }
        }
    }
}

struct HUDExampleWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> HUDExampleViewController {
        return HUDExampleViewController()
    }
    
    func updateUIViewController(_ uiViewController: HUDExampleViewController, context: Context) {}
}

struct AlertsExampleWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AlertsExampleViewController {
        return AlertsExampleViewController()
    }
    
    func updateUIViewController(_ uiViewController: AlertsExampleViewController, context: Context) {}
}

struct ButtonsExampleWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ButtonsExampleViewController {
        return ButtonsExampleViewController()
    }
    
    func updateUIViewController(_ uiViewController: ButtonsExampleViewController, context: Context) {}
}
