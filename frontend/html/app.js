// API基础URL
const API_BASE_URL = '/api/products';

// 分页配置
let currentPage = 1;
const itemsPerPage = 12;
let allProducts = [];
let filteredProducts = [];

// 页面加载时获取所有商品
document.addEventListener('DOMContentLoaded', () => {
    loadProducts();
    setupFormSubmit();
});

// 加载所有商品
async function loadProducts() {
    try {
        const response = await fetch(API_BASE_URL);
        allProducts = await response.json();
        filteredProducts = allProducts;
        currentPage = 1;
        displayProducts();
    } catch (error) {
        console.error('加载商品失败:', error);
        alert('加载商品失败，请检查后端服务是否正常运行');
    }
}

// 显示商品列表（分页）
function displayProducts() {
    const productList = document.getElementById('productList');
    
    if (filteredProducts.length === 0) {
        productList.innerHTML = '<p style="grid-column: 1/-1; text-align: center; color: var(--text-secondary); padding: 3rem;">暂无商品</p>';
        document.getElementById('pagination').innerHTML = '';
        return;
    }
    
    // 计算分页
    const totalPages = Math.ceil(filteredProducts.length / itemsPerPage);
    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    const currentProducts = filteredProducts.slice(startIndex, endIndex);
    
    productList.innerHTML = currentProducts.map(product => `
        <div class="product-card">
            <img src="${product.imageUrl || 'https://via.placeholder.com/300x200?text=No+Image'}" 
                 alt="${product.name}" 
                 onclick="showProductDetail(${product.id})">
            <div class="product-info">
                <h3>${product.name}</h3>
                <p class="price">¥${product.price}</p>
                <p class="stock">库存: ${product.stock}</p>
                <p class="category">${product.category || '未分类'}</p>
            </div>
            <div class="product-actions">
                <button onclick="showEditForm(${product.id})">编辑</button>
                <button onclick="deleteProduct(${product.id})">删除</button>
            </div>
        </div>
    `).join('');
    
    // 显示分页
    renderPagination(totalPages);
}

// 渲染分页组件
function renderPagination(totalPages) {
    const pagination = document.getElementById('pagination');
    
    if (totalPages <= 1) {
        pagination.innerHTML = '';
        return;
    }
    
    let paginationHTML = '<div class="pagination-info">第 ' + currentPage + ' 页，共 ' + totalPages + ' 页（' + filteredProducts.length + ' 个商品）</div>';
    paginationHTML += '<div class="pagination-buttons">';
    
    // 上一页按钮
    paginationHTML += `<button onclick="changePage(${currentPage - 1})" ${currentPage === 1 ? 'disabled' : ''}>上一页</button>`;
    
    // 页码按钮
    const maxVisiblePages = 5;
    let startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
    let endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);
    
    if (endPage - startPage < maxVisiblePages - 1) {
        startPage = Math.max(1, endPage - maxVisiblePages + 1);
    }
    
    if (startPage > 1) {
        paginationHTML += `<button onclick="changePage(1)">1</button>`;
        if (startPage > 2) {
            paginationHTML += `<span class="pagination-ellipsis">...</span>`;
        }
    }
    
    for (let i = startPage; i <= endPage; i++) {
        paginationHTML += `<button onclick="changePage(${i})" class="${i === currentPage ? 'active' : ''}">${i}</button>`;
    }
    
    if (endPage < totalPages) {
        if (endPage < totalPages - 1) {
            paginationHTML += `<span class="pagination-ellipsis">...</span>`;
        }
        paginationHTML += `<button onclick="changePage(${totalPages})">${totalPages}</button>`;
    }
    
    // 下一页按钮
    paginationHTML += `<button onclick="changePage(${currentPage + 1})" ${currentPage === totalPages ? 'disabled' : ''}>下一页</button>`;
    
    paginationHTML += '</div>';
    pagination.innerHTML = paginationHTML;
}

