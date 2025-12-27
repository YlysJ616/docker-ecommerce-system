# API 接口文档

## 基础信息

- **Base URL**: `http://localhost:8080`
- **API 前缀**: `/api/products`
- **数据格式**: JSON
- **字符编码**: UTF-8

---

## 商品管理 API

### 1. 获取所有商品

#### 请求
```http
GET /api/products
```

#### 响应
```json
[
    {
        "id": 1,
        "name": "iPhone 15 Pro Max",
        "description": "苹果最新旗舰手机，A17 Pro芯片，钛金属边框，6.7英寸超视网膜XDR显示屏",
        "price": 9999.00,
        "stock": 50,
        "category": "手机",
        "imageUrl": "https://images.unsplash.com/photo-1678652197831-2d180705cd2c?w=400&h=400&fit=crop",
        "createdAt": "2025-12-27T10:00:00",
        "updatedAt": "2025-12-27T10:00:00"
    },
    {
        "id": 2,
        "name": "MacBook Pro 14",
        "description": "M3 Pro芯片，16GB内存，512GB存储，Liquid视网膜XDR显示屏",
        "price": 15999.00,
        "stock": 30,
        "category": "电脑",
        "imageUrl": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400&h=400&fit=crop",
        "createdAt": "2025-12-27T10:00:00",
        "updatedAt": "2025-12-27T10:00:00"
    }
]
```

#### 状态码
- `200 OK`: 成功

---

### 2. 获取商品详情

#### 请求
```http
GET /api/products/{id}
```

#### 路径参数
| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | Long | 是 | 商品ID |

#### 示例
```http
GET /api/products/1
```

#### 响应
```json
{
    "id": 1,
    "name": "iPhone 15 Pro Max",
    "description": "苹果最新旗舰手机，A17 Pro芯片，钛金属边框，6.7英寸超视网膜XDR显示屏",
    "price": 9999.00,
    "stock": 50,
    "category": "手机",
    "imageUrl": "https://images.unsplash.com/photo-1678652197831-2d180705cd2c?w=400&h=400&fit=crop",
    "createdAt": "2025-12-27T10:00:00",
    "updatedAt": "2025-12-27T10:00:00"
}
```

#### 状态码
- `200 OK`: 成功
- `404 Not Found`: 商品不存在

---

### 3. 创建商品

#### 请求
```http
POST /api/products
Content-Type: application/json
```

#### 请求体
```json
{
    "name": "新商品",
    "description": "商品描述",
    "price": 999.00,
    "stock": 100,
    "category": "手机",
    "imageUrl": "https://example.com/image.jpg"
}
```

#### 字段说明
| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| name | String | 是 | 商品名称，最大255字符 |
| description | String | 否 | 商品描述 |
| price | BigDecimal | 是 | 商品价格，精度10,2 |
| stock | Integer | 是 | 库存数量 |
| category | String | 否 | 商品分类，最大100字符 |
| imageUrl | String | 否 | 图片URL，最大500字符 |

#### 响应
```json
{
    "id": 41,
    "name": "新商品",
    "description": "商品描述",
    "price": 999.00,
    "stock": 100,
    "category": "手机",
    "imageUrl": "https://example.com/image.jpg",
    "createdAt": "2025-12-27T15:30:00",
    "updatedAt": "2025-12-27T15:30:00"
}
```

#### 状态码
- `201 Created`: 创建成功
- `400 Bad Request`: 请求参数错误

---

### 4. 更新商品

#### 请求
```http
PUT /api/products/{id}
Content-Type: application/json
```

#### 路径参数
| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | Long | 是 | 商品ID |

#### 请求体
```json
{
    "name": "更新后的商品名",
    "description": "更新后的描述",
    "price": 1299.00,
    "stock": 80,
    "category": "手机",
    "imageUrl": "https://example.com/new-image.jpg"
}
```

#### 示例
```http
PUT /api/products/1
Content-Type: application/json

{
    "name": "iPhone 15 Pro Max (更新)",
    "description": "更新后的描述",
    "price": 9499.00,
    "stock": 45,
    "category": "手机",
    "imageUrl": "https://example.com/iphone.jpg"
}
```

#### 响应
```json
{
    "id": 1,
    "name": "iPhone 15 Pro Max (更新)",
    "description": "更新后的描述",
    "price": 9499.00,
    "stock": 45,
    "category": "手机",
    "imageUrl": "https://example.com/iphone.jpg",
    "createdAt": "2025-12-27T10:00:00",
    "updatedAt": "2025-12-27T16:00:00"
}
```

#### 状态码
- `200 OK`: 更新成功
- `404 Not Found`: 商品不存在
- `400 Bad Request`: 请求参数错误

---

### 5. 删除商品

#### 请求
```http
DELETE /api/products/{id}
```

#### 路径参数
| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | Long | 是 | 商品ID |

#### 示例
```http
DELETE /api/products/1
```

#### 响应
```
无响应体
```

#### 状态码
- `204 No Content`: 删除成功
- `404 Not Found`: 商品不存在

---

### 6. 按分类查询商品

#### 请求
```http
GET /api/products/category/{category}
```

#### 路径参数
| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| category | String | 是 | 商品分类 |

#### 示例
```http
GET /api/products/category/手机
```

