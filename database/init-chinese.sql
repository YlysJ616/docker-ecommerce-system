SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

CREATE DATABASE IF NOT EXISTS ecommerce CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE ecommerce;

CREATE TABLE IF NOT EXISTS products (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    category VARCHAR(100),
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO products (name, description, price, stock, category, image_url) VALUES
-- 手机类
('iPhone 15 Pro Max', '苹果最新旗舰手机，A17 Pro芯片，钛金属边框，6.7英寸超视网膜XDR显示屏', 9999.00, 50, '手机', 'https://images.unsplash.com/photo-1678652197831-2d180705cd2c?w=400&h=400&fit=crop'),
('iPhone 15', 'A16仿生芯片，灵动岛设计，4800万像素主摄', 5999.00, 80, '手机', 'https://images.unsplash.com/photo-1678911820864-e2c567c655d7?w=400&h=400&fit=crop'),
('小米14 Pro', '骁龙8 Gen3，徕卡光学镜头，120W澎湃秒充', 4999.00, 70, '手机', 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=400&h=400&fit=crop'),
('华为Mate 60 Pro', '麒麟9000S芯片，卫星通信，昆仑玻璃', 6999.00, 45, '手机', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&h=400&fit=crop'),
('三星Galaxy S24 Ultra', '骁龙8 Gen3，200MP主摄，S Pen手写笔', 9299.00, 55, '手机', 'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=400&h=400&fit=crop'),
('OPPO Find X7 Ultra', '天玑9300，哈苏影像，双潜望长焦', 5999.00, 60, '手机', 'https://images.unsplash.com/photo-1585060544812-6b45742d762f?w=400&h=400&fit=crop'),

-- 电脑类
('MacBook Pro 14', 'M3 Pro芯片，16GB内存，512GB存储，Liquid视网膜XDR显示屏', 15999.00, 30, '电脑', 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400&h=400&fit=crop'),
('MacBook Air 15', 'M2芯片，8GB内存，256GB存储，超薄设计', 10499.00, 40, '电脑', 'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?w=400&h=400&fit=crop'),
('华为MateBook X Pro', '英特尔酷睿Ultra 7，3K触控屏，超轻薄设计', 8999.00, 35, '电脑', 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400&h=400&fit=crop'),
('联想ThinkPad X1 Carbon', '英特尔酷睿i7，16GB内存，商务旗舰', 12999.00, 25, '电脑', 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=400&h=400&fit=crop'),
('戴尔XPS 15', '英特尔酷睿i9，32GB内存，RTX 4060显卡', 16999.00, 20, '电脑', 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=400&h=400&fit=crop'),
('微软Surface Laptop 5', '英特尔酷睿i7，触控屏，轻薄便携', 9999.00, 30, '电脑', 'https://images.unsplash.com/photo-1629131726692-1accd0c53ce0?w=400&h=400&fit=crop'),

-- 平板类
('iPad Pro 12.9', 'M2芯片，12.9英寸Liquid视网膜XDR显示屏，支持Apple Pencil', 9299.00, 40, '平板', 'https://images.unsplash.com/photo-1561154464-82e9adf32764?w=400&h=400&fit=crop'),
('iPad Air', 'M1芯片，10.9英寸视网膜显示屏，多彩外观', 4799.00, 60, '平板', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400&h=400&fit=crop'),
('三星Galaxy Tab S9 Ultra', '骁龙8 Gen2，14.6英寸AMOLED屏幕，S Pen', 8999.00, 35, '平板', 'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=400&h=400&fit=crop'),
('华为MatePad Pro', '麒麟9000S，12.6英寸OLED屏幕，M-Pencil', 5299.00, 45, '平板', 'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=400&h=400&fit=crop'),

-- 智能手表类
('Apple Watch Ultra 2', '钛金属表壳，双频GPS，100米防水，极限运动', 6299.00, 50, '智能手表', 'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=400&h=400&fit=crop'),
('Apple Watch Series 9', 'GPS + 蜂窝网络，45mm表壳，健康监测', 3199.00, 80, '智能手表', 'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=400&h=400&fit=crop'),
('华为Watch GT 4', '鸿蒙系统，14天续航，健康管理', 1699.00, 90, '智能手表', 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=400&h=400&fit=crop'),
('小米Watch S3', '高通骁龙W5+，AMOLED屏幕，独立通话', 1299.00, 100, '智能手表', 'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=400&h=400&fit=crop'),
('Garmin Fenix 7', '专业运动手表，GPS导航，多种运动模式', 4599.00, 35, '智能手表', 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&h=400&fit=crop'),

-- 耳机配件类
('AirPods Pro 2', '主动降噪无线耳机，USB-C充电，空间音频', 1899.00, 120, '配件', 'https://images.unsplash.com/photo-1606841837239-c5a1a4a07af7?w=400&h=400&fit=crop'),
('AirPods Max', '头戴式降噪耳机，空间音频，20小时续航', 4399.00, 40, '配件', 'https://images.unsplash.com/photo-1545127398-14699f92334b?w=400&h=400&fit=crop'),
('索尼WH-1000XM5', '业界领先降噪，30小时续航，LDAC高清音质', 2499.00, 90, '配件', 'https://images.unsplash.com/photo-1545127398-14699f92334b?w=400&h=400&fit=crop'),
('Bose QuietComfort Ultra', '沉浸式音频，主动降噪，舒适佩戴', 2999.00, 60, '配件', 'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=400&h=400&fit=crop'),
('森海塞尔Momentum 4', 'Hi-Fi音质，60小时续航，自适应降噪', 2299.00, 55, '配件', 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400&h=400&fit=crop'),
('小米Buds 5 Pro', '动态降噪，无线充电，HiFi音质', 699.00, 150, '配件', 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400&h=400&fit=crop'),

-- 相机类
('索尼A7M4', '全画幅微单相机，3300万像素，5轴防抖', 15999.00, 25, '相机', 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=400&h=400&fit=crop'),
('佳能EOS R6 Mark II', '全画幅微单，2420万像素，40fps连拍', 16999.00, 20, '相机', 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=400&h=400&fit=crop'),
('尼康Z8', '全画幅微单，4571万像素，8K视频', 21999.00, 15, '相机', 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=400&h=400&fit=crop'),
('富士X-T5', 'APS-C画幅，4020万像素，复古设计', 11999.00, 30, '相机', 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=400&h=400&fit=crop'),

-- 智能家居类
('小米电视S Pro 65', '65英寸4K超高清，120Hz刷新率，HDMI 2.1', 3999.00, 50, '智能家居', 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=400&h=400&fit=crop'),
('海信电视U8', '75英寸Mini LED，144Hz刷新率，游戏电视', 7999.00, 30, '智能家居', 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=400&h=400&fit=crop'),
('小米空气净化器Pro H', 'HEPA滤网，智能控制，除甲醛', 1699.00, 80, '智能家居', 'https://images.unsplash.com/photo-1585771724684-38269d6639fd?w=400&h=400&fit=crop'),
('戴森V15吸尘器', '激光探测，智能显示，强劲吸力', 4990.00, 40, '智能家居', 'https://images.unsplash.com/photo-1558317374-067fb5f30001?w=400&h=400&fit=crop'),
('米家扫地机器人X10+', '自动集尘，激光导航，拖扫一体', 2999.00, 60, '智能家居', 'https://images.unsplash.com/photo-1558317374-067fb5f30001?w=400&h=400&fit=crop');

CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO users (username, email) VALUES
('admin', 'admin@example.com'),
('user1', 'user1@example.com');
