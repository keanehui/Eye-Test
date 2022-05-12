//
//  ResultViewExplaination.swift
//  OnlineEyeTest
//
//  Created by Keane Hui on 27/4/2022.
//

import SwiftUI

struct ResultViewExplaination: View {
    var body: some View {
        VStack {
            Text("What does it mean? ")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .padding(.top, 40)
            Divider()
            ScrollView(.vertical) {
                text1
                text2
                text3
                text4
                text5
                text6
                text7
                text8
                text9
            }
        }
        .overlay(alignment: .top) {
            Capsule()
                .fill(.secondary)
                .frame(maxWidth: 40, maxHeight: 5)
                .padding(.top, 15)
        }
    }
}

struct ResultViewExplaination_Previews: PreviewProvider {
    static var previews: some View {
        ResultViewExplaination()
    }
}

extension ResultViewExplaination {
    
    private var text1: some View {
        VStack {
            Text("0.1")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("means you can see an image 10 meters away with normal vision, you need to be within 1 meter to see clearly. ")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
    
    private var text2: some View {
        VStack {
            Text("0.2")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("means you can see an image 5 meters away with normal vision, you need to be within 1 meter to see clearly. ")
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
    
    private var text3: some View {
        VStack {
            Text("0.28")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("means you can see an image 3.6 meters away with normal vision, you need to be within 1 meter to see clearly. ")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
    
    private var text4: some View {
        VStack {
            Text("0.4")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("means you can see the image 2.5 meters away with normal vision, you need to be within 1 meter to see clearly. ")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
    
    private var text5: some View {
        VStack {
            Text("0.5")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("means you can see an image 2 meters away with normal vision, you need to be within 1 meter to see clearly. ")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
    
    private var text6: some View {
        VStack {
            Text("0.66")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("means you can see the image 1.5 meters away with normal vision, you need to be within 1 meter to see clearly. ")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
    
    private var text7: some View {
        VStack {
            Text("0.8")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("means you can see the image 1.25 meters away with normal vision, you need to be within 1 meter to see clearly. ")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
    private var text8: some View {
        VStack {
            Text("1.0")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("means your eyes have normal vision level. ")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
    private var text9: some View {
        VStack {
            Text("1.3")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("means you can see the image within 1 meter under normal vision, you need to be 1.3 meters away to see clearly. ")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
    
}

extension Text {
    func customStyle() -> some View {
        return self.padding().frame(maxWidth: .infinity, alignment: .leading)
    }
}