#### 响应
```json
[
    {
        "id": 1,
        "name": "iPhone 15 Pro Max",
        "description": "苹果最新旗舰手机",
        "price": 9999.00,
        "stock": 50,
        "category": "手机",
        "imageUrl": "https://example.com/iphone.jpg",
        "createdAt": "2025-12-27T10:00:00",
        "updatedAt": "2025-12-27T10:00:00"
    },
    {
        "id": 2,
        "name": "小米14 Pro",
        "description": "骁龙8 Gen3",
        "price": 4999.00,
        "stock": 70,
        "category": "手机",
        "imageUrl": "https://example.com/xiaomi.jpg",
        "createdAt": "2025-12-27T10:00:00",
        "updatedAt": "2025-12-27T10:00:00"
    }
]
```

#### 状态码
- `200 OK`: 成功

---

### 7. 搜索商品

#### 请求
```http
GET /api/products/search?keyword={keyword}
```

#### 查询参数
| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| keyword | String | 是 | 搜索关键词 |

#### 示例
```http
GET /api/products/search?keyword=iPhone
```

#### 响应
```json
[
    {
        "id": 1,
        "name": "iPhone 15 Pro Max",
        "description": "苹果最新旗舰手机",
        "price": 9999.00,
        "stock": 50,
        "category": "手机",
        "imageUrl": "https://example.com/iphone.jpg",
        "createdAt": "2025-12-27T10:00:00",
        "updatedAt": "2025-12-27T10:00:00"
    },
    {
        "id": 2,
        "name": "iPhone 15",
        "description": "A16仿生芯片",
        "price": 5999.00,
        "stock": 80,
        "category": "手机",
        "imageUrl": "https://example.com/iphone15.jpg",
        "createdAt": "2025-12-27T10:00:00",
        "updatedAt": "2025-12-27T10:00:00"
    }
]
```

#### 状态码
- `200 OK`: 成功

---

## 健康检查 API

### 获取应用健康状态

#### 请求
```http
GET /actuator/health
```

#### 响应
```json
{
    "status": "UP",
    "components": {
        "db": {
            "status": "UP",
            "details": {
                "database": "MySQL",
                "validationQuery": "isValid()"
            }
        },
        "diskSpace": {
            "status": "UP",
            "details": {
                "total": 499963174912,
                "free": 123456789012,
                "threshold": 10485760,
                "exists": true
            }
        },
        "ping": {
            "status": "UP"
        }
    }
}
```

#### 状态码
- `200 OK`: 应用健康
- `503 Service Unavailable`: 应用不健康

---

## 错误响应

### 错误格式
```json
{
    "timestamp": "2025-12-27T16:00:00",
    "status": 404,
    "error": "Not Found",
    "message": "商品不存在: 999",
    "path": "/api/products/999"
}
```

### 常见错误码
| 状态码 | 说明 |
|--------|------|
| 400 | 请求参数错误 |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |
| 503 | 服务不可用 |

---

## 使用示例

### cURL 示例

#### 获取所有商品
```bash
curl http://localhost:8080/api/products
```

#### 获取商品详情
```bash
curl http://localhost:8080/api/products/1
```

#### 创建商品
```bash
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "新商品",
    "description": "商品描述",
    "price": 999.00,
    "stock": 100,
    "category": "手机",
    "imageUrl": "https://example.com/image.jpg"
  }'
```

#### 更新商品
```bash
curl -X PUT http://localhost:8080/api/products/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "更新后的商品",
    "description": "更新后的描述",
    "price": 1299.00,
    "stock": 80,
    "category": "手机",
    "imageUrl": "https://example.com/new-image.jpg"
  }'
```

#### 删除商品
```bash
curl -X DELETE http://localhost:8080/api/products/1
```

#### 搜索商品
```bash
curl "http://localhost:8080/api/products/search?keyword=iPhone"
```

### JavaScript 示例

#### 获取所有商品
```javascript
fetch('http://localhost:8080/api/products')
  .then(response => response.json())
  .then(data => console.log(data))
  .catch(error => console.error('Error:', error));
```

#### 创建商品
```javascript
fetch('http://localhost:8080/api/products', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    name: '新商品',
    description: '商品描述',
    price: 999.00,
    stock: 100,
    category: '手机',
    imageUrl: 'https://example.com/image.jpg'
  })
})
  .then(response => response.json())
  .then(data => console.log(data))
  .catch(error => console.error('Error:', error));
```

---

## 数据模型

### Product (商品)

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 商品ID（主键，自增） |
| name | String(255) | 商品名称（必填） |
| description | Text | 商品描述 |
| price | Decimal(10,2) | 商品价格（必填） |
| stock | Integer | 库存数量（必填，默认0） |
| category | String(100) | 商品分类 |
| imageUrl | String(500) | 图片URL |
| createdAt | Timestamp | 创建时间（自动生成） |
| updatedAt | Timestamp | 更新时间（自动更新） |

---

## 注意事项

1. **CORS**: 后端已配置 `@CrossOrigin(origins = "*")`，允许跨域请求
2. **字符编码**: 所有请求和响应使用 UTF-8 编码
3. **时间格式**: ISO 8601 格式 `yyyy-MM-dd'T'HH:mm:ss`
4. **价格精度**: 使用 BigDecimal，精度为 10,2
5. **图片URL**: 建议使用 HTTPS 协议
6. **搜索**: 支持商品名称模糊搜索
7. **分类**: 区分大小写
