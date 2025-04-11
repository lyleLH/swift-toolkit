# Swift Toolkit

这是一个收集和整理Swift实用工具和扩展的代码库，旨在提供可复用的Swift代码组件。

## 功能模块

- **UI**: UI相关的扩展和组件
- **Networking**: 网络请求相关的工具
- **Utilities**: 通用工具函数
- **Extensions**: Swift标准库的扩展

## 安装

### Swift Package Manager

在您的`Package.swift`文件中添加以下依赖：

```swift
dependencies: [
    .package(url: "https://github.com/your-username/swift-toolkit.git", from: "1.0.0")
]
```

### Xcode

1. 在Xcode中打开您的项目
2. 选择 File > Add Packages...
3. 在搜索框中输入：`https://github.com/your-username/swift-toolkit.git`
4. 选择版本规则
5. 点击 Add Package

## 使用示例

```swift
import SwiftToolkit

// 使用UI扩展
let view = UIView()
view.addCornerRadius(10)

// 使用网络工具
let networkManager = NetworkManager()
networkManager.request(url: "https://api.example.com") { result in
    // 处理结果
}

// 使用工具函数
let date = Date()
let formattedDate = date.formattedString()
```

## 贡献

欢迎提交Pull Request来贡献您的代码。请确保：

1. 代码符合Swift风格指南
2. 添加适当的文档注释
3. 包含单元测试
4. 更新README.md（如果需要）

## 许可证

MIT License

## API Key Setup

To use the Google Fonts API, you need to set up your API key:

1. Get your Google Fonts API key from the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a `.env` file in the project root directory
3. Add your API key to the `.env` file:
   ```
   GOOGLE_FONTS_API_KEY=your_api_key_here
   ```

## Security Notice

Never commit your actual API key to the repository. The `.env` file is already in `.gitignore` to prevent accidental commits.

## Development

1. Clone the repository
2. Copy `.env.example` to `.env` and add your API key
3. Build and run the project

## 环境变量设置

### 开发环境设置

1. 复制环境变量模板文件：
   ```bash
   cp .env.example .env
   ```

2. 编辑 `.env` 文件，添加您的 API keys：
   ```
   GOOGLE_FONTS_API_KEY=your_api_key_here
   ```

### Xcode 设置

1. 在 Xcode 中设置环境变量：
   - 选择您的 target
   - 进入 "Edit Scheme"
   - 选择 "Run" 配置
   - 在 "Arguments" 标签页的 "Environment Variables" 部分添加：
     ```
     GOOGLE_FONTS_API_KEY=your_api_key_here
     ```

### CI/CD 设置

如果您使用 CI/CD 服务，请在相应的平台设置环境变量：

- GitHub Actions: 在仓库的 Settings > Secrets 中添加
- GitLab CI: 在 Settings > CI/CD > Variables 中添加
- Bitrise: 在 Workflow Editor > Env Vars 中添加

## 安全注意事项

1. 永远不要提交包含实际 API key 的 `.env` 文件
2. 定期轮换您的 API keys
3. 使用最小权限原则设置 API key 的访问权限
4. 在开发和生产环境使用不同的 API keys

## Development

1. 克隆仓库
2. 设置环境变量
3. 构建和运行项目 