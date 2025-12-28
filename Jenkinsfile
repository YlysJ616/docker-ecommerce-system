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
                    sh 'mvn clean package -DskipTests'
                }
            }
        }
        
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
        
        stage('推送镜像') {
            steps {
                echo '跳过推送镜像（本地部署模式）...'
                echo '如需推送到Registry，请配置docker-registry-credentials凭据'
            }
        }
        
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
        
        stage('部署') {
            steps {
                echo '部署应用...'
                sh '''
                    docker-compose down || true
                    docker-compose up -d
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
