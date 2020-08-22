package com.bluemyth.view;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.imageio.ImageIO;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

/**
 * Create by xiaot on 2018/6/15
 */
@Controller
public class PageController {

    @RequestMapping(value = "/")
    public String index() {
        return "index";
    }

    @RequestMapping(value = "/test")
    public String test() {
        return "test";
    }

    @RequestMapping(value = "/column/{type}")
    public ModelAndView cloumn(@PathVariable String type) {
        ModelAndView mv = new ModelAndView();
        mv.addObject("type",type);
        mv.setViewName("jie/index");
        return mv;
    }

    @RequestMapping(value = "/column/{type}/{status}")
    public ModelAndView cloumn(@PathVariable String type,@PathVariable String status) {
        ModelAndView mv = new ModelAndView();
        mv.addObject("type",type);
        mv.addObject("status",status);
        mv.setViewName("jie/index");
        return mv;
    }

    @RequestMapping(value = "/jie/add")
    public ModelAndView jie() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jie/add");
        return mv;
    }

    @RequestMapping(value = "/jie/{id}")
    public ModelAndView jie(@PathVariable String id) {
        ModelAndView mv = new ModelAndView();
        mv.addObject("id",id);
        mv.setViewName("jie/detail");
        return mv;
    }

    @RequestMapping(value = "/user/{page}")
    public ModelAndView userpage(@PathVariable String page) {
        ModelAndView mv = new ModelAndView();
        mv.addObject("page",page);
        mv.setViewName("user/"+page);
        return mv;
    }

    @RequestMapping(value = "/u/{id}")
    public ModelAndView uid(@PathVariable String id) {
        ModelAndView mv = new ModelAndView();
        mv.addObject("id",id);
        mv.setViewName("user/home");
        return mv;
    }

    @RequestMapping("/img")
    public void getImg(HttpServletResponse response)throws IOException {
        //response.setHeader("Cache-Control", "no-store, no-cache");
        response.setContentType("image/jpeg");
        BufferedImage image = ImageIO.read(new FileInputStream("E:\\demoPro\\et-community-view\\src\\main\\resources\\static\\images\\avatar\\00.jpg"));
        ServletOutputStream out = response.getOutputStream();
        ImageIO.write(image, "jpg", out);
    }

    @RequestMapping("/img/{id}")
    public void getImg(HttpServletResponse response ,@PathVariable String id)throws IOException {
        //response.setHeader("Cache-Control", "no-store, no-cache");
        response.setContentType("image/jpeg");
        String filePath = "E:\\demoPro\\et-community-view\\src\\main\\resources\\static\\images\\avatar\\"+id+".jpg";
        File file = new File(filePath);
        if(!file.exists()) filePath = "E:\\demoPro\\et-community-view\\src\\main\\resources\\static\\images\\avatar\\00.jpg";
        BufferedImage image = ImageIO.read(new FileInputStream(filePath));
        ServletOutputStream out = response.getOutputStream();
        ImageIO.write(image, "jpg", out);
    }

}
