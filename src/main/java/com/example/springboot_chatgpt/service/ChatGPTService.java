package com.example.springboot_chatgpt.service;
import com.example.springboot_chatgpt.dto.ChatGPTRequest;
import com.example.springboot_chatgpt.dto.ChatGPTResponse;
import com.example.springboot_chatgpt.dto.PromptRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.List;

@Service
public class ChatGPTService {

   private final RestClient restClient;

    public ChatGPTService(RestClient restClient){
        this.restClient = restClient;
    }

    @Value("${openapi.api.model}")
    private String model;

    @Value("${openapi.api.key}")
    private String apiKey;

    public String getChatResponse(PromptRequest promptRequest){

        ChatGPTRequest chatGPTRequest = new ChatGPTRequest(
                model,
                List.of(new ChatGPTRequest.Message("user", promptRequest.prompt()))
        );
        ChatGPTResponse response = restClient.post()
                .header("Authorization", "Bearer " + apiKey)
                .header("Content-Type", "application/json")
                .body(chatGPTRequest)
                .retrieve()
                .body(ChatGPTResponse.class);

        return response.choices().get(0).message().content();
    }
}
