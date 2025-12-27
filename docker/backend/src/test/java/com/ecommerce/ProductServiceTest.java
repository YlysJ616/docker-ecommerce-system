package com.ecommerce;

import com.ecommerce.entity.Product;
import com.ecommerce.repository.ProductRepository;
import com.ecommerce.service.ProductService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * 商品服务单元测试
 */
@SpringBootTest
public class ProductServiceTest {
    
    @Autowired
    private ProductService productService;
    
    @MockBean
    private ProductRepository productRepository;
    
    @Test
    public void testGetAllProducts() {
        // 准备测试数据
        Product product1 = new Product();
        product1.setId(1L);
        product1.setName("测试商品1");
        product1.setPrice(new BigDecimal("99.99"));
        
        Product product2 = new Product();
        product2.setId(2L);
        product2.setName("测试商品2");
        product2.setPrice(new BigDecimal("199.99"));
        
        when(productRepository.findAll()).thenReturn(Arrays.asList(product1, product2));
        
        // 执行测试
        List<Product> products = productService.getAllProducts();
        
        // 验证结果
        assertEquals(2, products.size());
        verify(productRepository, times(1)).findAll();
    }
    
    @Test
    public void testGetProductById() {
        Product product = new Product();
        product.setId(1L);
        product.setName("测试商品");
        
        when(productRepository.findById(1L)).thenReturn(Optional.of(product));
        
        Optional<Product> result = productService.getProductById(1L);
        
        assertTrue(result.isPresent());
        assertEquals("测试商品", result.get().getName());
    }
    
    @Test
    public void testCreateProduct() {
        Product product = new Product();
        product.setName("新商品");
        product.setPrice(new BigDecimal("299.99"));
        
        when(productRepository.save(any(Product.class))).thenReturn(product);
        
        Product created = productService.createProduct(product);
        
        assertNotNull(created);
        assertEquals("新商品", created.getName());
        verify(productRepository, times(1)).save(product);
    }
}
