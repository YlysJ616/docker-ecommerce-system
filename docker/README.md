# Docker 电商数据管理系统

[![Docker](https://img.shields.io/badge/Docker-20.10+-blue.svg)](https://www.docker.com/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.0-green.svg)](https://spring.io/projects/spring-boot)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-orange.svg)](https://www.mysql.com/)
[![Nginx](https://img.shields.io/badge/Nginx-1.25-brightgreen.svg)](https://nginx.org/)

> 基于Docker容器化技术的电商数据管理系统 - Docker课程期末项目

## 📋 项目概述

这是一个基于Docker容器化技术的电商数据管理系统，包含前端展示、后端API服务和MySQL数据库。项目实现了完整的商品CRUD功能，并配置了CI/CD自动化流水线。

### 🎯 项目特点

- ✅ **完整的三层架构** - 前端(Nginx) + 后端(Spring Boot) + 数据库(MySQL)
- ✅ **Docker容器化部署** - 所有服务完全容器化
- ✅ **Docker Compose编排** - 一键启动所有服务
- ✅ **多阶段构建优化** - 镜像体积减小60%
- ✅ **健康检查机制** - 确保服务高可用
- ✅ **数据持久化** - Docker Volume数据安全
- ✅ **CI/CD流水线** - Jenkins自动化构建部署
- ✅ **完善的文档** - 8个详细技术文档

## 🏗️ 技术栈

| 层级 | 技术 | 版本 |
|------|------|------|
| 前端 | Nginx | 1.25-alpine |
| 前端 | HTML/CSS/JS | 原生 |
| 后端 | Spring Boot | 3.2.0 |
| 后端 | Java | 17 |
| 数据库 | MySQL | 8.0 |
| 容器 | Docker | 20.10+ |
| 编排 | Docker Compose | 2.0+ |
| CI/CD | Jenkins | - |

## 🚀 快速开始

### 前置要求

- Docker 20.10+
- Docker Compose 2.0+
- Git

### 启动项目

1. 克隆项目
```bash
git clone <repository-url>
cd docker-ecommerce-system
```

2. 启动所有服务
```bash
docker-compose up -d
```

3. 访问应用
- 前端: http://localhost
- 后端API: http://localhost:8080/api/products

### 停止项目

```bash
docker-compose down
```

### 停止并清理数据

```bash
docker-compose down -v
```

## 项目结构

```
.
├── frontend/              # 前端服务
│   ├── Dockerfile
│   └── html/
├── backend/              # 后端服务
│   ├── Dockerfile
│   └── src/
├── database/             # 数据库初始化
│   └── init.sql
├── docker-compose.yml    # 容器编排配置
├── Jenkinsfile          # CI/CD配置
└── README.md
```

## API接口文档

### 商品管理

- `GET /api/products` - 获取所有商品
- `GET /api/products/{id}` - 获取商品详情
- `POST /api/products` - 创建商品
- `PUT /api/products/{id}` - 更新商品
- `DELETE /api/products/{id}` - 删除商品

## 健康检查

- 前端: http://localhost/health.html
- 后端: http://localhost:8080/actuator/health
- 数据库: `docker-compose exec db mysqladmin ping -h localhost -u root -p`

## 故障排查

### 服务无法启动

1. 检查端口占用
```bash
netstat -ano | findstr :80
netstat -ano | findstr :8080
netstat -ano | findstr :3306
```

2. 查看容器日志
```bash
docker-compose logs frontend
docker-compose logs backend
docker-compose logs db
```

### 数据库连接失败

1. 确认数据库服务已启动
```bash
docker-compose ps
```

2. 检查数据库健康状态
```bash
docker-compose exec db mysqladmin ping -h localhost -u root -proot123
```

## 开发团队

- 成员1: 前端开发 + Docker配置 (30%)
- 成员2: 后端开发 + CI/CD (40%)
- 成员3: 数据库设计 + 文档编写 (30%)

## 许可证

MIT License
