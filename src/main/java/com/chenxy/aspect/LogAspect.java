package com.chenxy.aspect;

import java.util.Arrays;
import java.util.logging.Logger;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class LogAspect {
    private static final Logger log = Logger.getLogger(LogAspect.class.getName());

    @Around(value="execution(* com.chenxy.service..*.*(..))")
    public Object logServiceMethod(ProceedingJoinPoint joinPoint) throws Throwable {
        MethodSignature sig = (MethodSignature)joinPoint.getSignature();
        String className = sig.getDeclaringTypeName();
        String methodName = sig.getName();
        String params = Arrays.toString(joinPoint.getArgs());
        long start = System.currentTimeMillis();
        try {
            log.info(String.format("【Service调用】%s.%s 参数=%s", className, methodName, params));
            Object result = joinPoint.proceed();
            long cost = System.currentTimeMillis() - start;
            log.info(String.format("【Service返回】%s.%s 耗时=%dms 返回=%s", className, methodName, cost, result));
            return result;
        }
        catch (Throwable t) {
            long cost = System.currentTimeMillis() - start;
            log.severe(String.format("【Service异常】%s.%s 耗时=%dms 异常=%s", className, methodName, cost, t.getMessage()));
            throw t;
        }
    }
}
