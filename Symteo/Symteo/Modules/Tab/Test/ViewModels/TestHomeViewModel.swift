//
//  TestHomeViewModel.swift
//  Symteo
//
//  Created by 김지우 on 1/13/26.
//

import Foundation

@Observable
final class TestHomeViewModel {
    var testList: [TestModel] = [
        TestModel(icon:"depressionlogo", title:"우울·불안 측정",subtitle:"내 마음속에 숨은 비구름을 확인해봐요.",testtime: "2-4 소요"),
        TestModel(icon:"stresslogo", title:"스트레스 측정", subtitle: "어깨에 짊어진 무거운 짐을 내려놓을 시간", testtime: "5-8분 소요"),
        TestModel(icon:"typelogo", title:"성향 검사", subtitle: "나의 애착유형과 성향을 알아가는 시간", testtime:"5-8분 소요")
    ]
}


