package com.thedeveloper.gnext.controller;

import com.thedeveloper.gnext.service.FileService;
import com.thedeveloper.gnext.service.ImageService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/v1/file")
@AllArgsConstructor
@Slf4j
@EnableAsync
public class FileController {
    ImageService imageService;
    FileService fileService;
    @Async
    @GetMapping("/image/{name}")
    public ResponseEntity<?> getAvatar(@PathVariable String name){
            try {
                Resource image = imageService.loadAsResource(name);
                return  ResponseEntity.ok().contentType(MediaType.IMAGE_PNG).body(image);
            }catch (Exception e){
                log.debug("Image Error {}", e.toString());
                return new ResponseEntity<>(HttpStatus.NOT_FOUND);
            }
    }
    @GetMapping("/file/{name}")
    @ResponseBody
    @Async
    public ResponseEntity<Resource> serveFile(@PathVariable String name) {
        Resource file = fileService.loadAsResource(name);

        if (file == null)
            return ResponseEntity.notFound().build();

        return ResponseEntity.ok().header(HttpHeaders.CONTENT_DISPOSITION,
                "attachment; filename=\"" + file.getFilename() + "\"").body(file);
    }

}
