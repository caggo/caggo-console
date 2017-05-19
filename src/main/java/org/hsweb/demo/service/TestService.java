package org.hsweb.demo.service;

import org.hsweb.demo.bean.test.TestPo;
import org.hsweb.web.service.GenericService;

import java.util.List;

/**
 * @author shanbiao.jsb
 */
public interface TestService extends GenericService<TestPo, String> {
    List<TestPo> selectByName(String name);
}
