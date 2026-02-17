//
//  AccessTokenRefresher.swift
//  Plantory
//
//  Created by 주민영 on 7/30/25.
//

import Foundation
import Alamofire

final class AccessTokenRefresher: @unchecked Sendable, RequestInterceptor {

    private let tokenProviding: TokenProviding

    init(tokenProviding: TokenProviding) {
        self.tokenProviding = tokenProviding
    }

    

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        if let accessToken = tokenProviding.accessToken {
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(urlRequest))
    }
<
    /*
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard request.retryCount < 1,
              let response = request.task?.response as? HTTPURLResponse,
              [401].contains(response.statusCode) else {
            return completion(.doNotRetry)
        }
        
        requestToRetry.append(completion)
        if !isRefreshing {
            isRefreshing = true
            tokenProviding.refreshToken { [weak self] newToken, error in
                guard let self = self else { return }
                self.isRefreshing = false
                
                let result: RetryResult

                
                self.requestToRetry.forEach { $0(result) }
                self.requestToRetry.removeAll()
            }
        }
    }
     */

    /*

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest

        if let token = tokenProviding.accessToken, !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }


    */
 
    
    
   
    /*
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard request.retryCount < 1,
              let response = request.task?.response as? HTTPURLResponse,
              [401, 404].contains(response.statusCode) else {
            return completion(.doNotRetry)
        }
        
        requestToRetry.append(completion)
        if !isRefreshing {
            isRefreshing = true
            tokenProviding.refreshToken { [weak self] newToken, error in
                guard let self = self else { return }
                self.isRefreshing = false
                let result = error == nil ? RetryResult.retry : RetryResult.doNotRetryWithError(error!)
                self.requestToRetry.forEach { $0(result) }
                self.requestToRetry.removeAll()
            }
        }
    }
     */

     



        completion(.success(request))
    }
     


}
