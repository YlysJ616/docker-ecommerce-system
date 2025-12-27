# CI/CD 流水线说明

## Jenkins 流水线概述

本项目使用 Jenkins 实现完整的 CI/CD 自动化流水线，包含代码检出、构建、测试、镜像构建、扫描、推送、集成测试和部署等阶段。

## 流水线架构

```
代码提交 → Jenkins 触发
    ↓
代码检出 (Git)
    ↓
后端构建 (Maven)
    ↓
单元测试 (JUnit)
    ↓
Docker 镜像构建
    ↓
镜像安全扫描
    ↓
推送到镜像仓库
    ↓
集成测试
    ↓
自动部署
    ↓
部署完成通知
```

## Jenkinsfile 详解

### 环境变量配置

```groovy
environment {
    DOCKER_REGISTRY = 'docker.io'
    IMAGE_NAME = 'ecommerce-system'
    IMAGE_TAG = "${BUILD_NUMBER}"
}
```

- `DOCKER_REGISTRY`: Docker 镜像仓库地址
- `IMAGE_NAME`: 镜像名称前缀
- `IMAGE_TAG`: 使用构建号作为镜像标签

### 阶段1: 代码检出

```groovy
stage('代码检出') {
    steps {
        echo '从Git仓库检出代码...'
        checkout scm
    }
}
```

**功能**：
- 从 Git 仓库拉取最新代码
- 使用 SCM (Source Code Management) 配置

**触发方式**：
- 手动触发
- Git Webhook 自动触发
- 定时触发

### 阶段2: 构建后端

```groovy
stage('构建后端') {
    steps {
        echo '构建后端Spring Boot应用...'
        dir('backend') {
            sh 'mvn clean package -DskipTests'
        }
    }
}
```

**功能**：
- 使用 Maven 构建 Spring Boot 应用
- 跳过测试加快构建速度
- 生成可执行 JAR 文件

**输出**：
- `target/ecommerce-backend-1.0.0.jar`

### 阶段3: 单元测试

```groovy
stage('单元测试') {
    steps {
        echo '运行单元测试...'
        dir('backend') {
            sh 'mvn test'
        }
    }
    post {
        always {
            junit 'backend/target/surefire-reports/*.xml'
        }
    }
}
```

**功能**：
- 运行所有单元测试
- 生成测试报告
- 发布 JUnit 测试结果

**测试报告**：
- 位置：`backend/target/surefire-reports/`
- 格式：XML
- 在 Jenkins 中可视化展示

### 阶段4: 构建 Docker 镜像

```groovy
stage('构建Docker镜像') {
    steps {
        echo '构建Docker镜像...'
        script {
            sh """
                docker build -t ${IMAGE_NAME}-backend:${IMAGE_TAG} ./backend
                docker build -t ${IMAGE_NAME}-frontend:${IMAGE_TAG} ./frontend
            """
        }
    }
}
```

**功能**：
- 构建后端 Docker 镜像
- 构建前端 Docker 镜像
- 使用构建号作为标签

**镜像命名**：
- 后端：`ecommerce-system-backend:123`
- 前端：`ecommerce-system-frontend:123`

### 阶段5: 镜像扫描

```groovy
stage('镜像扫描') {
    steps {
        echo '扫描Docker镜像安全漏洞...'
        script {
            sh """
                docker scan ${IMAGE_NAME}-backend:${IMAGE_TAG} || true
                docker scan ${IMAGE_NAME}-frontend:${IMAGE_TAG} || true
            """
        }
    }
}
```

**功能**：
- 扫描镜像安全漏洞
- 使用 Docker Scan (Snyk)
- 失败不中断流水线

**扫描内容**：
- 操作系统漏洞
- 应用依赖漏洞
- 配置问题

### 阶段6: 推送镜像

