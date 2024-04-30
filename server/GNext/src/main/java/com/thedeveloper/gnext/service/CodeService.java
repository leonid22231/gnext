package com.thedeveloper.gnext.service;

import com.thedeveloper.gnext.entity.CodeEntity;
import com.thedeveloper.gnext.entity.UserEntity;
import com.thedeveloper.gnext.enums.CodeStatus;
import com.thedeveloper.gnext.repository.CodeRepository;
import com.thedeveloper.gnext.utils.Globals;
import com.thedeveloper.gnext.utils.MessageUtils;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.net.URISyntaxException;
import java.util.Date;
import java.util.List;

@Service
@AllArgsConstructor
public class CodeService {
    CodeRepository repository;
    public void save(CodeEntity code){
        repository.save(code);
    }
    public String sendCode(UserEntity user){
        List<CodeEntity> existCode = repository.findCodeEntitiesByUser(user);
        if(!existCode.isEmpty()){
            for(CodeEntity code : existCode){
                if(code.getStatus().equals(CodeStatus.WAIT)){
                    code.setStatus(CodeStatus.CLOSE);
                    code.setEndDate(new Date());
                    repository.save(code);
                }
            }
        }
        CodeEntity codeEntity = new CodeEntity();
        codeEntity.setUser(user);
        codeEntity.setCode(Globals.codeGenerator());
        codeEntity.setSendDate(new Date());
        codeEntity.setStatus(CodeStatus.WAIT);
        repository.save(codeEntity);
        try {
            MessageUtils.sendMessageRegisterCode(user.getPhone(), codeEntity.getCode());
            return codeEntity.getCode();
        } catch (IOException | URISyntaxException | InterruptedException e) {
            throw new RuntimeException(e);
        }
    }
    public String sendCode(UserEntity user,String fake_code){
        List<CodeEntity> existCode = repository.findCodeEntitiesByUser(user);
        if(!existCode.isEmpty()){
            for(CodeEntity code : existCode){
                if(code.getStatus().equals(CodeStatus.WAIT)){
                    code.setStatus(CodeStatus.CLOSE);
                    code.setEndDate(new Date());
                    repository.save(code);
                }
            }
        }
        CodeEntity codeEntity = new CodeEntity();
        codeEntity.setUser(user);
        codeEntity.setCode(fake_code);
        codeEntity.setSendDate(new Date());
        codeEntity.setStatus(CodeStatus.WAIT);
        repository.save(codeEntity);
        try {
            MessageUtils.sendMessageRegisterCode(user.getPhone(), codeEntity.getCode());
            return codeEntity.getCode();
        } catch (IOException | URISyntaxException | InterruptedException e) {
            throw new RuntimeException(e);
        }
    }
    public CodeEntity currentCodeUser(UserEntity user){
        return repository.findCodeEntitiesByUserAndStatus(user, CodeStatus.WAIT).get(0);
    }
    public List<CodeEntity> findCodesByUser(UserEntity user){
        return repository.findCodeEntitiesByUser(user);
    }
}
