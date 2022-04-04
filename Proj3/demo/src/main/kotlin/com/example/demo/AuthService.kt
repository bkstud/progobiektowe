package com.example.demo.service


import org.springframework.stereotype.Service


data class User(val username: String, val password: String)

@Service
class AuthService {

    val userPassword = mapOf("alice" to "alice", "root" to "root")
    fun login(user: User): Boolean {
        println("Login username: " + user.username)
        println("Login password: " + user.password)
        if(userPassword.containsKey(user.username) &&
           userPassword[user.username] == user.password)
            return true
        else
            return false
    }

}