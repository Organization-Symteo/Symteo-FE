//
//  APIMaager.swift
//  Symteo
//
//  Created by 박병선 on 1/29/26.
//
import Foundation
import Moya
import Alamofire

@MainActor
class APIManager: @unchecked Sendable {
    static let shared = APIManager()
    
    private let tokenProvider: TokenProviding
    private let accessTokenRefresher: AccessTokenRefresher
    private let session: Session
    private let loggerPlugin: PluginType
    
    private init() {
        tokenProvider = TokenProvider()
        let accessToken = tokenProvider.accessToken
        accessTokenRefresher = AccessTokenRefresher(
                 accessToken: accessToken
             )
        session = Session(interceptor: accessTokenRefresher)
        loggerPlugin = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    }
    
    /// 실제 API 요청용 MoyaProvider
    public func createProvider<T: TargetType>(for targetType: T.Type) -> MoyaProvider<T> {
        return MoyaProvider<T>(
            session: session,
            plugins: [loggerPlugin]
        )
    }
    
    /// 테스트용 MoyaProvider
    public func testProvider<T: TargetType>(for targetType: T.Type) -> MoyaProvider<T> {
        return MoyaProvider<T>(
            stubClosure: MoyaProvider.immediatelyStub,
            plugins: [loggerPlugin]
        )
    }
}

extension APIManager {
    /// 토큰 없이 쓰는 Provider (presigned 업로드에서 사용)
    public func createNoAuthProvider<T: TargetType>(for targetType: T.Type) -> MoyaProvider<T> {
        let noInterceptSession = Session()
        return MoyaProvider<T>(
            session: noInterceptSession,
            plugins: [loggerPlugin]
        )
    }
}
