//
//  APIManager.swift
//  Demo
//
//  Created by Maitri Dutta Banik on 28/12/20.
//

import Foundation

typealias APIResponseHandler = (Result<Codable, Error>) -> Void

class APImanager {
    private static let productPath = "http://vouchme.co/api/quikbox/getStoreProducts?store_id=132"
    private static let token = " Basic eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjRmMzU1YTVkOTJmZDgzODU4Zjk3NjM4Y2MzYWZkZTE2NjRmMWUyYzY2NzBkYzY0YzE3ZDU0MWIxZmEyMTIzZjBjNjBmNDc0MmRmMzMxNGMwIn0.eyJhdWQiOiIzIiwianRpIjoiNGYzNTVhNWQ5MmZkODM4NThmOTc2MzhjYzNhZmRlMTY2NGYxZTJjNjY3MGRjNjRjMTdkNTQxYjFmYTIxMjNmMGM2MGY0NzQyZGYzMzE0YzAiLCJpYXQiOjE1OTAxNjM1NTMsIm5iZiI6MTU5MDE2MzU1MywiZXhwIjoxNjIxNjk5NTUzLCJzdWIiOiIyMyIsInNjb3BlcyI6W119.z0vUSAj-vDS2r1uyk5o_-B0Jvut3ZSMmqoTlKgasMtIbX9xzhupN0TDQ_TbU-od-hmjB9J4rF2b1sQC9xI1gYouUEAFAN7sXRlQB9NCEiZXOhtIAgYV_hUre83Ea-0XUVRYQWoEAqcClLjTjCN3c2d1uYVBTtzyvDBRv5mKNcl1CgLHWB8hk9HTM2C7CW4dGfCe5OpWOGG72arvA3lKlpf924ru3ZMs4zZSbbgT4kXmG5M98FUaNk-x9l30xXcEq6s-81b3eyVD_-TKSLi0dGsqbojmc8gadAoOdF7e8NREGGEG40oqldA0HoU3FoQ6jLZkqGqzLb25ic_tAIbrSw1jVZzqgLmQXbbE4ywylrdi9edqyXKTVgJujcjmH_uE5n9odTQj6GhDnk7QAjwPwCS5HgHh4LqfcD1DObPmvCm_v1XZoWG5qd1eYioxJ4ns1xLyfnX_1IOd878hjSL5hVIs2KhtyKhW4CyjBNmv4oswQE-Drcc-pnd2jorMFQm2IB2HhHbe40Wyfo3Qnce81uX_hL_mPtLtezl8THfscpksgcNL4R-6Qv38FO2-oGZjMhG6-Nm6I7Up-8mMEKRn2ikFKHJ3HLlcBKsEB9IsiKqRoWII4b3EOJ9BQwdS-97D2cOHekpbZN7GzTaJLoJ2yy9UfNpJrK1yeuZ4RZEo8CKs"
    
    
    static func getProducts(_ completion: @escaping APIResponseHandler) {
        guard let productUrl = URL(string: productPath) else { return }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var request = URLRequest(url: productUrl)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.networkServiceType = .background
        
        session.dataTask(with: request) { _d, _r, _e in
            guard _e == nil else {
                completion(.failure(_e!))
                return
            }
            guard let data = _d else {
                let error = NSError(domain: "app.Demo", code: 1, userInfo: [NSLocalizedDescriptionKey : "Data corrupt or nil"])
                completion(.failure(error))
                return
            }
            do {
                let parsedModel = try JSONDecoder().decode(ProductModel.self, from: data)
                completion(.success(parsedModel))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
