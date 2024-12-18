//
//  ContentView.swift
//  CLE
//
//  Created by 神宮一敬 on 2024/12/13.
//
import CoreBluetooth
import SwiftUI

struct ContentView: View {
    
    let peripheralManager = PeripheralManager()
    let centralManager = CentralManager()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            
            peripheralManager.startAdvertising()
            centralManager.startScanning()
            print("起動しました")
        }
    }
}

#Preview {
    ContentView()
}