// 切换页码
function changePage(page) {
    const totalPages = Math.ceil(filteredProducts.length / itemsPerPage);
    if (page < 1 || page > totalPages) return;
    
    currentPage = page;
    displayProducts();
    
    // 滚动到顶部
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

// 显示商品详情
async function showProductDetail(id) {
    try {
        const response = await fetch(`${API_BASE_URL}/${id}`);
        const product = await response.json();
        
        document.getElementById('productDetail').innerHTML = `
            <h2>${product.name}</h2>
            <img src="${product.imageUrl || 'https://via.placeholder.com/400x300'}" 
                 style="width: 100%; max-height: 300px; object-fit: cover; margin: 20px 0;">
            <p><strong>价格:</strong> ¥${product.price}</p>
            <p><strong>库存:</strong> ${product.stock}</p>
            <p><strong>分类:</strong> ${product.category || '未分类'}</p>
            <p><strong>描述:</strong> ${product.description || '暂无描述'}</p>
            <p><strong>创建时间:</strong> ${new Date(product.createdAt).toLocaleString()}</p>
        `;
        
        document.getElementById('detailModal').style.display = 'block';
    } catch (error) {
        console.error('加载商品详情失败:', error);
        alert('加载商品详情失败');
    }
}

// 关闭详情模态框
function closeModal() {
    document.getElementById('detailModal').style.display = 'none';
}

// 显示添加表单
function showAddForm() {
    document.getElementById('formTitle').textContent = '添加商品';
    document.getElementById('productForm').reset();
    document.getElementById('productId').value = '';
    document.getElementById('formModal').style.display = 'block';
}

// 显示编辑表单
async function showEditForm(id) {
    try {
        const response = await fetch(`${API_BASE_URL}/${id}`);
        const product = await response.json();
        
        document.getElementById('formTitle').textContent = '编辑商品';
        document.getElementById('productId').value = product.id;
        document.getElementById('productName').value = product.name;
        document.getElementById('productDescription').value = product.description || '';
        document.getElementById('productPrice').value = product.price;
        document.getElementById('productStock').value = product.stock;
        document.getElementById('productCategory').value = product.category || '';
        document.getElementById('productImageUrl').value = product.imageUrl || '';
        
        document.getElementById('formModal').style.display = 'block';
    } catch (error) {
        console.error('加载商品信息失败:', error);
        alert('加载商品信息失败');
    }
}

// 关闭表单模态框
function closeFormModal() {
    document.getElementById('formModal').style.display = 'none';
}

// 设置表单提交
function setupFormSubmit() {
    document.getElementById('productForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const id = document.getElementById('productId').value;
        const product = {
            name: document.getElementById('productName').value,
            description: document.getElementById('productDescription').value,
            price: parseFloat(document.getElementById('productPrice').value),
            stock: parseInt(document.getElementById('productStock').value),
            category: document.getElementById('productCategory').value,
            imageUrl: document.getElementById('productImageUrl').value
        };
        
        try {
            let response;
            if (id) {
                // 更新商品
                response = await fetch(`${API_BASE_URL}/${id}`, {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(product)
                });
            } else {
                // 创建商品
                response = await fetch(API_BASE_URL, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(product)
                });
            }
            
            if (response.ok) {
                alert(id ? '商品更新成功' : '商品创建成功');
                closeFormModal();
                loadProducts();
            } else {
                alert('操作失败');
            }
        } catch (error) {
            console.error('保存商品失败:', error);
            alert('保存商品失败');
        }
    });
}

// 删除商品
async function deleteProduct(id) {
    if (!confirm('确定要删除这个商品吗？')) return;
    
    try {
        const response = await fetch(`${API_BASE_URL}/${id}`, {
            method: 'DELETE'
        });
        
        if (response.ok) {
            alert('商品删除成功');
            loadProducts();
        } else {
            alert('删除失败');
        }
    } catch (error) {
        console.error('删除商品失败:', error);
        alert('删除商品失败');
    }
}

// 搜索商品
async function searchProducts() {
    const keyword = document.getElementById('searchInput').value.toLowerCase();
    if (!keyword) {
        filteredProducts = allProducts;
    } else {
        filteredProducts = allProducts.filter(product => 
            product.name.toLowerCase().includes(keyword) || 
            (product.description && product.description.toLowerCase().includes(keyword))
        );
    }
    currentPage = 1;
    displayProducts();
}

// 按分类筛选
async function filterByCategory() {
    const category = document.getElementById('categoryFilter').value;
    if (!category) {
        filteredProducts = allProducts;
    } else {
        filteredProducts = allProducts.filter(product => product.category === category);
    }
    currentPage = 1;
    displayProducts();
}

// 显示所有商品
function showAllProducts() {
    document.getElementById('searchInput').value = '';
    document.getElementById('categoryFilter').value = '';
    filteredProducts = allProducts;
    currentPage = 1;
    displayProducts();
}
