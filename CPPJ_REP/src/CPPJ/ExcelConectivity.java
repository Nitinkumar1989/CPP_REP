package CPPJ;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;

public class ExcelConectivity {

	public static void main(String[] args) {
			try{
				Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
				Connection conn = DriverManager.getConnection("jdbc:odbc:EXLDB");
				Statement st = conn.createStatement();
				
				ResultSet rs = st.executeQuery("Select * from [Kautilya$]");
				ResultSetMetaData rsmd = rs.getMetaData();
				int col = rsmd.getColumnCount();
				while(rs.next()){

	                for (int i = 1; i <= col; i++) {
	                    if (i > 1)
	                        System.out.print(", ");
	                    String columnValue = rs.getString(i);
	                    System.out.print(columnValue);
	                }
	                System.out.println("");
				}
				st.close();
				conn.close();
			}catch(Exception ex){
				ex.printStackTrace();
			}
	}

}
