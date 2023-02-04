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
    
    @EnvironmentObject public var rkManager: RKManager
    
    public var pages: [Content]
    
    @State private var index: Int = 0
    @State private var offset: CGFloat = 0
    @State private var isGestureActive: Bool = false
    
    
    public var body: some View {
        rkManager.isVertical ? AnyView(verticalView) : AnyView(horizontalView)
    }
    
    public var verticalView: some View {
        GeometryReader { geometry in
            ScrollView (.vertical) {
                VStack {
                    ForEach(pages) { page in
                        page.frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
            }
            .content.offset(y: isGestureActive ? offset : geometry.size.height * CGFloat(index))
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
            .simultaneousGesture(DragGesture()
                                    .onChanged({ value in
                                        isGestureActive = true
                                        offset = value.translation.height - geometry.size.height * CGFloat(index)
                                    })
                                    .onEnded({ value in
                                        if abs(value.predictedEndTranslation.height) >= geometry.size.height / 2 {
                                            var nextIndex: Int = (value.predictedEndTranslation.height < 0) ? 1 : -1
                                            nextIndex += index
                                            index = nextIndex.keepIndexInRange(min: 0, max: pages.endIndex - 1)
                                        }
                                        withAnimation { offset = -geometry.size.height * CGFloat(index) }
                                        DispatchQueue.main.async { self.isGestureActive = false }
                                    })
            )
        }.onAppear(perform: { index = todayIndex() })
    }
    
    public var horizontalView: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 0) {
                    ForEach(pages) { page in
                        page.frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
            }
            .content.offset(x: isGestureActive ? offset : -geometry.size.width * CGFloat(index))
            .frame(width: geometry.size.width, height: nil, alignment: .leading)
            .simultaneousGesture(DragGesture()
                                    .onChanged({ value in
                                        isGestureActive = true
                                        offset = value.translation.width - geometry.size.width * CGFloat(index)
                                    })
                                    .onEnded({ value in
                                        if abs(value.predictedEndTranslation.width) >= geometry.size.width / 2 {
                                            var nextIndex: Int = (value.predictedEndTranslation.width < 0) ? 1 : -1
                                            nextIndex += index
                                            index = nextIndex.keepIndexInRange(min: 0, max: pages.endIndex - 1)
                                        }
                                        withAnimation { offset = -geometry.size.width * CGFloat(index) }
                                        DispatchQueue.main.async { self.isGestureActive = false }
                                    })
            )
        }.onAppear(perform: { index = todayIndex() })
    }
    
    public func todayIndex() -> Int {
        if rkManager.isBetweenMinAndMaxDates(date: Date()) {
            return 1 + rkManager.calendar.dateComponents([.month], from: rkManager.minimumDate, to: Date()).month!
        } else {
            return 0
        }
    }
    
}

public extension Int {
    func keepIndexInRange(min: Int, max: Int) -> Int {
        switch self {
        case ..<min: return min
        case max...: return max
        default: return self
        }
    }
}

