//
//  RKPageView.swift
//  RKCalendar
//
//  Adapted by Ringo Wathelet on 2020/01/11.
//  from code gist of:
//  Created by Aleksey Ozerov on 24.10.2019.
//  Copyright © 2019 Aleksey Ozerov. All rights reserved.


import SwiftUI
import Foundation


public struct RKPageView<Content: View & Identifiable>: View {
    
    @ObservedObject var rkManager: RKManager
    
    var pages: [Content]
    
    @State private var index: Int = 0
    @State private var offset: CGFloat = 0
    @State private var isGestureActive: Bool = false
    
    public var body: some View {
        self.rkManager.isVertical ? AnyView(self.verticalView) : AnyView(self.horizontalView)
    }
    
    var verticalView: some View {
        GeometryReader { geometry in
            ScrollView (.vertical) {
                VStack {
                    ForEach(self.pages) { page in
                        page.frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
            }
            .content.offset(y: self.isGestureActive ? self.offset : -geometry.size.height * CGFloat(self.index))
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
            .simultaneousGesture(DragGesture()
            .onChanged({ value in
                self.isGestureActive = true
                self.offset = value.translation.height - geometry.size.height * CGFloat(self.index)
            })
                .onEnded({ value in
                    if abs(value.predictedEndTranslation.height) >= geometry.size.height / 2 {
                        var nextIndex: Int = (value.predictedEndTranslation.height < 0) ? 1 : -1
                        nextIndex += self.index
                        self.index = nextIndex.keepIndexInRange(min: 0, max: self.pages.endIndex - 1)
                    }
                    withAnimation { self.offset = -geometry.size.height * CGFloat(self.index) }
                    DispatchQueue.main.async { self.isGestureActive = false }
                })
            )
        }.onAppear(perform: { self.index = self.todayIndex() })
    }
    
    var horizontalView: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                HStack {
                    ForEach(self.pages) { page in
                        page.frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
            }
            .content.offset(x: self.isGestureActive ? self.offset : -geometry.size.width * CGFloat(self.index))
            .frame(width: geometry.size.width, height: nil, alignment: .leading)
            .simultaneousGesture(DragGesture()
            .onChanged({ value in
                self.isGestureActive = true
                self.offset = value.translation.width - geometry.size.width * CGFloat(self.index)
            })
                .onEnded({ value in
                    if abs(value.predictedEndTranslation.width) >= geometry.size.width / 2 {
                        var nextIndex: Int = (value.predictedEndTranslation.width < 0) ? 1 : -1
                        nextIndex += self.index
                        self.index = nextIndex.keepIndexInRange(min: 0, max: self.pages.endIndex - 1)
                    }
                    withAnimation { self.offset = -geometry.size.width * CGFloat(self.index) }
                    DispatchQueue.main.async { self.isGestureActive = false }
                })
            )
        }.onAppear(perform: { self.index = self.todayIndex() })
    }
    
    func todayIndex() -> Int {
        if self.rkManager.isBetweenMinAndMaxDates(date: Date()) {
            return rkManager.calendar.dateComponents([.month], from: rkManager.minimumDate, to: Date()).month!
        } else {
            return 0
        }
    }
    
}

extension Int {
    func keepIndexInRange(min: Int, max: Int) -> Int {
        switch self {
        case ..<min: return min
        case max...: return max
        default: return self
        }
    }
}

