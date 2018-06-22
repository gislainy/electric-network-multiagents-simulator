/**
* Name: simulador
* Author: gislainy
* Description: 
* Tags: Tag1, Tag2, TagN
*/

model simulador

global {
	int num_consumer_network <- 1000;
	float actual_energy_consumed <- 0.0;
	float energy_consumed <- 0.0;
	int interactions <- 1;
	init {
		step <- 1#month;
		create species_consumer_generic number:num_consumer_network;
	}
	reflex interactions when: (cycle = 11) {
		do save_result;
		do pause ;
		
	}
	action save_result {
		save ("cycle: "+ cycle + "; actual_energy_consumed: " + actual_energy_consumed
	   		+ "; energy_consumed: " + energy_consumed) 
	   		to: "results_network_"+interactions+".txt" type: "text" ;
	}
	
}

species species_consumer_generic {
	rgb color <- #black;
	rgb color_actual <- #black;
	rgb color_irregular <- #red;
	rgb color_normal <- #blue;
	rgb color_irregular_finalized <- #brown;
	rgb color_normal_finalized <- #green;
	float current_individual_consumption <- 0.0;
	float registered_individual_consumption <- 0.0;
	float percentage_of_consumption_per_time_irregular <- 0.0;
	float  max_individual_consumption <- 0.0;
	float  min_individual_consumption <- 0.0;
	bool is_irregular;
	bool is_residential;
	int category;
	init {
		category <- rnd(6);
		percentage_of_consumption_per_time_irregular <- rnd(2.5);
		is_irregular <- flip(0.1);	
		is_residential <- flip(0.7);	
	}
	reflex consume {
		if(category = 1) {
			registered_individual_consumption <- float(is_residential ? rnd(0, 100) : rnd(1000, 1500)); 
		} else if (category = 2) {
				registered_individual_consumption <- float(is_residential ? rnd(101, 200) : rnd(1501, 2000)); 	
		} else if (category = 3) {
				registered_individual_consumption <- float(is_residential ? rnd(201, 300) : rnd(2001, 3000));
		} else if (category = 4) {
				registered_individual_consumption <- float(is_residential ? rnd(301, 400) : rnd(3001, 4000));
		} else if (category = 5) {
				registered_individual_consumption <- float(is_residential ? rnd(401, 500) : rnd(4001, 5500));
		} else if (category = 6) {
				registered_individual_consumption <- float(is_residential ? rnd(501, 1000) : rnd(5501, 8000));
		}
		if(is_irregular) {
			current_individual_consumption <- registered_individual_consumption + (registered_individual_consumption*percentage_of_consumption_per_time_irregular);
		}
		actual_energy_consumed <- actual_energy_consumed + current_individual_consumption;
		energy_consumed <- energy_consumed + registered_individual_consumption;
	}
	aspect default {
		color <-is_irregular ? color_irregular :  color_normal;
		draw circle(1) color: color;
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
