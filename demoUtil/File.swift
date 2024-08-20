//import UIKit
//
//class ViewController: UIViewController {
//    
//    let label = UILabel()
//    let fetchDataButton = UIButton(type: .system)
//    let displayDataButton = UIButton(type: .system)
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupUI()
//    }
//    
//    // 设置界面元素F
//    func setupUI() {
//        // 设置标签
//        label.frame = CGRect(x: 20, y: 100, width: 280, height: 200)
//        label.textAlignment = .center
//        label.numberOfLines = 0 // 设置为0表示可以有无限行
//        label.lineBreakMode = .byWordWrapping
//        label.text = "Data will be displayed here"
//        view.addSubview(label)
//        
//        // 设置获取数据按钮
//        fetchDataButton.frame = CGRect(x: 20, y: 320, width: 120, height: 50)
//        fetchDataButton.setTitle("Fetch Data", for: .normal)
//        fetchDataButton.addTarget(self, action: #selector(fetchData), for: .touchUpInside)
//        view.addSubview(fetchDataButton)
//        
//        // 设置展示数据按钮
//        displayDataButton.frame = CGRect(x: 180, y: 320, width: 120, height: 50)
//        displayDataButton.setTitle("Display Data", for: .normal)
//        displayDataButton.addTarget(self, action: #selector(displayData), for: .touchUpInside)
//        view.addSubview(displayDataButton)
//    }
//    
//    // 请求数据并写入JSON文件
//    @objc func fetchData() {
//        if let url = URL(string: "https://ma2dev-timecheck.lvdev.jp/timecheck.php") {
//            fetchJSONData(from: url) { data in
//                if let jsonData = data {
//                    let jsonFilePath = self.getJSONFilePath()
//                    self.writeJSONDataToFile(filePath: jsonFilePath, jsonData: jsonData)
//                    self.printJSONData(jsonData) // 打印 JSON 数据
//                } else {
//                    print("Failed to fetch or write JSON data.")
//                }
//            }
//        }
//    }
//    
//    // 从JSON文件中读取数据并显示在标签上
//    @objc func displayData() {
//        let jsonFilePath = getJSONFilePath()
//        do {
//            let jsonData = try Data(contentsOf: jsonFilePath)
//            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
//                // 对字典的键进行排序
//                let sortedKeys = jsonObject.keys.sorted()
//                // 构建排序后的键值对字符串
//                let sortedJsonObject = sortedKeys.reduce("") { (result, key) -> String in
//                    return result + "\(key): \(jsonObject[key]!)\n"
//                }
//                
//                DispatchQueue.main.async {
//                    self.label.text = sortedJsonObject
//                }
//            } else {
//                print("Failed to convert JSON data to dictionary.")
//            }
//        } catch {
//            print("Failed to read JSON file: \(error.localizedDescription)")
//        }
//    }
//    
//    // 获取沙盒 Document 目录路径
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//    
//    // 获取 JSON 文件的路径
//    func getJSONFilePath() -> URL {
//        let documentsDirectory = getDocumentsDirectory()
//        return documentsDirectory.appendingPathComponent("data.json")
//    }
//    
//    // 将数据写入 JSON 文件的函数
//    func writeJSONDataToFile(filePath: URL, jsonData: Data) {
//        do {
//            try FileManager.default.createDirectory(at: filePath.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
//            try jsonData.write(to: filePath)
//            print("JSON file content written successfully.")
//        } catch {
//            print("Failed to write JSON file content: \(error.localizedDescription)")
//        }
//    }
//    
//    // 从网络请求获取 JSON 数据的函数
//    func fetchJSONData(from url: URL, completion: @escaping (Data?) -> Void) {
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else {
//                print("Failed to fetch JSON data: \(error?.localizedDescription ?? "No data")")
//                completion(nil)
//                return
//            }
//            completion(data)
//        }
//        task.resume()
//    }
//    
//    // 打印 JSON 数据的函数
//    func printJSONData(_ jsonData: Data) {
//        do {
//            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
//                print("JSON Data: \(jsonObject)")
//            } else {
//                print("Failed to convert JSON data to dictionary.")
//            }
//        } catch {
//            print("Failed to parse JSON data: \(error.localizedDescription)")
//        }
//    }
//}
