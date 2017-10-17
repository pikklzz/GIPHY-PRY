//
//  ViewController.swift
//  GIPHY PRY
//
//  Created by Dim Mcrevi on 9/30/17.
//  Copyright © 2017 Dim Mcrevi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    public class GiphyClient {
        
        static let BaseURLString = "http://api.giphy.com/v1/gifs"
        
        open class Gif {
            
            /// The user discretion rating of a gif.
            public enum Rating: String {
                case Y = "y"
                case G = "g"
                case PG = "pg"
                case PG13 = "pg-13"
                case R = "r"
            }
            
            /**
             Different versions available for a gif.
             
             - FixedHeight: The gif with a fixed height of 200px.
             - FixedHeightDownsampled: The gif with a fixed height of 200px downsampled.
             - FixedWidth: The gif with a fixed width of 200px.
             - FixedWidthDownsampled: The gif with a fixed width of 200px downsampled.
             - Original: The original gif image.
             */
            public enum ImageVersion: String {
                case FixedHeight = "fixed_height"
                case FixedHeightDownsampled = "fixed_height_downsampled"
                case FixedWidth = "fixed_width"
                case FixedWidthDownsampled = "fixed_width_downsampled"
                case Original = "original"
            }
            
            /// The Giphy metadata of a gif.
            public struct ImageMetadata {
                
                /// The url of the gif.
                public let URL: Foundation.URL
                
                /// The width of the gif in pixels.
                public let width: Int
                
                /// The height of the gif in pixels
                public let height: Int
                
                /// The size of the gif in bytes, not all image versions include this.
                public let size: Int?
                
                /// The number of frames the gif has, not all image verions include this.
                public let frames: Int?
                
                /// URL to the gif in mp4 format, all image verions include this except for stills.
                public let mp4URL: Foundation.URL?
                
                init(dict: [String: Any]) {
                    
                    URL = Foundation.URL(string: dict["url"] as! String)!
                    width = ((dict["width"] as AnyObject).intValue)!
                    height = ((dict["height"] as AnyObject).intValue)!
                    size = (dict["size"] as AnyObject).intValue
                    frames = (dict["frames"] as AnyObject).intValue
                    if let mp4 = dict["mp4"] as? String {
                        mp4URL = Foundation.URL(string: mp4)
                    }
                    else {
                        mp4URL = nil
                    }
                }
            }
            
            /// The raw json data from giphy for the gif object.
            open let json: [String:AnyObject]
            
            /// The giphy id for the gif.
            open var id: String {
                return json["id"] as! String
            }
            
            /// The URL to the giphy page of the gif.
            open var giphyURL: URL {
                return URL(string: json["url"] as! String)!
            }
            
            /// User discretion rating of the gif.
            open var rating: Rating {
                return Rating(rawValue: json["rating"] as! String)!
            }
            
            init(json: [String:AnyObject]) {
                self.json = json
            }
            
            /**
             Get the metadata for an image type.
             
             - parameter type: The image type.
             
             - parameter still: Whether the metadata should be of a still of the image version. No stills are available for downsampled versions.
             
             :return: The image metadata for the image type.
             */
            public func gifMetadataForType(_ type: ImageVersion, still: Bool) -> ImageMetadata {
                var still = still
                
                if type == .FixedHeightDownsampled || type == .FixedWidthDownsampled {
                    still = false
                }
                if let images = json["images"] as? [String:[String:AnyObject]] {
                    let key = type.rawValue + (still ? "_still" : "")
                    let image = images[key]!
                    return ImageMetadata(dict: image)
                } else  {
                    
                    var dict: [String:Any] = [:]
                    let img = json["image_url"] as! URL
                    let noPath = img.deletingLastPathComponent()
                    
                    switch type {
                    case .FixedHeight:
                        dict["url"] = noPath.appendingPathComponent("200.gif") as AnyObject?
                        dict["width"] = Int(json["fixed_height_downsampled_width"] as! String)!
                        dict["height"] = 200 as AnyObject?
                        dict["mp4"] = noPath.appendingPathComponent("200.mp4") as AnyObject?
                        
                    case .FixedHeightDownsampled:
                        dict["url"] = noPath.appendingPathComponent("200_d.gif") as AnyObject?
                        dict["width"] = Int(json["fixed_height_downsampled_width"] as! String)!
                        dict["height"] = 200 as AnyObject?
                        dict["mp4"] = noPath.appendingPathComponent("200_d.mp4") as AnyObject?
                    case .FixedWidth:
                        dict["url"] = noPath.appendingPathComponent("200w.gif") as AnyObject?
                        dict["width"] = 200 as AnyObject?
                        dict["height"] = Int(json["fixed_width_downsampled_height"] as! String)!
                        dict["mp4"] = noPath.appendingPathComponent("200w.mp4") as AnyObject?
                    case .FixedWidthDownsampled:
                        dict["url"] = noPath.appendingPathComponent("200w_d.gif") as AnyObject?
                        dict["width"] = 200 as AnyObject?
                        dict["height"] = Int(json["fixed_width_downsampled_height"] as! String)!
                        dict["mp4"] = noPath.appendingPathComponent("200w_d.mp4") as AnyObject?
                    case .Original:
                        dict["url"] = img as AnyObject?
                        dict["width"] = Int(json["image_width"] as! String)!
                        dict["height"] = Int(json["image_height"] as! String)!
                        dict["mp4"] = json["image_mp4_url"]
                    }
                    
                    if still {
                        let url = dict["url"] as! URL
                        dict["url"] = url.deletingPathExtension().appendingPathComponent("_s.gif") as AnyObject?
                        dict.removeValue(forKey: "mp4")
                    }
                    
                    return ImageMetadata(dict: dict)
                }
            }
        }
        
        public struct Pagination {
            
            /// The count of the items retrieved.
            public let count: Int
            
            /// The offset of the first item.
            public let offset: Int
        }
        
        let urlSession: URLSession
        let apiKey: String
        
        public init(apiKey key: String, urlSessionConfig sessionConfig: URLSessionConfiguration) {
            urlSession = URLSession(configuration: sessionConfig)
            apiKey = key
        }
        
        func search(_ query: String, limit: UInt?, offset: UInt?, rating: Gif.Rating?, completionHandler: @escaping ([Gif]?, Pagination?, NSError?) -> Void) -> URLSessionDataTask {
            
            var params: [String : AnyObject] = ["q":query as AnyObject]
            
            if let lim = limit {
                params["limit"] = lim as AnyObject?
            }
            
            if let off = offset {
                params["offset"] = off as AnyObject?
            }
            
            if let rat = rating {
                params["rating"] = rat.rawValue as AnyObject?
            }
            
            return performRequest("search", params: params, completionHandler: completionHandler)
        }
        
        /**
         Perform a request for the trending gifs.
         
         - parameter limit: Limit the number of results per page. From 1 to 100. Optional.
         
         - parameter rating: The max user discretion rating of gifs. Optional.
         
         - parameter completionHandler: Completion handler called once the request is complete.
         
         - returns: An NSURLSessionDataTask for the request that has already been resumed.
         */
        open func trending(_ limit: UInt?, offset: UInt?, rating: Gif.Rating?, completionHandler: @escaping ([Gif]?, Pagination?, NSError?) -> Void) -> URLSessionDataTask {
            
            var params: [String : AnyObject] = [:]
            if let lim = limit {
                params["limit"] = lim as AnyObject?
            }
            if let rat = rating {
                params["rating"] = rat.rawValue as AnyObject?
            }
            if let off = offset {
                params["offset"] = off as AnyObject?
            }
            
            return performRequest("trending", params: params, completionHandler: completionHandler)
        }
        
        func performRequest(_ endpoint: String, params: [String: AnyObject]?, completionHandler: @escaping ([Gif]?, Pagination?, NSError?) -> Void) -> URLSessionDataTask {
            var params = params
            
            var urlString = (GiphyClient.BaseURLString as NSString).appendingPathComponent(endpoint)
            if params == nil {
                params = [:]
            }
            
            params!["api_key"] = apiKey as AnyObject?
            
            urlString += "?"
            
            var i = 0
            for (k, v) in params! {
                urlString += k.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                urlString += "="
                urlString += "\(v)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                if (i != params!.count - 1) {
                    urlString += "&"
                }
                i += 1
            }
            
            let dataTask = urlSession.dataTask(with: URL(string: urlString)!, completionHandler: {
                
                if $2 != nil {
                    
                    completionHandler(nil,nil, $2 as NSError?)
                    return
                }
                
                var error: NSError?
                
                var json: [String:AnyObject]
                do {
                    try json = JSONSerialization.jsonObject(with: $0!, options: []) as! [String: AnyObject]
                } catch let err as NSError {
                    completionHandler(nil, nil, err)
                    return
                }
                
                let meta: [String:AnyObject]? = json["meta"] as! [String:AnyObject]?
                
                let status: Int = meta!["status"] as! Int
                
                if status != 200 {
                    
                    error = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadServerResponse, userInfo: [NSLocalizedDescriptionKey: meta!["msg"] as! String])
                    
                    completionHandler(nil, nil, error)
                    return
                }
                
                var pagination: Pagination?
                if let p = json["pagination"] as? [String:Int] {
                    
                    pagination = Pagination(count: p["count"]!, offset: p["offset"]!)
                    
                }
                var gifs: [Gif] = []
                
                if let data = json["data"] as? [[String:AnyObject]] {
                    
                    for v in data {
                        gifs.append(Gif(json: v))
                    }
                } else if let data = json["data"] as? [String:AnyObject] {
                    gifs.append(Gif(json: data))
                }
                
                completionHandler(gifs, pagination, nil)
            })
            dataTask.resume()
            return dataTask
        }
        
    }


}

