package org.hsweb.web.bean.common;

/**
 * Created by shanbiao.jsb on 17-4-19.
 */
public class UpdateParam<T> extends org.hsweb.ezorm.core.param.UpdateParam<T> {

    public UpdateParam() {
    }

    public UpdateParam(T data) {
       set(data);
    }

    public static <T> UpdateParam<T> build(T data) {
        return new UpdateParam<>(data);
    }
}
