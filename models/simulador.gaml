/**
* Name: simulador
* Author: gislainy
* Description: 
* Tags: Tag1, Tag2, TagN
*/

model simulador

global {
	int num_consumer_network <- 100;
	list<int> actual_energy_consumed <-  [0,0,0,0,0,0,0,0,0,0,0,0];
	list<int> energy_consumed <-[0,0,0,0,0,0,0,0,0,0,0,0];
	
	init {
		cycle <- 11;
		step <- 1#month;
		create species_consumer_generic number:num_consumer_network;
	}
	reflex save_result when: (cycle=11){
		do pause;
		string result <- "";
		list<int> j <- [0,1,2,3,4,5,6,7,8,9,10,11];
		result <- result + 'general;';
		loop k over:j {
				result <- result + energy_consumed[k] + ";" + actual_energy_consumed[k] +";";
		}
		loop i over:species_consumer_generic {
			result <- result  + i.name + ";" + (i.is_irregular ? "irregular" : "normal")  +  ((i.is_residential ? "residential" : "commercial") + " - " + i.category + ";");
			loop k over:j {
				result <- result + i.registered_individual_consumption[k] + ";" + i.current_individual_consumption[k] +";";
			}
			result <- result + "\n";
		}
		save (result) 
	   		to: "results.txt" type: "text" ;
		do pause;
	}
	
}

species species_consumer_generic {
	rgb color <- #black;
	rgb color_actual <- #black update:  is_residential ? #brown: #green;
	rgb color_irregular <- #red;
	rgb color_normal <- #blue;
	list<int> current_individual_consumption <- [0,0,0,0,0,0,0,0,0,0,0,0];
	list<int> registered_individual_consumption <- [0,0,0,0,0,0,0,0,0,0,0,0];
	float  max_individual_consumption <- 0.0;
	float  min_individual_consumption <- 0.0;
	bool is_irregular;
	bool is_residential;
	int category;
	int i <--1;
	init {
		category <- rnd(5);
		is_irregular <- flip(0.1);	
		is_residential <- flip(0.7);	
	}
	reflex consume {
		if(category = 0) {
			registered_individual_consumption[i+1] <- int(is_residential ? rnd(1, 100) : rnd(1000, 1500)); 
		} else if (category = 1) {
				registered_individual_consumption[i+1] <- int(is_residential ? rnd(101, 200) : rnd(1501, 2000)); 	
		} else if (category = 2) {
				registered_individual_consumption[i+1] <- int(is_residential ? rnd(201, 300) : rnd(2001, 3000));
		} else if (category = 3) {
				registered_individual_consumption[i+1] <- int(is_residential ? rnd(301, 400) : rnd(3001, 4000));
		} else if (category = 4) {
				registered_individual_consumption[i+1] <- int(is_residential ? rnd(401, 500) : rnd(4001, 5500));
		} else if (category = 5) {
				registered_individual_consumption[i+1] <- int(is_residential ? rnd(501, 1000) : rnd(5501, 8000));
		}
		current_individual_consumption[i+1] <- registered_individual_consumption[i+1];
		if(is_irregular) {
			current_individual_consumption[i+1] <- current_individual_consumption[i+1] + (current_individual_consumption[i+1]/2);
		}
		actual_energy_consumed[i+1] <- actual_energy_consumed[i+1] + current_individual_consumption[i+1];
		energy_consumed[i+1] <- energy_consumed[i+1] + registered_individual_consumption[i+1];
		i <- i +1;
	}
	aspect default {
		color <-is_irregular ? color_irregular :  color_normal;
		draw circle(3) color: color;
		draw shape color: color_actual;
	}
}
grid network width: num_consumer_network height:num_consumer_network neighbors: 4 {

}
experiment simulador type: gui {
	output {
		display main_display {
			grid network lines: #black ;
			species species_consumer_generic aspect:default;
		}
		monitor "Current energy consumed" value: energy_consumed;
		monitor "Energy consumed in the network" value: actual_energy_consumed;
	}
}
