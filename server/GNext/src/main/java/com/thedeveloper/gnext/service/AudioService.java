package com.thedeveloper.gnext.service;

import com.thedeveloper.gnext.utils.storage.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.util.FileSystemUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.stream.Stream;

@Service
@Slf4j
public class AudioService implements StorageService {
    private final Path rootLocation;

    public AudioService(AudioProperties properties) {
        this.rootLocation = Paths.get(properties.getLocation());
    }

    @Override
    public void init() {
        log.info("Audio INIT Abs: "+rootLocation.toAbsolutePath());
        try {
            Files.createDirectories(rootLocation);
        }
        catch (IOException e) {
            throw new StorageException("Could not initialize storage", e);
        }
    }

    @Override
    public String getPath() {
        return this.rootLocation.toString();
    }

    @Override
    public void store(MultipartFile file) {
        if (file.isEmpty()) {
            throw new StorageException("Failed to store empty file.");
        }
        Path destinationFile = this.rootLocation.resolve(
                        Paths.get(file.getOriginalFilename()))
                .normalize().toAbsolutePath();
        File filel = new File(rootLocation.toAbsolutePath().toString(), file.getOriginalFilename());
        log.info("File to "+filel.getAbsolutePath());
        if (!destinationFile.getParent().equals(this.rootLocation.toAbsolutePath())) {
            // This is a security check
            throw new StorageException(
                    "Cannot store file outside current directory.");
        }
        try {
            saveFileInFileSystem(file);
        }catch (Exception h){
            log.error("Error " + h);
        }
    }
    public void saveFileInFileSystem(MultipartFile file) throws IOException {
        System.out.println("Uploading file to local file system: {}"+ file.getOriginalFilename());

        if (!Files.exists(rootLocation)) {
            Files.createDirectories(rootLocation);
        }

        try (InputStream inputStream = file.getInputStream()) {
            String filenameWithExtension = Paths.get(file.getOriginalFilename()).getFileName().toString();
            Path path = rootLocation.resolve(filenameWithExtension);
            Files.copy(inputStream, path, StandardCopyOption.REPLACE_EXISTING);
        }
    }
    @Override
    public Stream<Path> loadAll() {
        try {
            return Files.walk(this.rootLocation, 1)
                    .filter(path -> !path.equals(this.rootLocation))
                    .map(this.rootLocation::relativize);
        }
        catch (IOException e) {
            throw new StorageException("Failed to read stored files", e);
        }
    }

    @Override
    public Path load(String filename) {
        return rootLocation.resolve(filename);
    }

    @Override
    public Resource loadAsResource(String filename) {
        try {
            Path file = load(filename);
            Resource resource = new UrlResource(file.toUri());
            if (resource.exists() || resource.isReadable()) {
                return resource;
            }
            else {
                throw new StorageFileNotFoundException(
                        "Could not read file: " + filename);

            }
        }
        catch (MalformedURLException e) {
            throw new StorageFileNotFoundException("Could not read file: " + filename, e);
        }
    }

    @Override
    public void deleteAll() {
        FileSystemUtils.deleteRecursively(rootLocation.toFile());
    }
}
