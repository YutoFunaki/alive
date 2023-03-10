//
//  FormattedDate.swift
//  alive
//
//  Created by čšć¨ĺć on 2023/01/12.
//

import SwiftUI

struct FormattedDate: View {
    var selectedDate: Date
    var omitTime: Bool = false
    var body: some View {
        Text(selectedDate.formatted(date: .abbreviated, time:
                                        omitTime ? .omitted : .standard))
        .font(.system(size: 20))
        .bold()
        .foregroundColor(Color.gray)
        .padding()
        .animation(.spring(), value: selectedDate)
        .frame(width: 500)
    }
}

struct FormattedDate_Previews: PreviewProvider {
    static var previews: some View {
        FormattedDate(selectedDate: Date())
    }
}
