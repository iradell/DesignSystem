//
//  TestView.swift
//  DesignSystem
//
//  Created by IRADELL on 15.10.25.
//

import SwiftUI

struct TestView: View {
    // Force unwrap test
    let optionalString: String?
    var forced: String { optionalString! }

    var body: some View {
        Text("Forced value length")
    }
}
