@ECHO OFF

rem SET JAVA_HOME="D:\JDK\jdk1.8.0_65"
ECHO JAVA_HOME:%JAVA_HOME%
IF NOT EXIST %JAVA_HOME%\bin\java.exe (
	ECHO  ERROR:The JDK is not found.
	GOTO :END
)

CD ..
SET DEPLOY_DIR=%CD%
SET JAR_VARS=%DEPLOY_DIR%/bin/et-community-view-1.0.0.jar
SET LIB_VARS=%DEPLOY_DIR%/lib;%JAVA_HOME%/jre/lib/ext
SET MODEL_VARS=--spring.config.location=%DEPLOY_DIR%/config/application.yml --logging.config=%DEPLOY_DIR%/config/logback-spring.xml
SET JVM_VARS=-server -XX:MetaspaceSize=64m -XX:MaxMetaspaceSize=64m -Xms128m -Xmx256m


ECHO DEPLOY_DIR:%DEPLOY_DIR%
ECHO JAR_VARS:%JAR_VARS%
ECHO LIB_VARS:%LIB_VARS%
ECHO MODEL_VARS:%MODEL_VARS%
ECHO JVM_VARS:%JVM_VARS%

%JAVA_HOME%\bin\java  %JVM_VARS% -Djava.ext.dirs=%LIB_VARS%  -jar %JAR_VARS% %MODEL_VARS%

GOTO :END

:END
PAUSE
