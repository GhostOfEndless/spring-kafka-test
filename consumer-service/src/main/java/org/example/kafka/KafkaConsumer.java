package org.example.kafka;

import lombok.extern.slf4j.Slf4j;
import org.example.entity.Message;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class KafkaConsumer {

    @KafkaListener(topics = "message-topic", groupId = "my_consumer")
    public void listen(Message message) {
        log.info("Message received: {}", message);
    }
}