```groovy
stage('推送镜像') {
    steps {
        echo '推送镜像到Docker Registry...'
        script {
            withCredentials([usernamePassword(
                credentialsId: 'docker-registry-credentials',
                usernameVariable: 'DOCKER_USER',
                passwordVariable: 'DOCKER_PASS'
            )]) {
                sh """
                    echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                    docker tag ${IMAGE_NAME}-backend:${IMAGE_TAG} ${DOCKER_REGISTRY}/${IMAGE_NAME}-backend:${IMAGE_TAG}
                    docker tag ${IMAGE_NAME}-frontend:${IMAGE_TAG} ${DOCKER_REGISTRY}/${IMAGE_NAME}-frontend:${IMAGE_TAG}
                    docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}-backend:${IMAGE_TAG}
                    docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}-frontend:${IMAGE_TAG}
                """
            }
        }
    }
}
```

**功能**：
- 登录 Docker Registry
- 标记镜像
- 推送到远程仓库

**凭据管理**：
- 使用 Jenkins Credentials
- ID: `docker-registry-credentials`
- 类型：Username with password

### 阶段7: 集成测试

```groovy
stage('集成测试') {
    steps {
        echo '运行集成测试...'
        sh '''
            docker-compose -f docker-compose.test.yml up -d
            sleep 30
            curl -f http://localhost:8080/actuator/health || exit 1
            curl -f http://localhost/health.html || exit 1
            docker-compose -f docker-compose.test.yml down
        '''
    }
}
```

**功能**：
- 启动测试环境
- 等待服务就绪
- 测试健康检查端点
- 清理测试环境

**测试内容**：
- 后端健康检查
- 前端健康检查
- API 可用性

### 阶段8: 部署

```groovy
stage('部署') {
    steps {
        echo '部署应用...'
        sh '''
            docker-compose down || true
            docker-compose up -d
        '''
    }
}
```

**功能**：
- 停止旧版本
- 启动新版本
- 自动化部署

**部署策略**：
- 停机部署（当前）
- 可扩展为蓝绿部署
- 可扩展为滚动更新

### Post 处理

```groovy
post {
    success {
        echo '流水线执行成功！'
    }
    failure {
        echo '流水线执行失败！'
    }
    always {
        echo '清理工作空间...'
        cleanWs()
    }
}
```

**功能**：
- 成功通知
- 失败通知
- 清理工作空间

---

## Jenkins 配置

### 1. 安装 Jenkins

#### Docker 方式（推荐）
```bash
docker run -d \
  --name jenkins \
  -p 8081:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
```

#### 获取初始密码
```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### 2. 安装必需插件

访问 Jenkins → Manage Jenkins → Manage Plugins

**必需插件**：
- Git Plugin
- Docker Pipeline
- Maven Integration
- JUnit Plugin
- Credentials Plugin

### 3. 配置凭据

访问 Jenkins → Manage Jenkins → Manage Credentials

#### Docker Registry 凭据
- ID: `docker-registry-credentials`
- 类型: Username with password
- Username: Docker Hub 用户名
- Password: Docker Hub 密码或 Token

#### Git 凭据（如果是私有仓库）
- ID: `git-credentials`
- 类型: Username with password 或 SSH Key
- Username: Git 用户名
- Password: Git 密码或 Token

### 4. 创建 Pipeline 任务

1. 新建任务 → Pipeline
2. 配置：
   - **General**:
     - 项目名称: `docker-ecommerce-system`
     - 描述: Docker 电商系统 CI/CD
   
   - **Build Triggers**:
     - ☑ GitHub hook trigger for GITScm polling
     - ☑ Poll SCM: `H/5 * * * *` (每5分钟检查一次)
   
   - **Pipeline**:
     - Definition: Pipeline script from SCM
     - SCM: Git
     - Repository URL: `https://github.com/YlysJ616/docker-ecommerce-system.git`
     - Credentials: 选择 Git 凭据
     - Branch: `*/main`
     - Script Path: `Jenkinsfile`

3. 保存配置

