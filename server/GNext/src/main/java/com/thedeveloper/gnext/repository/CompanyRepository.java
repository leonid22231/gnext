package com.thedeveloper.gnext.repository;

import com.thedeveloper.gnext.entity.CompanyEntity;
import com.thedeveloper.gnext.entity.LocationEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.enums.Categories;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CompanyRepository extends JpaRepository<CompanyEntity, Long> {
    List<CompanyEntity> findCompanyEntityByCategoryAndLocation(Categories category, LocationEntity location);
    CompanyEntity findCompanyEntityById(Long id);
    CompanyEntity findCompanyEntityByManager(UserEntity user);
}
