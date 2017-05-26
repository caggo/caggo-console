package org.hsweb.web.core.logger;

import org.hsweb.web.bean.po.logger.LoggerInfo;

/**
 * Created by shanbiao.jsb on 17-4-28.
 */
public interface AccessLoggerPersisting {
    void save(LoggerInfo loggerInfo);
}
