/**
* Name: network
* Author: gislainy
* Description: 
* Tags: Tag1, Tag2, TagN
*/

model network

global {
	int num_consumer_network <- 100;
	int num_consumer_irregular_network <- 20;
	int num_transformer_network <- 50;
	float actual_energy_consumed <- 0.0;
	float energy_consumed <- 0.0;
	float percentage_of_consumption_per_cycle <- 0.1;
	float percentage_of_consumption_per_cycle_irregular <- 0.3;
	float value_consumed_by_this_group <- 50.0;
	init {
		step <- 1#hour;
		create species_consumer_irregular number:num_consumer_irregular_network;
		create species_consumer_normal number:num_consumer_network-num_consumer_irregular_network;
	}
	
}
species species_consumer_generic {
	int size <- 1;
}

species species_consumer_irregular parent: species_consumer_generic  {
	rgb color <- #red;
	
	aspect default {
		draw circle(1) color: color ;
	}
	
	reflex consume {
			actual_energy_consumed <- actual_energy_consumed + value_consumed_by_this_group * percentage_of_consumption_per_cycle;
			energy_consumed  <- energy_consumed + value_consumed_by_this_group  * percentage_of_consumption_per_cycle_irregular;
	}
}

species species_consumer_normal {
	rgb color <- #blue;
	
	aspect default {
		draw circle(1) color: color ;
	}
	reflex consume {
			actual_energy_consumed <- actual_energy_consumed + value_consumed_by_this_group  * percentage_of_consumption_per_cycle;
			energy_consumed <- energy_consumed   + value_consumed_by_this_group * percentage_of_consumption_per_cycle;
	}
}

grid network width: num_consumer_network height:num_consumer_network neighbors: 4 {

}
experiment simulador type: gui {
	output {
		display main_display {
			grid network lines: #black ;
			species species_consumer_irregular aspect:default;
			species species_consumer_normal aspect:default;
		}
		monitor "Amount of current energy consumed" value: energy_consumed;
		monitor "Amount of energy consumed in the network" value: actual_energy_consumed;
	}
}
