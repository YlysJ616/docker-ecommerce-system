# Docker Compose 编排说明

## 配置文件

### 文件位置
- 生产环境: `docker-compose.yml`
- 测试环境: `docker-compose.test.yml`

## 服务配置

### 1. 数据库服务 (db)

```yaml
db:
  image: mysql:8.0
  container_name: ecommerce-db
  restart: always
  environment:
    MYSQL_ROOT_PASSWORD: root123
    MYSQL_DATABASE: ecommerce
    MYSQL_USER: ecommerce_user
    MYSQL_PASSWORD: ecommerce_pass
    TZ: Asia/Shanghai
  ports:
    - "3307:3306"
  volumes:
    - db_data:/var/lib/mysql
    - ./database/init-chinese.sql:/docker-entrypoint-initdb.d/init.sql
  networks:
    - ecommerce-network
  command: 
    - --character-set-server=utf8mb4
    - --collation-server=utf8mb4_unicode_ci
    - --default-authentication-plugin=mysql_native_password
  healthcheck:
    test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-proot123"]
    interval: 10s
    timeout: 5s
    retries: 5
```

#### 关键配置说明

**镜像选择**
- `mysql:8.0`: 使用 MySQL 8.0 官方镜像

**环境变量**
- `MYSQL_ROOT_PASSWORD`: root 用户密码
- `MYSQL_DATABASE`: 自动创建的数据库名
- `MYSQL_USER`: 应用用户名
- `MYSQL_PASSWORD`: 应用用户密码
- `TZ`: 时区设置

**端口映射**
- `3307:3306`: 避免与本地 MySQL 冲突

**数据卷**
- `db_data:/var/lib/mysql`: 数据持久化
- `./database/init-chinese.sql`: 初始化脚本

**启动参数**
- `--character-set-server=utf8mb4`: 字符集
- `--collation-server=utf8mb4_unicode_ci`: 排序规则
- `--default-authentication-plugin`: 认证插件

**健康检查**
- 每 10 秒检查一次
- 超时 5 秒
- 失败重试 5 次

---

### 2. 后端服务 (backend)

```yaml
backend:
  build:
    context: ./backend
    dockerfile: Dockerfile
  container_name: ecommerce-backend
  restart: always
  ports:
    - "8080:8080"
  environment:
    SPRING_DATASOURCE_URL: jdbc:mysql://db:3306/ecommerce?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=utf8&useUnicode=true&connectionCollation=utf8mb4_unicode_ci
    SPRING_DATASOURCE_USERNAME: ecommerce_user
    SPRING_DATASOURCE_PASSWORD: ecommerce_pass
    SERVER_PORT: 8080
  depends_on:
    db:
      condition: service_healthy
  networks:
    - ecommerce-network
  healthcheck:
    test: ["CMD", "curl", "-f", "http://localhost:8080/actuator/health"]
    interval: 30s
    timeout: 10s
    retries: 3
    start_period: 40s
```

#### 关键配置说明

**构建配置**
- `context`: 构建上下文目录
- `dockerfile`: Dockerfile 文件名

**环境变量**
- `SPRING_DATASOURCE_URL`: 数据库连接字符串
  - 使用服务名 `db` 而非 IP
  - 配置字符集和时区
- `SPRING_DATASOURCE_USERNAME`: 数据库用户名
- `SPRING_DATASOURCE_PASSWORD`: 数据库密码
- `SERVER_PORT`: 应用端口

**依赖关系**
- `depends_on.db.condition: service_healthy`
- 等待数据库健康后再启动
- 确保启动顺序正确

**健康检查**
- 检查 Spring Boot Actuator 端点
- `start_period: 40s`: 给应用足够启动时间

---

### 3. 前端服务 (frontend)

```yaml
frontend:
  build:
    context: ./frontend
    dockerfile: Dockerfile
  container_name: ecommerce-frontend
  restart: always
  ports:
    - "80:80"
  depends_on:
    - backend
  networks:
    - ecommerce-network
  healthcheck:
    test: ["CMD", "curl", "-f", "http://localhost/health.html"]
    interval: 30s
    timeout: 10s
    retries: 3
```

#### 关键配置说明

**端口映射**
- `80:80`: HTTP 标准端口

**依赖关系**
- `depends_on: backend`
- 等待后端启动后再启动

**健康检查**
- 检查健康页面
- 确保 Nginx 正常运行

---

## 网络配置

