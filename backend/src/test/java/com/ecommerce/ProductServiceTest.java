package com.ecommerce;

import com.ecommerce.entity.Product;
import com.ecommerce.repository.ProductRepository;
import com.ecommerce.service.ProductService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * 商品服务单元测试 - 使用Mockito纯单元测试
 */
@ExtendWith(MockitoExtension.class)
public class ProductServiceTest {
    
    @Mock
    private ProductRepository productRepository;
    
    @InjectMocks
    private ProductService productService;
    
    private Product testProduct1;
    private Product testProduct2;
    
    @BeforeEach
    void setUp() {
        testProduct1 = new Product();
        testProduct1.setId(1L);
        testProduct1.setName("测试商品1");
        testProduct1.setPrice(new BigDecimal("99.99"));
        testProduct1.setStock(10);
        
        testProduct2 = new Product();
        testProduct2.setId(2L);
        testProduct2.setName("测试商品2");
        testProduct2.setPrice(new BigDecimal("199.99"));
        testProduct2.setStock(20);
    }

    @Test
    void testGetAllProducts() {
        // 准备测试数据
        when(productRepository.findAll()).thenReturn(Arrays.asList(testProduct1, testProduct2));
        
        // 执行测试
        List<Product> products = productService.getAllProducts();
        
        // 验证结果
        assertNotNull(products);
        assertEquals(2, products.size());
        assertEquals("测试商品1", products.get(0).getName());
        verify(productRepository, times(1)).findAll();
    }
    
    @Test
    void testGetProductById() {
        // 准备测试数据
        when(productRepository.findById(1L)).thenReturn(Optional.of(testProduct1));
        
        // 执行测试
        Optional<Product> result = productService.getProductById(1L);
        
        // 验证结果
        assertTrue(result.isPresent());
        assertEquals("测试商品1", result.get().getName());
        assertEquals(new BigDecimal("99.99"), result.get().getPrice());
        verify(productRepository, times(1)).findById(1L);
    }
    
    @Test
    void testGetProductByIdNotFound() {
        // 准备测试数据
        when(productRepository.findById(999L)).thenReturn(Optional.empty());
        
        // 执行测试
        Optional<Product> result = productService.getProductById(999L);
        
        // 验证结果
        assertFalse(result.isPresent());
        verify(productRepository, times(1)).findById(999L);
    }
    
    @Test
    void testCreateProduct() {
        // 准备测试数据
        Product newProduct = new Product();
        newProduct.setName("新商品");
        newProduct.setPrice(new BigDecimal("299.99"));
        newProduct.setStock(50);
        
        when(productRepository.save(any(Product.class))).thenReturn(newProduct);
        
        // 执行测试
        Product created = productService.createProduct(newProduct);
        
        // 验证结果
        assertNotNull(created);
        assertEquals("新商品", created.getName());
        assertEquals(new BigDecimal("299.99"), created.getPrice());
        verify(productRepository, times(1)).save(newProduct);
    }
    
    @Test
    void testDeleteProduct() {
        // 执行测试
        doNothing().when(productRepository).deleteById(1L);
        productService.deleteProduct(1L);
        
        // 验证结果
        verify(productRepository, times(1)).deleteById(1L);
    }
    
    @Test
    void testSearchProducts() {
        // 准备测试数据
        when(productRepository.findByNameContaining("测试")).thenReturn(Arrays.asList(testProduct1, testProduct2));
        
        // 执行测试
        List<Product> results = productService.searchProducts("测试");
        
        // 验证结果
        assertNotNull(results);
        assertEquals(2, results.size());
        verify(productRepository, times(1)).findByNameContaining("测试");
    }
}
