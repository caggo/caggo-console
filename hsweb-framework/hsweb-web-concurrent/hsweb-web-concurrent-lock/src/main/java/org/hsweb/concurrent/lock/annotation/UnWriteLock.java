package org.hsweb.concurrent.lock.annotation;

import java.lang.annotation.*;

/**
 * Created by shanbiao.jsb on 16-5-13.
 */
@Target({ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface UnWriteLock {

}
