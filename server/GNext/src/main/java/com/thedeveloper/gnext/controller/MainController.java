package com.thedeveloper.gnext.controller;

import com.thedeveloper.gnext.entity.*;
import com.thedeveloper.gnext.enums.*;
import com.thedeveloper.gnext.service.*;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.thedeveloper.gnext.utils.Globals;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("api/v1/user")
@AllArgsConstructor
@Slf4j
public class MainController {
    TransportationService transportationService;
    UserService userService;
    PasswordEncoder passwordEncoder;
    ImageService imageService;
    CountryService countryService;
    CityService cityService;
    WalletEventService walletEventService;
    ChatService chatService;
    CompanyService companyService;
    MessageService messageService;
    CodeService codeService;
    FileService fileService;
    AddressService addressService;
    OrderService orderService;
    StorisService storisService;
    @GetMapping("/login")
    public ResponseEntity<?> login(@RequestParam String phone, @RequestParam String password){
        UserEntity user = userService.findUserByPhone(phone);
        if(user==null) return new ResponseEntity<>("Пользователь не найден", HttpStatus.NOT_FOUND);
        if(user.isBlocked()) return new ResponseEntity<>("Пользователь заблокирован", HttpStatus.NOT_FOUND);
        if(!passwordEncoder.matches(password,user.getPassword())){
            return new ResponseEntity<>("Неверный пароль", HttpStatus.FORBIDDEN);
        }else{
            userService.save(user);
            return new ResponseEntity<>(user,HttpStatus.OK);
//            if(user.getId()!=6){
//                return new ResponseEntity<>(codeService.sendCode(user), HttpStatus.OK);
//            }
//            return new ResponseEntity<>(codeService.sendCode(user,"1111"), HttpStatus.OK);
        }
    }
    @PostMapping("/login")
    public ResponseEntity<?> loginConfirm(@RequestParam String phone, @RequestParam String uid,@RequestParam String notifyToken){
        return new ResponseEntity<>(saveUser(userService.findUserByPhone(phone), uid, notifyToken), HttpStatus.OK);
    }
    UserEntity saveUser(UserEntity user, String uid, String notifyToken){
        CodeEntity currentCode = codeService.currentCodeUser(user);
        currentCode.setStatus(CodeStatus.CLOSE);
        currentCode.setEndDate(new Date());
        codeService.save(currentCode);
        user.setUid(uid);
        user.setNotifyToken(notifyToken);
        userService.save(user);
        return  user;
    }

