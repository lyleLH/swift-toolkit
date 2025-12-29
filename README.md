# Swift Toolkit

这是一个收集和整理Swift实用工具和扩展的代码库，旨在提供可复用的Swift代码组件。

## 功能模块

- **SwiftToolkit**: 核心逻辑库，包含 Utilities, Extensions, Networking 等。
- **SwiftToolkitUI**: UI 组件库，依赖 UIKit，包含 HUD, Alert, Custom Buttons, Extensions 等。

## 安装

### Swift Package Manager

在您的`Package.swift`文件中添加以下依赖：

```swift
dependencies: [
    .package(url: "https://github.com/lyleLH/swift-toolkit.git", from: "1.0.0")
]
```

然后将 `SwiftToolkit` 或 `SwiftToolkitUI` 添加到您的 target 依赖中。

### Xcode

1. 在Xcode中打开您的项目
2. 选择 File > Add Packages...
3. 在搜索框中输入：`https://github.com/lyleLH/swift-toolkit.git`
4. 选择版本规则 (例如 1.0.0)
5. 点击 Add Package

## 本地开发与测试 (Example App)

本项目包含一个可以直接运行的本地示例工程 `Example.swiftpm`，用于测试 UI 组件和快速迭代开发。

### 如何运行

1. 确保已安装 Xcode 14+。
2. 双击项目根目录下的 `Example.swiftpm` 文件夹，或在终端运行：
   ```bash
   open Example.swiftpm
   ```
3. Xcode 打开后，选择模拟器并运行 (Cmd+R)。
4. 您将看到一个包含 HUD、Alert、Buttons 等演示页面的 App。

这个示例工程通过本地路径引用了 `swift-toolkit`，因此您在 `Sources` 目录下的任何修改都会立即反映在示例 App 中。

## 使用示例

### UI (SwiftToolkitUI)

```swift
import SwiftToolkitUI

// 显示 HUD
HUD.showLoading("Loading...")
HUD.showSuccess("Done!")

// 显示 Alert
let alert = AlertViewController.makeSuccessAlert(title: "Success", message: "Operation completed")
present(alert, animated: true)

// 创建自定义按钮
let btn = UIButton.makeConfirmationButton(title: "Confirm", emoji: "✅", style: .primary)
```

### Core (SwiftToolkit)

```swift
import SwiftToolkit

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
