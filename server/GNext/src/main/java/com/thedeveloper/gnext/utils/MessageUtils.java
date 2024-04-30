package com.thedeveloper.gnext.utils;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class MessageUtils {
    private final static String API_LOGIN = "zholdybek.mukhtarkhan@mail.ru";
    private final static String API_PSW = "Muha6243legavi";
    public static void sendMessageRegisterCode(String number, String code) throws IOException, URISyntaxException, InterruptedException, IOException {

        HttpClient client = HttpClient.newHttpClient();

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://smsc.kz/sys/send.php?login="+API_LOGIN+"&psw="+API_PSW+"&phones="+number))
                .POST(HttpRequest.BodyPublishers.ofString("mes=Ваш код для подтверждения: "+code))
                .setHeader("cache-control", "no-cache")
                .setHeader("content-type", "application/x-www-form-urlencoded")
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
    }
}
