//
//  WebService.swift
//  FrameworkTest
//
//  Created by Uma B on 18/02/19.
//  Copyright © 2019 switchSoft. All rights reserved.
//

import Foundation
import UIKit

public enum MethodType {
    case GET,POST,PUT,DELETE,PATCH
    
   public func getMethodName() -> String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        case .PUT:
            return "PUT"
        case .DELETE:
            return "DELETE"
        case .PATCH:
            return "PATCH"
        }
    }
}
public typealias successBlock = (_ result:Any) -> Void
public typealias failureBlock = (_ errMsg:String) -> Void

    public func parseData(urlStr:String,parameters:Any?,method:MethodType,showHud:Bool ,successHandler:@escaping successBlock,failureHandler:@escaping failureBlock){
     //   self.showProgressiveHud(showHud: showHud)
        let url = URL(string: urlStr.replacingOccurrences(of: " ", with: "%20"))
        var request = URLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringCacheData
        request.httpMethod = method.getMethodName()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if(parameters != nil){
            request.httpBody = convertParametersToData(parms: parameters! as AnyObject) as Data?
        }
        callWebservice(request: request) { (result, errMsg) in
            if errMsg == nil {
                successHandler(result as Any)
            }else{
                failureHandler(errMsg! as String)
            }
     //       self.showProgressiveHud(showHud: false)
        }
    }

    public func callWebservice(request:URLRequest,completionBlock:@escaping (Any?,String?) -> () ){
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, err) in
            if err == nil {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    DispatchQueue.main.async {
                        completionBlock(result,nil)
                    }
                }
                catch let JSONError as NSError{
                    if let status = (response as! HTTPURLResponse).statusCode as? Int{
                        //FOR DELETE HTTP RESPONSE
                        if status == 204  {
                            DispatchQueue.main.async {
                                completionBlock(["success":true],nil)
                            }
                        }
                    }else{
                        completionBlock(nil,JSONError.localizedDescription)
                    }
                }
            }else{
                completionBlock(nil,err?.localizedDescription)
            }
            
            }.resume()
    }
    

    public func convertParametersToData(parms:AnyObject) -> NSData?{
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parms, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonStr = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
            return jsonStr!.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) as NSData?
        }catch let err as NSError{
            print("JSON ERROR\(err.localizedDescription)")
        }
        catch {
            // Catch any other errors
        }
        return nil
    }
    
    //Uploading an image
    public func uploadFile(_ urlStr:String,img:UIImage,successHandler:@escaping successBlock,failureHandler:@escaping failureBlock){
        let url = URL(string:urlStr)
        var request = URLRequest(url:url!)
        
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let image_data = img.jpegData(compressionQuality: 0.1)
        let body = NSMutableData()
        
        let fname = "apartment.jpg"
        let mimetype = "image/jpg"
        //define the data post parameter
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(image_data!)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        callWebservice(request: request) { (result, errMsg) in
            if errMsg == nil {
                successHandler(result  as! NSDictionary)
            }else{
                failureHandler(errMsg! as String)
            }
        }
    }
    public func createBodyWithParameters(parameters: [String: Any]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData()
        for (key, value) in parameters! {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
        }
        
        let filename = parameters!["type"] as! String
        let mimetype = "application/octet-stream"//"image/jpg"
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageDataKey as Data)
        
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        return body
    }
    public func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
//    class func showProgressiveHud (showHud : Bool){
//        DispatchQueue.main.async {
//            if showHud {
//                var ishudloading = false
//                for vw in (appDel.window?.subviews)!{
//                    if vw.isKind(of: (MBProgressHUD.self)){
//                        DispatchQueue.main.async {
//                            ishudloading = true
//                        }
//                    }
//                }
//                if !ishudloading{
//                    MBProgressHUD.showAdded(to: appDel.window!, animated: true)
//                }
//            }else{
//                MBProgressHUD.hide(for: appDel.window!, animated: true)
//            }
//        }
//    }

