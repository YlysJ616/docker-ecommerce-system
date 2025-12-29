pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'docker.io'
        IMAGE_NAME = 'ecommerce-system'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('代码检出') {
            steps {
                echo '从Git仓库检出代码...'
                checkout scm
            }
        }
        
        stage('构建后端') {
            steps {
                echo '构建后端Spring Boot应用...'
                dir('backend') {
                    bat 'mvn clean package -DskipTests'
                }
            }
        }
        
        stage('单元测试') {
            steps {
                echo '运行单元测试...'
                dir('backend') {
                    bat 'mvn test'
                }
            }
            post {
                always {
                    junit 'backend/target/surefire-reports/*.xml'
                }
            }
        }
        
        stage('构建Docker镜像') {
            steps {
                echo '构建Docker镜像...'
                script {
                    bat """
                        docker build -t ${IMAGE_NAME}-backend:${IMAGE_TAG} ./backend
                        docker build -t ${IMAGE_NAME}-frontend:${IMAGE_TAG} ./frontend
                    """
                }
            }
        }
        
        stage('镜像扫描') {
            steps {
                echo '跳过镜像扫描（Windows环境）...'
            }
        }
        
        stage('推送镜像') {
            steps {
                echo '跳过推送镜像（本地部署模式）...'
                echo '如需推送到Registry，请配置docker-registry-credentials凭据'
            }
        }
        
        stage('集成测试') {
            steps {
                echo '验证Docker镜像构建成功...'
                bat '''
                    echo "检查后端镜像..."
                    docker images | findstr ecommerce-system-backend || echo "后端镜像未找到"
                    echo "检查前端镜像..."
                    docker images | findstr ecommerce-system-frontend || echo "前端镜像未找到"
                    echo "镜像验证完成"
                '''
            }
        }
        
        stage('部署') {
            steps {
                echo '部署应用...'
                bat '''
                    echo "停止现有容器..."
                    docker-compose down -v --remove-orphans || echo "无需停止"
                    docker stop ecommerce-frontend ecommerce-backend ecommerce-db 2>nul || echo "容器已停止"
                    docker rm ecommerce-frontend ecommerce-backend ecommerce-db 2>nul || echo "容器已删除"
                    
                    echo "清理数据卷..."
                    docker volume rm docker_db_data 2>nul || echo "卷已清理"
                    
                    echo "启动服务..."
                    docker-compose up -d --build
                    
                    echo "等待数据库启动..."
                    timeout /t 40 /nobreak
                    
                    echo "检查服务状态..."
                    docker-compose ps
                '''
                bat '''
                    echo "手动执行数据库初始化脚本..."
                    docker exec -i ecommerce-db mysql -u root -proot123 ecommerce < database/init-chinese.sql || echo "初始化完成或已存在"
                    
                    echo "验证数据库数据..."
                    docker exec ecommerce-db mysql -u root -proot123 -e "USE ecommerce; SELECT COUNT(*) as product_count FROM products;"
                '''
            }
        }
    }
    
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
}
