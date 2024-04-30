package com.thedeveloper.gnext.repository;

import com.thedeveloper.gnext.entity.FilterEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FilterRepository extends JpaRepository<FilterEntity, Long> {
    FilterEntity searchFilterEntityByWordContaining(String word);
    FilterEntity findFilterEntityById(Long id);
}
