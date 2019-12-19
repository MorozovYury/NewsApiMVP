//
//  NetWorkService.swift
//  NewsApi
//
//  Created by Administrator on 19.12.2019.
//  Copyright © 2019 yurymorozov. All rights reserved.
//

import Foundation

protocol NetWorkServiceProtocol {
    func getNews(completion: @escaping (Result<[Articles]?, Error>) -> ())
    func fetchImage(newsImageURL: URL, completion: @escaping(Result<Data?, Error>) -> ())
}

class NetWorkService: NetWorkServiceProtocol {
    
    private let apiKey = "b59bc1f13f884301a259ebc4a7c68af2"
    
    func getNews(completion: @escaping (Result<[Articles]?, Error>) -> ()) {
        
        guard let urlLink = URL(string: "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=\(apiKey)") else { return }
        
        var request = URLRequest(url: urlLink)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("url - \(urlLink)")
            
            var fetchedStatusCode = 0
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                fetchedStatusCode = httpResponse.statusCode
            }
            
            guard let statusCode = response as? HTTPURLResponse, (200..<300).contains(statusCode.statusCode) else {
                print("Проблема с подключением к серверу")
                let fetchedError = NSError(domain: "", code: fetchedStatusCode, userInfo: [NSLocalizedDescriptionKey : "Проблема с подключением к серверу"])
                completion(.failure(fetchedError))
                return
            }
            if error != nil || data == nil {
                print("Проблема с загрузкой данных")
                let fetchedError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Проблема с загрузкой данных"])
                completion(.failure(fetchedError))
                return
            } else {
                DispatchQueue.main.async {
                    do {
                        let fetchedResult = try JSONDecoder().decode(NewsModel.self, from: data!)
                        //print("Декодированные данные: - \(fetchedResult)")
                        if fetchedResult.status == "ok" {
                            completion(.success(fetchedResult.articles))
                        } else {
                            print("Ошибшка при получении данных")
                            let fetchedError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Ошибшка при получении данных - \(String(describing: fetchedResult.message))"])
                            completion(.failure(fetchedError))
                        }
                    } catch let fetchedError {
                        print("Ошибшка при декодировании \(fetchedError)")
                        completion(.failure(fetchedError))
                    }
                }
            }
        }
        task.resume()
    }
    
    func fetchImage(newsImageURL: URL, completion: @escaping (Result<Data?, Error>) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            let contentURL = try? Data(contentsOf: newsImageURL)
            DispatchQueue.main.async {
                if let imageData = contentURL {
                    completion(.success(imageData))
                } else {
                    let fetchedError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Проблема с загрузкой фото"])
                    completion(.failure(fetchedError))
                }
            }
        }
    }
}