    @GetMapping("/uid")
    public ResponseEntity<?> getUid(@RequestParam String uid){
        UserEntity user = userService.findUserByUid(uid);
        if(user==null) return new ResponseEntity<>("Пользователь не найден", HttpStatus.NOT_FOUND);

        return new ResponseEntity<>(user, HttpStatus.OK);
    }
    @DeleteMapping("/deleteUser")
    public ResponseEntity<?> deleteUser(@RequestParam String uid){
        UserEntity user = userService.findUserByUid(uid);
        List<MessageEntity> userMessages = messageService.findAllMessagesByUser(user).stream().toList();
        for(MessageEntity messageEntity : userMessages){
            messageService.delete(messageEntity);
        }
        List<ChatEntity> allUserChats = chatService.findByUser(user).stream().toList();
        for(ChatEntity chatEntity : allUserChats){
            chatService.delete(chatEntity);
        }
        List<OrderEntity> orderEntities = orderService.findAllByUser(user).stream().toList();
        for(OrderEntity orderEntity : orderEntities){
            orderService.delete(orderEntity);
        }
        List<TransportationEntity> transportationEntities = transportationService.findAllByUser(user).stream().toList();
        for(TransportationEntity transportationEntity : transportationEntities){
            transportationService.delete(transportationEntity);
        }
        List<WalletEventEntity> walletEventEntities = walletEventService.findByUser(user).stream().toList();
        for(WalletEventEntity walletEventEntity : walletEventEntities){
            walletEventService.delete(walletEventEntity);
        }
        List<StorisEntity> storisEntities = storisService.findAllByUser(user).stream().toList();
        for(StorisEntity storisEntity : storisEntities){
            storisService.delete(storisEntity);
        }
        List<CodeEntity> codeEntities = codeService.findCodesByUser(user).stream().toList();
        for(CodeEntity codeEntity : codeEntities){
            codeService.delete(codeEntity);
        }
        for(MessageEntity message : messageService.findGetReaders(user)){
            for(int i = 0; i < message.getReaders().size(); i++){
                if(message.getReaders().get(i).getId().equals(user.getId())){
                    message.getReaders().remove(i);
                }
            }
            messageService.save(message);
        }
        userService.delete(user);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @PostMapping("/uid")
    public ResponseEntity<?> setUid(@RequestParam String phone, @RequestParam String uid){
        UserEntity user = userService.findUserByPhone(phone);
        if(user==null) return new ResponseEntity<>("Пользователь не найден", HttpStatus.NOT_FOUND);
        user.setUid(uid);
        userService.save(user);
        return new ResponseEntity<>(user, HttpStatus.OK);
    }
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestParam UserRole role,@RequestParam String phone, @RequestParam String password, @RequestParam String name, @RequestParam String surname,@RequestParam(required = false) String number,@RequestParam Long countryId, @RequestParam Long cityId, @RequestParam String uid,@RequestParam String notifyToken, @RequestBody(required = false) MultipartFile photo){
        if(userService.findUserByPhone(phone)!=null){
            return new ResponseEntity<>("Пользователь существует", HttpStatus.FORBIDDEN);
        }else{
            UserEntity user = new UserEntity();
            user.setRole(role);
            user.setName(name);
            user.setSurname(surname);
            user.setUid(uid);
            if(role==UserRole.SPECIALIST){
                user.setSubscription(true);
            }
            user.setCity(cityService.findById(cityId));
            if(number!=null) user.setNumber(number);
            user.setNotifyToken(notifyToken);
            user.setPhone(phone);
            user.setPassword(passwordEncoder.encode(password));
            if(photo!=null){
                imageService.store(photo);
                String photo_ = Globals.renameFile(photo.getOriginalFilename(), imageService);
                user.setPhoto(photo_);
            }
            user.setCreateDate(new Date());
            user.setSubStart(user.getCreateDate());
            log.info(user.toString());
            userService.save(user);
        }
        return new ResponseEntity<>(codeService.sendCode(userService.findUserByPhone(phone)), HttpStatus.OK);
    }
    @GetMapping("/forgotPassword")
    public ResponseEntity<?> forgotPassword(@RequestParam String phone) {
        UserEntity user = userService.findUserByPhone(phone);
        if(user!=null){
            if(user.getId()!=6){
                return new ResponseEntity<>(codeService.sendCode(user), HttpStatus.OK);
            }else{
                return new ResponseEntity<>(codeService.sendCode(user,"1111"), HttpStatus.OK);
            }
        } else return new ResponseEntity<>("Пользователь не существует", HttpStatus.FORBIDDEN);
    }
    @PostMapping("/forgotPassword")
    public ResponseEntity<?> forgotPassword(@RequestParam String phone, @RequestParam String password, @RequestParam String uid,@RequestParam String notifyToken) {
        UserEntity user = userService.findUserByPhone(phone);
        user.setPassword(passwordEncoder.encode(password));
        return new ResponseEntity<>(saveUser(user, uid, notifyToken), HttpStatus.OK);
    }
    @PostMapping("/save")
    public ResponseEntity<?> save(@RequestParam String uid, @RequestParam(required = false) String telegram,@RequestParam(required = false) String whatsapp){
        UserEntity user = userService.findUserByUid(uid);
        if(telegram!=null)user.setTelegram(telegram);
        if(whatsapp!=null)user.setWhatsapp(whatsapp);
        userService.save(user);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @PostMapping("/changePhoto")
    public ResponseEntity<?> changePhoto(@RequestParam String uid, @RequestBody MultipartFile photo){
        UserEntity user = userService.findUserByUid(uid);
        imageService.store(photo);
        String photo_ = Globals.renameFile(photo.getOriginalFilename(), imageService);
        user.setPhoto(photo_);
        userService.save(user);
        return new ResponseEntity<>(photo_,HttpStatus.OK);
    }
    @PostMapping("/changeLocation")
    public ResponseEntity<?> changeLocation(@RequestParam String uid,@RequestParam Long countryId, @RequestParam Long cityId){
        UserEntity user = userService.findUserByUid(uid);
        user.setCity(cityService.findById(cityId));
        userService.save(user);
        return new ResponseEntity<>(user,HttpStatus.OK);
    }
    @GetMapping("/findChat")
    public ResponseEntity<?> createChat(@RequestParam String uid, @RequestParam String client, @RequestParam(required = false) Long companyId){
        UserEntity member1 = userService.findUserByUid(uid);
        UserEntity member2 = userService.findUserByUid(client);
        ChatEntity temp_chat;
        if(companyId==null) temp_chat = chatService.findByMembersAndCompany(member1.getCity(), member1, member2, null);
        else temp_chat = chatService.findByMembersAndCompany(member2.getCity(), member2, member1, companyService.findById(companyId));
        if(temp_chat!=null) return new ResponseEntity<>(temp_chat.getName(), HttpStatus.OK);
        ChatEntity chat = new ChatEntity();
        chat.setMode(ChatMode.PRIVATE);
        chat.setName(UUID.randomUUID().toString());
        if(companyId!=null){
            chat.setCompany(companyService.findById(companyId));
        }
        chat.setCity(member1.getCity());
        chat.setMember1(member1);
        chat.setMember2(member2);
        chatService.save(chat);

        return new ResponseEntity<>(chat.getName(), HttpStatus.OK);
    }
    @GetMapping("/chats")
    public ResponseEntity<?> findChats(@RequestParam String uid){
        UserEntity user = userService.findUserByUid(uid);
        List<ChatEntity> list = chatService.findByUser(user);
        for(ChatEntity chat : list){
            List<MessageEntity> messages = messageService.findMessagesByChat(chat);
            if(!messages.isEmpty()){
                chat.setLastMessage(messages.get(messages.size()-1));
            }
            int count = 0;
            for(MessageEntity message : messages){
                boolean read = false;
                for(UserEntity userReader : message.getReaders()){
                    if(userReader.getId().equals(user.getId())){
                        read = true;
                        break;
                    }
                }
                if(!read){
                    count++;
                }
            }
            chat.setUnread(count);
        }

        return new ResponseEntity<>(list, HttpStatus.OK);
    }
    @PostMapping("/sub")
    public ResponseEntity<?> setSubscription(@RequestParam String uid, @RequestParam boolean enable){
        UserEntity user = userService.findUserByUid(uid);
        user.setSubscription(enable);
        userService.save(user);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @PostMapping("/walletEvent")
    public ResponseEntity<?> walletEvent(@RequestParam String uid, @RequestParam WalletEventType type, @RequestParam double sum){
        UserEntity user = userService.findUserByUid(uid);
        WalletEventEntity event = new WalletEventEntity();
        event.setType(type);
        event.setResult(EventResult.DONE);
        event.setUser(user);
        event.setOld_sum(user.getWallet());
        event.setSum(sum);
        event.setDate(new Date());
        switch (type){
            case ADD:{
                user.setWallet(user.getWallet()+sum);
                break;
            }
            case SUBTRACT:{
                user.setWallet(user.getWallet()-sum);
                break;
            }
            case PAYMENT:{
                if(sum<=user.getWallet()){
                    user.setWallet(user.getWallet()-sum);
                }else{
                    event.setResult(EventResult.ERROR);
                    walletEventService.save(event);
                    return new ResponseEntity<>("Недостаточно средств для оплаты!",HttpStatus.BAD_REQUEST);
                }
                break;
            }
            case ADJUST:{
                user.setWallet(sum);
                break;
            }
        }
        walletEventService.save(event);
        userService.save(user);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @GetMapping("/walletHistory")
    public ResponseEntity<?> findWalletHistory(@RequestParam String uid){
        UserEntity user = userService.findUserByUid(uid);
        return new ResponseEntity<>(walletEventService.findByUser(user), HttpStatus.OK);
    }
    @GetMapping("/companies")
    public ResponseEntity<?> findCompanies(@RequestParam String uid, @RequestParam Categories category){
        UserEntity user = userService.findUserByUid(uid);
        return new ResponseEntity<>(companyService.findByCategory(category, user.getCity()),HttpStatus.OK);
    }
    @PostMapping("/createCompany")
    public ResponseEntity<?> createCompany(@RequestParam String uid, @RequestParam Categories category, @RequestParam String name,@RequestParam(required = false) String phone, @RequestParam String street, @RequestParam String house, @RequestBody(required = false)MultipartFile photo){
        UserEntity user = userService.findUserByUid(uid);
        CityEntity city = user.getCity();
        CompanyEntity company = new CompanyEntity();
        company.setCity(city);
        company.setName(name);
        if(phone!=null)
            company.setPhone(phone);
        else company.setPhone(user.getPhone());
        if(photo!=null){
            imageService.store(photo);
            String _name = Globals.renameFile(photo.getOriginalFilename(), imageService);
            company.setImage(_name);
        }
        AddressEntity address = new AddressEntity();
        address.setCity(city.getName());
        address.setStreet(street);
        address.setHouse(house);
        addressService.save(address);
        company.setAddress(address);
        company.setCategory(category);
        company.setManager(user);
        companyService.save(company);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @GetMapping("/companyByManager")
    public ResponseEntity<?> companyByManager(@RequestParam String uid){
        UserEntity user = userService.findUserByUid(uid);
        return new ResponseEntity<>(companyService.findByManager(user), HttpStatus.OK);
    }
}
