# 多阶段构建 - 构建阶段（如果需要构建前端资源）
FROM node:18-alpine AS builder

WORKDIR /app

# 这里可以添加前端构建步骤（如果使用React/Vue等）
# COPY package*.json ./
# RUN npm install
# COPY . .
# RUN npm run build

# 运行阶段 - 使用轻量级Nginx Alpine镜像
FROM nginx:1.25-alpine

# 删除默认的nginx配置
RUN rm /etc/nginx/conf.d/default.conf

# 复制自定义nginx配置
COPY nginx.conf /etc/nginx/conf.d/

# 复制静态文件到nginx目录
COPY html/ /usr/share/nginx/html/

# 创建健康检查页面
RUN echo "OK" > /usr/share/nginx/html/health.html

# 暴露80端口
EXPOSE 80

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/health.html || exit 1

# 启动nginx
CMD ["nginx", "-g", "daemon off;"]
