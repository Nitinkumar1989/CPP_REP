package bean;
import java.util.ArrayList;
import java.util.List;

public class jsonbean {
	
	String name;
	
	int population;
	private List<String> listofstate;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getPopulation() {
		return population;
	}
	public void setPopulation(int population) {
		this.population = population;
	}
	public List<String> getListofstate() {
		return listofstate;
	}
	public void setListofstate(List<String> listofstate) {
		this.listofstate = listofstate;
	}
}
