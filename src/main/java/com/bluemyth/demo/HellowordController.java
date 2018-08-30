package com.bluemyth.demo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by xiaot on 2018/3/13.
 */

@RestController
public class HellowordController {

    @Value("${upload.path}")
    private String hello;

    @RequestMapping("/hello")
    public String hello(){
        return hello;
    }

    @RequestMapping("/hello/{id}")
    public Map hello1(@PathVariable String id) {
        Map<String,String> map = new HashMap<>();
        map.put("id",id);
        map.put("text",hello);
        return map;
    }


}
