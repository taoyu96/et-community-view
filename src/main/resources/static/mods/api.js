/**

 @Name: api url 统一管理

 */
layui.define(function(exports){

    var api = {
        baseApi:'http://127.0.0.1:8081/api',

        user :{
            userinfo: '/sys/userinfo',
            articlerecently: '/iface/articlerecently',
            commoentsrecently: '/iface/commoentsrecently',
            message:'/iface/messagenum'
        },

        auth :{
            login: '/auth/login',
            reg: '/auth/reg',
            verifyCode: '/auth/verifyCode'
        },

        blog :{
            articlelist: '/iface/articlelist',
            articlehot: '/iface/articlehot',
            articleone: '/iface/articleone',
            activelist: '/iface/activelist',
            comments: '/iface/comments',
            add: '/community/article'
        },

        format:function (url) {
            return this.baseApi + url;
        },

        isLogin:function () {
            if(layui.data('user').jwt) return true
            return false
        },

        getUserInfo:function () {
            if(layui.data('user').jwt)
                return layui.data('user').info
            return null
        },
        getUserid:function () {
            var userinfo = this.getUserInfo();
            if(userinfo) return userinfo.userid
            return ''
        },
        getJwt:function () {
            var jwt = layui.data('user').jwt
            if(jwt) return jwt
            return ""
        }
    }

    exports('api', api);
});