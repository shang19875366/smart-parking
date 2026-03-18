# 智慧停车系统

一个基于Vue 3 + Supabase + Vercel的智慧停车系统，包含B端管理后台和C端客户端。

## 技术栈

- **前端**：Vue 3, Vite, Tailwind CSS, Element Plus, Vue Router
- **后端**：Supabase (PostgreSQL, Auth, Storage)
- **部署**：Vercel

## 功能特性

### B端管理后台
- 停车场位置、收费管理（经纬度坐标，地图显示）
- 用户上报的位置、收费管理
- 用户评论管理
- 位置、收费审核管理

### C端客户端
- 显示所有停车场位置和收费信息（地图显示）
- 根据用户位置查询附近5公里范围内的停车场
- 上报位置和收费数据
- 在位置和收费信息下方评论

## 快速开始

### 1. 克隆项目

```bash
git clone https://github.com/yourusername/smart-parking-system.git
cd smart-parking-system
```

### 2. 安装依赖

```bash
cd frontend
npm install
```

### 3. 配置Supabase

1. 访问 [Supabase](https://supabase.com/) 并创建一个新项目
2. 在项目设置中获取 `SUPABASE_URL` 和 `SUPABASE_ANON_KEY`
3. 在 `frontend/.env` 文件中配置这些值：

```env
VITE_SUPABASE_URL=YOUR_SUPABASE_URL
VITE_SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

### 4. 初始化数据库

1. 在Supabase控制台中，进入SQL编辑器
2. 执行 `supabase_migrations.sql` 文件中的SQL语句，创建所需的表结构

### 5. 本地开发

```bash
npm run dev
```

### 6. 构建和部署

#### 构建项目

```bash
npm run build
```

#### 部署到Vercel

1. 访问 [Vercel](https://vercel.com/) 并登录
2. 点击 "New Project" 按钮
3. 选择你的项目仓库
4. 配置环境变量：
   - `VITE_SUPABASE_URL`：你的Supabase项目URL
   - `VITE_SUPABASE_ANON_KEY`：你的Supabase匿名密钥
5. 点击 "Deploy" 按钮

## 项目结构

```
smart-parking-system/
├── frontend/              # 前端代码
│   ├── src/
│   │   ├── components/    # 组件
│   │   ├── router/        # 路由配置
│   │   ├── services/      # 服务（Supabase客户端）
│   │   ├── views/         # 页面
│   │   │   ├── B/         # B端管理后台
│   │   │   └── C/         # C端客户端
│   │   ├── App.vue        # 根组件
│   │   ├── main.js        # 入口文件
│   │   └── style.css      # 全局样式
│   ├── .env               # 环境变量
│   ├── package.json       # 依赖配置
│   └── vite.config.js     # Vite配置
├── supabase_migrations.sql # Supabase数据库迁移文件
└── README.md              # 项目说明
```

## 注意事项

1. 本项目使用高德地图SDK，实际部署时需要在 `index.html` 中添加高德地图API密钥
2. 由于使用了Supabase，需要确保网络连接正常，能够访问Supabase服务
3. 本项目为前端演示版本，实际生产环境中需要添加用户认证和权限控制

## 许可证

MIT License