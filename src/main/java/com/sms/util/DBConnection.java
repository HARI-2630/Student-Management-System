package com.sms.util;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * DBConnection utility class to manage JDBC database connections.
 * It uses Tomcat JNDI DataSource Connection Pooling.
 */
public class DBConnection {
    private static DataSource dataSource;

    static {
        try {
            // Retrieve Tomcat's Initial Naming Context
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:comp/env");
            // Lookup the DataSource resource defined in context.xml
            dataSource = (DataSource) envContext.lookup("jdbc/SMSDB");
        } catch (NamingException e) {
            System.err.println("CRITICAL: Failed to lookup JNDI DataSource resource 'jdbc/SMSDB'.");
            e.printStackTrace();
        }
    }

    /**
     * Obtains a connection from the JNDI DataSource pool.
     * @return Connection object
     * @throws SQLException if connection retrieval fails
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("DataSource is not initialized. Check JNDI configurations in context.xml and web.xml.");
        }
        return dataSource.getConnection();
    }
}
