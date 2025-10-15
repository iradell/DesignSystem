//
//  TestView.swift
//  DesignSystem
//
//  Created by IRADELL on 15.10.25.
//

import SwiftUI

struct TestView: View {
    // Force unwrap test
    let optionalString: String? = nil
    var forced: String { optionalString! }

    var body: some View {
        Text("Forced value length")
    }
}
