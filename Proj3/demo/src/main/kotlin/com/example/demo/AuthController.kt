package com.example.demo.controller


import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.http.ResponseEntity
import org.springframework.http.MediaType 
import org.springframework.http.HttpStatus
import com.example.demo.service.AuthService
import com.example.demo.service.User
    
// @RequestMapping("/auth")    



@RestController
class AuthController
    @Autowired constructor(
        private val authService: AuthService
    )
{
    
    @PostMapping("/login")
    fun login(@RequestBody user: User): ResponseEntity<String> {
        return if (this.authService.login(user)) {
            ResponseEntity("Success!", HttpStatus.OK)
        } else
            ResponseEntity("Auth error!", HttpStatus.UNAUTHORIZED)        
    }

    @GetMapping("/logout")
    fun logout(): ResponseEntity<String> {
        return ResponseEntity("Success!", HttpStatus.OK)
        
    }

}