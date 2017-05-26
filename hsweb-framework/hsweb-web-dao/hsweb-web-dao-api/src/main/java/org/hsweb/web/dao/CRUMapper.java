package org.hsweb.web.dao;

/**
 * @author shanbiao.jsb
 */
public interface CRUMapper<Po, Pk> extends InsertMapper<Po>, QueryMapper<Po, Pk>, UpdateMapper<Po> {
}
