package com.thedeveloper.gnext.service;

import com.thedeveloper.gnext.entity.FilterEntity;
import com.thedeveloper.gnext.repository.FilterRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
@Slf4j
public class FilterService {
    FilterRepository repository;
    public FilterEntity findByWord(String word){
        log.info("Finding word|{}", word);
        return repository.searchFilterEntityByWordContaining(word);
    }
    public List<FilterEntity> findAll(){
        return repository.findAll();
    }
    public void delete(FilterEntity filterEntity){
        repository.delete(filterEntity);
    }
    public void save(FilterEntity filterEntity){
        repository.save(filterEntity);
    }
    public FilterEntity findById(Long id){
        return repository.findFilterEntityById(id);
    }
}
