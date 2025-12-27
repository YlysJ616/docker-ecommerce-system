# Dockerfile 编写说明

## 前端 Dockerfile

### 文件位置
`frontend/Dockerfile`

### 多阶段构建

```dockerfile
# 阶段1: 构建阶段（预留）
FROM node:18-alpine AS builder
WORKDIR /app
# 可用于构建 React/Vue 等前端框架

# 阶段2: 运行阶段
FROM nginx:1.25-alpine
```

### 关键配置

#### 1. 基础镜像选择
```dockerfile
FROM nginx:1.25-alpine
```
- 使用 Alpine Linux 基础镜像
- 镜像大小仅 ~40MB
- 包含 Nginx 1.25 版本

#### 2. 配置文件处理
```dockerfile
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/
```
- 删除默认配置
- 复制自定义配置

#### 3. 静态文件复制
```dockerfile
COPY html/ /usr/share/nginx/html/
```
- 复制所有前端文件
- 包含 HTML、CSS、JavaScript

#### 4. 健康检查页面
```dockerfile
RUN echo "OK" > /usr/share/nginx/html/health.html
```
- 创建健康检查端点
- 用于容器健康状态监测

#### 5. 端口暴露
```dockerfile
EXPOSE 80
```
- 声明容器监听 80 端口

#### 6. 健康检查配置
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/health.html || exit 1
```
- 每 30 秒检查一次
- 超时时间 3 秒
- 启动等待 5 秒
- 失败重试 3 次

#### 7. 启动命令
```dockerfile
CMD ["nginx", "-g", "daemon off;"]
```
- 前台运行 Nginx
- 保持容器运行

### 构建命令
```bash
docker build -t ecommerce-frontend:latest ./frontend
```

### 镜像大小
- 最终镜像: ~74MB
- 优化效果: 使用 Alpine 基础镜像

---

## 后端 Dockerfile

### 文件位置
`backend/Dockerfile`

### 多阶段构建

```dockerfile
# 阶段1: 构建阶段
FROM maven:3.9-eclipse-temurin-17-alpine AS builder

# 阶段2: 运行阶段
FROM eclipse-temurin:17-jre-alpine
```

### 关键配置

#### 1. 构建阶段

##### 基础镜像
```dockerfile
FROM maven:3.9-eclipse-temurin-17-alpine AS builder
```
- Maven 3.9 用于构建
- Eclipse Temurin JDK 17
- Alpine Linux 基础

##### 工作目录
```dockerfile
WORKDIR /app
```

##### 依赖下载（利用缓存）
```dockerfile
COPY pom.xml .
RUN mvn dependency:go-offline -B
```
- 先复制 pom.xml
- 下载所有依赖
- 利用 Docker 层缓存

##### 源码构建
```dockerfile
COPY src ./src
RUN mvn clean package -DskipTests -B
```
- 复制源代码
- 执行 Maven 打包
- 跳过测试加快构建

#### 2. 运行阶段

##### 基础镜像
```dockerfile
FROM eclipse-temurin:17-jre-alpine
```
- 仅包含 JRE，不含 JDK
- 大幅减小镜像体积

##### 工作目录
```dockerfile
WORKDIR /app
```

##### 创建非 root 用户
```dockerfile
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
```
- 创建 spring 用户组和用户
- 以非 root 用户运行应用
- 提高安全性

##### 复制 JAR 文件
```dockerfile
COPY --from=builder /app/target/*.jar app.jar
```
- 从构建阶段复制 JAR
- 仅复制必要文件

##### 端口暴露
```dockerfile
EXPOSE 8080
```

##### 健康检查
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1
```
- 检查 Spring Boot Actuator 健康端点
- 启动等待 40 秒（应用启动时间）

##### 启动命令
```dockerfile
ENTRYPOINT ["java", "-jar", "-Xmx512m", "-Xms256m", "app.jar"]
```
- 设置 JVM 内存参数
- 最大堆内存 512MB
- 初始堆内存 256MB

### 构建命令
```bash
docker build -t ecommerce-backend:latest ./backend
```

### 镜像大小对比
- 构建阶段镜像: ~600MB (包含 Maven + JDK)
- 最终镜像: ~345MB (仅 JRE + JAR)
- 优化效果: 减小 42%

---

## Dockerfile 最佳实践

### 1. 使用多阶段构建
- 分离构建环境和运行环境
- 减小最终镜像体积
- 提高安全性

### 2. 利用层缓存
```dockerfile
# 先复制依赖文件
COPY pom.xml .
RUN mvn dependency:go-offline

# 再复制源代码
COPY src ./src
RUN mvn package
```

### 3. 使用 Alpine 镜像
- 体积小
- 安全性高
- 启动快

### 4. 最小化层数
```dockerfile
# 不好的做法
RUN apt-get update
RUN apt-get install -y package1
RUN apt-get install -y package2

# 好的做法
RUN apt-get update && \
    apt-get install -y package1 package2 && \
    rm -rf /var/lib/apt/lists/*
```

### 5. 使用 .dockerignore
```
node_modules
target
*.log
.git
```

### 6. 非 root 用户运行
```dockerfile
RUN adduser -D myuser
USER myuser
```

### 7. 健康检查
```dockerfile
HEALTHCHECK --interval=30s CMD curl -f http://localhost/ || exit 1
```

### 8. 明确指定版本
```dockerfile
# 不好
FROM nginx

# 好
FROM nginx:1.25-alpine
```

---

## 构建优化技巧

### 1. 使用构建缓存
```bash
docker build --cache-from ecommerce-backend:latest -t ecommerce-backend:new .
```

### 2. 并行构建
```bash
docker-compose build --parallel
```

### 3. 清理构建缓存
```bash
docker builder prune
```

### 4. 查看镜像层
```bash
docker history ecommerce-backend:latest
```

### 5. 分析镜像大小
```bash
docker images ecommerce-backend:latest
```

---

## 常见问题

### Q: 为什么使用多阶段构建？
A: 分离构建和运行环境，减小镜像体积，提高安全性。

### Q: Alpine 镜像有什么优势？
A: 体积小（~5MB），安全性高，启动快。

### Q: 如何减小镜像体积？
A: 使用多阶段构建、Alpine 基础镜像、清理不必要文件。

### Q: 健康检查有什么用？
A: 监测容器运行状态，自动重启不健康的容器。

### Q: 为什么要使用非 root 用户？
A: 提高安全性，遵循最小权限原则。
