package com.ecommerce.repository;

import com.ecommerce.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

/**
 * 商品数据访问层
 */
@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    
    /**
     * 根据分类查询商品
     */
    List<Product> findByCategory(String category);
    
    /**
     * 根据名称模糊查询
     */
    List<Product> findByNameContaining(String name);
}
