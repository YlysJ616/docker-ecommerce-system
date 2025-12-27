-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS ecommerce CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE ecommerce;

-- 创建商品表
CREATE TABLE IF NOT EXISTS products (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL COMMENT '商品名称',
    description TEXT COMMENT '商品描述',
    price DECIMAL(10, 2) NOT NULL COMMENT '商品价格',
    stock INT NOT NULL DEFAULT 0 COMMENT '库存数量',
    category VARCHAR(100) COMMENT '商品分类',
    image_url VARCHAR(500) COMMENT '商品图片URL',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_category (category),
    INDEX idx_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品表';

-- 插入测试数据
INSERT INTO products (name, description, price, stock, category, image_url) VALUES
('iPhone 15 Pro', '苹果最新旗舰手机，A17 Pro芯片，钛金属边框', 7999.00, 50, '手机', 'https://picsum.photos/300/300?random=1'),
('MacBook Pro 14', 'M3 Pro芯片，16GB内存，512GB存储', 15999.00, 30, '电脑', 'https://picsum.photos/300/300?random=2'),
('AirPods Pro 2', '主动降噪无线耳机，USB-C充电', 1899.00, 100, '配件', 'https://picsum.photos/300/300?random=3'),
('iPad Air', 'M2芯片，10.9英寸视网膜显示屏', 4799.00, 60, '平板', 'https://picsum.photos/300/300?random=4'),
('Apple Watch Series 9', 'GPS + 蜂窝网络，45mm表壳', 3199.00, 80, '智能手表', 'https://picsum.photos/300/300?random=5'),
('小米14 Pro', '骁龙8 Gen3，徕卡光学镜头', 4999.00, 70, '手机', 'https://picsum.photos/300/300?random=6'),
('华为MateBook X Pro', '英特尔酷睿Ultra，3K触控屏', 8999.00, 40, '电脑', 'https://picsum.photos/300/300?random=7'),
('索尼WH-1000XM5', '业界领先降噪，30小时续航', 2499.00, 90, '配件', 'https://picsum.photos/300/300?random=8'),
('三星Galaxy Tab S9', '骁龙8 Gen2，11英寸AMOLED屏幕', 5299.00, 45, '平板', 'https://picsum.photos/300/300?random=9'),
('Garmin Fenix 7', '专业运动手表，GPS导航', 4599.00, 35, '智能手表', 'https://picsum.photos/300/300?random=10');

-- 创建用户表（扩展功能）
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    email VARCHAR(100) NOT NULL UNIQUE COMMENT '邮箱',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 插入测试用户
INSERT INTO users (username, email) VALUES
('admin', 'admin@example.com'),
('user1', 'user1@example.com');
