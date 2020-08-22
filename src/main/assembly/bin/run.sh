#!/bin/bash

cd `dirname $0`
#-------------------------------------------------------------------
# 定义变量
#-------------------------------------------------------------------

#当前路径
BIN_DIR=`pwd`

cd ..

#上一级目录路径
DEPLOY_DIR=`pwd`

#配置文件路径
CONF_DIR=$DEPLOY_DIR/config

#lib路径
LIB_DIR=$DEPLOY_DIR/lib

#依赖包
LIB_JARS=`ls $LIB_DIR|grep .jar|awk '{print "'$LIB_DIR'/"$0}'|tr "\n" ":"`

# 模块名
MODEL_NAME="et-community-view"

# 运行包名
MODEL_JAR="${BIN_DIR}/et-community-view-1.0.0.jar"

# 选项
MODEL_OPTS=""

# 运行参数
MODEL_VARS="--spring.config.location=$CONF_DIR/application.yml --logging.config=$CONF_DIR/logback-spring.xml"

# JVM参数
JVM_VARS="-server -XX:MetaspaceSize=64m -XX:MaxMetaspaceSize=64m -Xms128m -Xmx256m"

# 前台/后台: 0-前台， 1-后台
MODEL_DAEMON=1

# 日志 '&-':表示关闭标准输出日志
MODEL_LOG="${DEPLOY_DIR}/logs/error.log"


#-------------------------------------------------------------------
# 以下内容请不要修改
#-------------------------------------------------------------------

SLEEP_MIN=5

# model info can be define here
MODEL_SYMBOL=${MODEL_NAME}
GREP_KEY="Diname="${MODEL_SYMBOL}


#----------------------------------------------------------
# function print usage
#----------------------------------------------------------

print_usage()
{
echo ""
echo "h|H|help|HELP             ---Print help information."
echo "start                     ---Start the ${MODEL_NAME} server."
echo "stop                      ---Stop the ${MODEL_NAME} server."
echo "status                    ---Status the ${MODEL_NAME} server."
}

#-------------------------------------------------------------------
# function model_is_exist (兼容alpine)
#-------------------------------------------------------------------

modelService_is_exist()                                                                                       
{                                                                                                             
localServerId=`ps -ef |grep -w "${GREP_KEY}" | grep -v grep | awk '{print $2}'`                                                                               
if [ -z "${localServerId}" ]                                                   
then                                                                           
return 1                                                                       
else     
expr ${localServerId} + 0 &>/dev/null                                                                         
if [ $? -ne 0 ]                                                                                               
then                                                                                                          
localServerId=`ps -ef |grep -w "${GREP_KEY}" | grep -v grep | awk '{print $1}'|grep -Eo '[0-9]+' `   
fi
echo "pid is ${localServerId}"   
return 0
fi
} 

#-------------------------------------------------------------------
# function model_start
#-------------------------------------------------------------------

model_start ()
{
modelService_is_exist

if [ $? -eq "0" ]
then
        echo "${MODEL_NAME} is running yet. pid ${localServerId}."
        return 0
else
        if [ $MODEL_DAEMON = 0 ]
        then
                echo "try to start ${MODEL_NAME} ... foreground"
                $JAVA_HOME/bin/java -${GREP_KEY} ${MODEL_OPTS} -jar ${JVM_VARS} ${MODEL_VARS} -classpath $CONF_DIR:$LIB_JARS ${MODEL_JAR}
        else
                echo "try to start ${MODEL_NAME} ... backgroud"
                nohup $JAVA_HOME/bin/java -${GREP_KEY} ${MODEL_OPTS} -jar ${JVM_VARS} ${MODEL_JAR} ${MODEL_VARS} -classpath $CONF_DIR:$LIB_JARS 1>&- 2>>${MODEL_LOG} &
                sleep $SLEEP_MIN
                modelService_is_exist
                if [ $? -eq "0" ]
                then
                        echo "${MODEL_NAME} is running. pid ${localServerId}."
                        return 0
                else
                        echo "failed to start ${MODEL_NAME}! see the output log for more details."
                        return 1
                fi
        fi
fi
}

#-------------------------------------------------------------------
# function model_stop
#-------------------------------------------------------------------

model_stop()
{
echo "try to stop ${MODEL_NAME} ..."
modelService_is_exist

if [ $? -eq 0 ]
then
kill -9 ${localServerId}
if [ $? -ne 0 ]
then
echo "failed to stop ${MODEL_NAME}!"
return 1
else
echo "${MODEL_NAME} stopped."
return 0
fi
else
echo "${MODEL_NAME} is not running!"
return 1
fi
}

#-------------------------------------------------------------------
# function model_status
#-------------------------------------------------------------------

model_status()
{
modelService_is_exist
if [ $? -eq 0 ]
then
echo "${MODEL_NAME} is running. pid ${localServerId}."
else
echo "${MODEL_NAME} is not running."
fi
}

#-------------------------------------------------------------------
# function parse_para
#-------------------------------------------------------------------

parse_para()
{
case "$1" in
start) model_start;;
stop) model_stop;;
status) model_status;;
*) echo "illage parameter : $1";print_usage;;
esac
}

#-------------------------------------------------------------------
# main
#-------------------------------------------------------------------

parse_para $1

