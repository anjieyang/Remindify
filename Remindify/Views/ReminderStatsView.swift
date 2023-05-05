//
//  ReminderStatsView.swift
//  Remindify
//
//  Created by digmouse on 2023-05-04.
//

import SwiftUI

struct ReminderStatsView: View {
    let icon: String
    let title: String
    var count: Int?
    var iconColor: Color = .blue
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    ZStack {
                        Image(systemName: icon)
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(iconColor)
                            .background(.white)
                            .font(.title)
                            .clipShape(Circle())
                    }
                    Text(title)
                        .opacity(0.8)
                        .foregroundColor(.white)
                        .bold()
                }
                
                Spacer()
                
                if let count {
                    Text("\(count)")
                        .font(.largeTitle)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .border(.gray)
            .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
        }
    }
}

struct ReminderStatsView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderStatsView(icon: "02.circle.fill", title: "Today", count: 10)
    }
}
