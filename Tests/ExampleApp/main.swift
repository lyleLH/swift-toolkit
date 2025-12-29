import Foundation
import SwiftToolkit

// 测试字符串工具
func testStringUtilities() {
    print("\n测试字符串工具:")
    let email = "test@example.com"
    let phone = "13800138000"
    print("邮箱验证: \(email.isValidEmail)")
    print("手机号验证: \(phone.isValidChinesePhoneNumber)")
    print("拼音转换: \("你好".pinyin)")
    print("MD5加密: \("password".md5)")
}

// 测试日期工具
func testDateUtilities() {
    print("\n测试日期工具:")
    let date = Date()
    print("当前日期: \(date.formattedString())")
    print("年份: \(date.year)")
    print("月份: \(date.month)")
    print("日期: \(date.day)")
    print("是否是今天: \(date.isToday)")
    print("开始时间: \(date.startOfDay.formattedString())")
    print("结束时间: \(date.endOfDay.formattedString())")
}

// 测试网络工具
@MainActor
func testNetworkTools() async {
    print("\n测试网络工具:")
    let networkManager = NetworkManager.shared
    
    await withCheckedContinuation { continuation in
        networkManager.get(url: "https://api.github.com/users/apple") { (result: Result<GitHubUser, NetworkError>) in
            switch result {
            case .success(let user):
                print("网络请求成功:")
                print("用户名: \(user.login)")
                print("ID: \(user.id)")
                print("仓库数: \(user.publicRepos)")
                print("关注者: \(user.followers)")
            case .failure(let error):
                print("网络请求失败: \(error)")
            }
            continuation.resume()
        }
    }
}

// 运行所有测试
print("开始测试Swift Toolkit...")
testStringUtilities()
testDateUtilities()

// 运行异步测试
await testNetworkTools()
