//
//  APIManager.swift
//  ShaadiTest
//
//  Created by Ramesh Siddanavar on 01/10/20.
//

import Foundation

class APIManager: NSObject {
    
    static let sharedInstance = APIManager()
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    //MARK:- GET
    func makeGETRequest<T:Codable>(url:String, type:T.Type, completionHandler:@escaping (_ error:Error?, _ myObj:T?) -> ()) {
        guard let url = URL(string:url) else { fatalError() }
        
        var urlReq = URLRequest.init(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        urlReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReq.addValue("application/json", forHTTPHeaderField: "Accept")
        urlReq.httpMethod = "GET"
        print("API URL :-> ",urlReq.description)
        
        URLSession.shared.dataTask(with: urlReq) { data, response, error in
            guard let data = data else { return }
            do
            {   let newObj = try JSONDecoder().decode(T.self, from: data)
                completionHandler(nil, newObj)
                print("Optimized API Data... Done")
            } catch {
                completionHandler(error, nil)
                print("Error Decoding.... :(")
                print(String.init(data: data, encoding: .utf8) as Any)
                return
            }
        }.resume()
    }
    
    //MARK:- POST
    func makePOSTRequest<T:Codable>(api:String, _ parameters: [String: Any], type:T.Type, completionHandler:@escaping (_ error:Error?,_ response:URLResponse?,_ data:Data?,_ myObj:T?) -> ()) {
        
        let theJSONData =  try? JSONSerialization.data(withJSONObject: parameters)
        
        if let dat = theJSONData {
            let json = String(data: dat, encoding: .utf8)
            guard let url = URL(string: api) else { fatalError() }
            print("API URL :-> ",url.description)
            print("POST Req:-> ",json as Any)
            var urlReq = URLRequest.init(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)//reloadRevalidatingCacheData
            urlReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlReq.addValue("application/json", forHTTPHeaderField: "Accept")
            urlReq.httpMethod = "POST"
            urlReq.httpBody = dat
            
            URLSession.shared.dataTask(with: urlReq) { data, response, error in
                guard let data = data else { return }
                do
                {   let newObj = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(nil, nil,nil, newObj)
                    print("Optimized API Data... Done")
                    
                } catch {
                    completionHandler(error,response,data, nil)
                    print("Error Decoding.... :(")
                    
                    print(String.init(data: data, encoding: .utf8) as Any)
                    return
                }
            }.resume()
        }
    }
    
}
