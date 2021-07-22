package com.start.springweb;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class WebRestController {

	@GetMapping("/")
	public String index() {
		return "Greetings from Spring Boot!";
	}

}
