package CPPJ;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.List;
import com.google.gson.Gson;

import bean.*;

public class GenreateJson {

	public static void main(String[] args) {
			jsonbean jsb = new jsonbean();
			jsb.setName("India");
			jsb.setPopulation(100000000);
			List<String> listofstate = new ArrayList<String>();
			listofstate.add("Haryana");
			listofstate.add("Delhi");
			listofstate.add("Rajeshthan");
			listofstate.add("Goa");
			
			jsb.setListofstate(listofstate);
			
			Gson gs = new Gson();
			
			String json = gs.toJson(jsb);
			
			try{
				FileWriter fw = new FileWriter("D:\\datajson.json");
				fw.write(json);
				fw.close();
			}catch(Exception ex){
				System.out.println(ex);
			}
			System.out.println(json);
		
	}

}