```yaml
networks:
  ecommerce-network:
    driver: bridge
```

### 特点
- 自定义网络名称
- 使用 bridge 驱动
- 容器间可通过服务名通信

### 服务通信
```
frontend → http://backend:8080
backend → jdbc:mysql://db:3306
```

---

## 数据卷配置

```yaml
volumes:
  db_data:
    driver: local
```

### 特点
- 命名卷
- 本地驱动
- 数据持久化

### 管理命令
```bash
# 查看卷
docker volume ls

# 查看卷详情
docker volume inspect docker_db_data

# 删除卷
docker volume rm docker_db_data
```

---

## 常用命令

### 启动服务
```bash
# 启动所有服务
docker-compose up -d

# 启动特定服务
docker-compose up -d frontend

# 查看启动日志
docker-compose up
```

### 停止服务
```bash
# 停止所有服务
docker-compose down

# 停止并删除卷
docker-compose down -v

# 停止特定服务
docker-compose stop frontend
```

### 重启服务
```bash
# 重启所有服务
docker-compose restart

# 重启特定服务
docker-compose restart backend
```

### 查看状态
```bash
# 查看服务状态
docker-compose ps

# 查看服务日志
docker-compose logs

# 实时查看日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs backend
```

### 构建镜像
```bash
# 构建所有镜像
docker-compose build

# 不使用缓存构建
docker-compose build --no-cache

# 并行构建
docker-compose build --parallel
```

### 扩展服务
```bash
# 扩展后端服务到 3 个实例
docker-compose up -d --scale backend=3
```

---

## 测试环境配置

### docker-compose.test.yml

```yaml
version: '3.8'

services:
  db-test:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root123
      MYSQL_DATABASE: ecommerce_test
      MYSQL_USER: test_user
      MYSQL_PASSWORD: test_pass
    tmpfs:
      - /var/lib/mysql  # 使用内存文件系统，测试后自动清理
    networks:
      - test-network

  backend-test:
    build:
      context: ./backend
      dockerfile: Dockerfile
    environment:
      SPRING_DATASOURCE_URL: jdbc:mysql://db-test:3306/ecommerce_test
      SPRING_DATASOURCE_USERNAME: test_user
      SPRING_DATASOURCE_PASSWORD: test_pass
    depends_on:
      - db-test
    networks:
      - test-network
    ports:
      - "8080:8080"

  frontend-test:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    depends_on:
      - backend-test
    networks:
      - test-network
    ports:
      - "80:80"

networks:
  test-network:
    driver: bridge
```

### 测试环境特点
- 使用 `tmpfs` 存储数据库数据
- 测试后自动清理
- 独立的网络和服务名
- 不影响生产环境

### 使用测试环境
```bash
# 启动测试环境
docker-compose -f docker-compose.test.yml up -d

# 运行测试
curl http://localhost:8080/actuator/health

# 清理测试环境
docker-compose -f docker-compose.test.yml down
```

---

## 最佳实践

### 1. 服务依赖
```yaml
depends_on:
  db:
    condition: service_healthy  # 等待健康检查通过
```

### 2. 健康检查
```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost/health"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

### 3. 环境变量
```yaml
environment:
  - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-root123}
```

### 4. 资源限制
```yaml
deploy:
  resources:
    limits:
      cpus: '1'
      memory: 512M
    reservations:
      cpus: '0.5'
      memory: 256M
```

### 5. 日志配置
```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

---

## 故障排查

### 服务无法启动
```bash
# 查看详细日志
docker-compose logs backend

# 查看容器状态
docker-compose ps

# 进入容器调试
docker-compose exec backend sh
```

### 网络问题
```bash
# 查看网络
docker network ls

# 查看网络详情
docker network inspect docker_ecommerce-network

# 测试连接
docker-compose exec backend ping db
```

### 数据卷问题
```bash
# 查看卷
docker volume ls

# 清理未使用的卷
docker volume prune

# 备份数据卷
docker run --rm -v docker_db_data:/data -v $(pwd):/backup alpine tar czf /backup/db_backup.tar.gz /data
```

---

## 性能优化

### 1. 使用构建缓存
```bash
docker-compose build --parallel
```

### 2. 限制日志大小
```yaml
logging:
  options:
    max-size: "10m"
    max-file: "3"
```

### 3. 使用健康检查
确保服务按正确顺序启动

### 4. 资源限制
防止单个服务占用过多资源

### 5. 网络优化
使用自定义网络提高通信效率