### 5. 配置 Webhook（自动触发）

#### GitHub Webhook
1. 访问 GitHub 仓库 → Settings → Webhooks
2. 添加 Webhook：
   - Payload URL: `http://your-jenkins-url:8081/github-webhook/`
   - Content type: `application/json`
   - Events: `Just the push event`
   - Active: ☑

---

## 流水线优化

### 1. 并行构建

```groovy
stage('并行构建') {
    parallel {
        stage('构建后端') {
            steps {
                sh 'docker build -t backend ./backend'
            }
        }
        stage('构建前端') {
            steps {
                sh 'docker build -t frontend ./frontend'
            }
        }
    }
}
```

### 2. 缓存优化

```groovy
stage('构建') {
    steps {
        sh 'docker build --cache-from backend:latest -t backend:new ./backend'
    }
}
```

### 3. 条件执行

```groovy
stage('部署到生产') {
    when {
        branch 'main'
    }
    steps {
        sh 'docker-compose up -d'
    }
}
```

### 4. 通知集成

```groovy
post {
    success {
        emailext (
            subject: "构建成功: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body: "构建成功！",
            to: "team@example.com"
        )
    }
    failure {
        emailext (
            subject: "构建失败: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body: "构建失败，请检查！",
            to: "team@example.com"
        )
    }
}
```

---

## 监控与报告

### 1. 构建历史
- 访问 Jenkins → 项目 → Build History
- 查看每次构建的状态和耗时

### 2. 测试报告
- 访问 Jenkins → 项目 → Test Result
- 查看测试通过率和失败用例

### 3. 构建趋势
- 访问 Jenkins → 项目 → Trend
- 查看构建成功率趋势

### 4. 日志查看
- 访问 Jenkins → 项目 → 构建号 → Console Output
- 查看详细构建日志

---

## 最佳实践

### 1. 版本管理
```groovy
environment {
    VERSION = "${env.BUILD_NUMBER}"
    GIT_COMMIT_SHORT = sh(
        script: "git rev-parse --short HEAD",
        returnStdout: true
    ).trim()
    IMAGE_TAG = "${VERSION}-${GIT_COMMIT_SHORT}"
}
```

### 2. 环境隔离
```groovy
stage('部署') {
    when {
        branch 'main'
        environment name: 'DEPLOY_ENV', value: 'production'
    }
    steps {
        sh 'docker-compose -f docker-compose.prod.yml up -d'
    }
}
```

### 3. 回滚机制
```groovy
stage('回滚') {
    when {
        expression { currentBuild.result == 'FAILURE' }
    }
    steps {
        sh 'docker-compose down'
        sh 'docker-compose up -d --scale backend=0'
        sh 'docker tag backend:previous backend:latest'
        sh 'docker-compose up -d'
    }
}
```

### 4. 安全扫描
```groovy
stage('安全扫描') {
    steps {
        sh 'trivy image backend:latest'
        sh 'trivy image frontend:latest'
    }
}
```

---

## 故障排查

### 问题1: 构建失败

**查看日志**
```bash
# Jenkins 控制台输出
# 或
docker logs jenkins
```

### 问题2: 权限问题

**解决方案**
```bash
# 添加 Jenkins 用户到 docker 组
docker exec -u root jenkins usermod -aG docker jenkins
docker restart jenkins
```

### 问题3: 网络问题

**配置代理**
```groovy
environment {
    HTTP_PROXY = 'http://proxy.example.com:8080'
    HTTPS_PROXY = 'http://proxy.example.com:8080'
}
```

---

## 扩展功能

### 1. 多环境部署
- 开发环境
- 测试环境
- 预发布环境
- 生产环境

### 2. 蓝绿部署
- 零停机部署
- 快速回滚

### 3. 金丝雀发布
- 灰度发布
- 流量控制

### 4. 自动化测试
- 单元测试
- 集成测试
- 端到端测试
- 性能测试
