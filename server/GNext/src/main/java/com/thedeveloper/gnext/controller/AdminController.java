package com.thedeveloper.gnext.controller;

import com.thedeveloper.gnext.controller.models.StatisticModel;
import com.thedeveloper.gnext.entity.*;
import com.thedeveloper.gnext.enums.Categories;
import com.thedeveloper.gnext.enums.UserRole;
import com.thedeveloper.gnext.service.*;
import com.thedeveloper.gnext.utils.Globals;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("api/v1/admin")
@AllArgsConstructor
@Slf4j
public class AdminController {
    PasswordEncoder passwordEncoder;
    UserService userService;
    MessageService messageService;
    OrderService orderService;
    CountryService countryService;
    CityService cityService;
    ChatService chatService;
    LocationService locationService;
    FilterService filterService;
    CompanyService companyService;
    AddressService addressService;
    ImageService fileService;
    @GetMapping("/login")
    public ResponseEntity<?> login(@RequestParam String phone, @RequestParam String password){
        log.info("Phone admin {}", phone);
        UserEntity user = userService.findUserByPhone(phone);
        if(user==null) return new ResponseEntity<>("Пользователя не существует", HttpStatus.BAD_REQUEST);
        if(!passwordEncoder.matches(password, user.getPassword())) return new ResponseEntity<>("Неверный пароль", HttpStatus.BAD_REQUEST);
        if(user.getRole()==UserRole.USER || user.getRole() == UserRole.SPECIALIST) return new ResponseEntity<>("Вход разрешен только для администратора", HttpStatus.BAD_REQUEST);

        return new ResponseEntity<>(user, HttpStatus.OK);
    }
    @GetMapping("/stat")
    public ResponseEntity<?> stat(){
        StatisticModel stat = new StatisticModel();
        stat.setUserCount(userService.findAll().size());
        stat.setChatCount(chatService.findAll().size());
        stat.setMessagesCount(messageService.findAll().size());
        stat.setCountryCount(countryService.findAll().size());
        stat.setCityCount(cityService.findAll().size());
        stat.setAllOrders(orderService.findAll().size());
        stat.setActiveOrders(orderService.findActive().size());
        return new ResponseEntity<>(stat, HttpStatus.OK);
    }
    @GetMapping("/users")
    public ResponseEntity<?> users(@RequestParam(required = false) String query){
        if(query==null || query.isEmpty()){
            return new ResponseEntity<>(userService.findAll(), HttpStatus.OK);
        }else{
            return new ResponseEntity<>(userService.searchByQuery(query), HttpStatus.OK);
        }
    }
    @GetMapping("/chats")
    public ResponseEntity<?> chats(@RequestParam Long countryId,@RequestParam Long cityId){
        CountryEntity country = countryService.findById(countryId);
        CityEntity city = cityService.findById(cityId);
        LocationEntity location = locationService.findByCountryAndCity(country,city);
        return new ResponseEntity<>(chatService.findGlobals(location), HttpStatus.OK);
    }
    @GetMapping("/chats/messages")
        public ResponseEntity<?> messages(@RequestParam Long countryId, @RequestParam Long cityId, @RequestParam String name){
        CountryEntity country = countryService.findById(countryId);
        CityEntity city = cityService.findById(cityId);
        LocationEntity location = locationService.findByCountryAndCity(country,city);
        ChatEntity chat = chatService.findChatByLocationAndName(location, name);
        return new ResponseEntity<>(messageService.findMessagesByChat(chat), HttpStatus.OK);
    }
    @GetMapping("/filters")
    public ResponseEntity<?> filters(){
        return new ResponseEntity<>(filterService.findAll(), HttpStatus.OK);
    }
    @PostMapping("/filters/add")
    public ResponseEntity<?> filtersAdd(@RequestParam String word){
        FilterEntity filterEntity = new FilterEntity();
        filterEntity.setWord(word.toLowerCase().replaceAll(" ",""));
        filterService.save(filterEntity);
        Globals.filterMessages(messageService, filterService);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }
    @DeleteMapping("/filters/delete")
    public ResponseEntity<?> filtersDelete(@RequestParam Long id){
        FilterEntity filterEntity = filterService.findById(id);
        filterService.delete(filterEntity);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @GetMapping("/companies")
    public ResponseEntity<?> findCompanies(@RequestParam Long countryId, @RequestParam Long cityId,@RequestParam Categories category){
        CountryEntity country = countryService.findById(countryId);
        CityEntity city = cityService.findById(cityId);
        LocationEntity location = locationService.findByCountryAndCity(country,city);
        return new ResponseEntity<>(companyService.findByCategory(category,location),HttpStatus.OK);
    }
    @PostMapping("/companies/add")
    public ResponseEntity<?> addCompany(@RequestParam Long countryId, @RequestParam Long cityId, @RequestParam Categories category, @RequestParam String name, @RequestParam String phone, @RequestParam String street, @RequestParam String house, @RequestBody(required = false)MultipartFile photo){
        CountryEntity country = countryService.findById(countryId);
        CityEntity city = cityService.findById(cityId);
        LocationEntity location = locationService.findByCountryAndCity(country,city);
        CompanyEntity company = new CompanyEntity();
        company.setLocation(location);
        company.setName(name);
        company.setPhone(phone);
        if(photo!=null){
            fileService.store(photo);
            String _name = Globals.renameFile(photo.getOriginalFilename(), fileService);
            company.setImage(_name);
        }
        AddressEntity address = new AddressEntity();
        address.setCity(location.getCity().getName());
        address.setStreet(street);
        address.setHouse(house);
        addressService.save(address);
        company.setAddress(address);
        company.setCategory(category);
        companyService.save(company);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }
    @PostMapping("/setManager")
    public ResponseEntity<?> setManager(@RequestParam String uid, @RequestParam Long id){
        CompanyEntity company = companyService.findById(id);
        if(company.getManager()!=null){
            UserEntity old_manager = company.getManager();
            old_manager.setRole(UserRole.USER);
            userService.save(old_manager);
        }
        UserEntity user  = userService.findUserByUid(uid);
        user.setRole(UserRole.MANAGER);
        userService.save(user);
        company.setManager(user);
        companyService.save(company);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @PostMapping("/changeRole")
    public ResponseEntity<?> changeRole(@RequestParam String uid, @RequestParam UserRole role){
        UserEntity user = userService.findUserByUid(uid);
        user.setRole(role);
        userService.save(user);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @DeleteMapping("/companies/delete")
    public ResponseEntity<?> deleteCompany(@RequestParam Long id){
        CompanyEntity company = companyService.findById(id);
        companyService.delete(company);
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
