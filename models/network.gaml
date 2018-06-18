/**
* Name: network
* Author: gislainy
* Description: 
* Tags: Tag1, Tag2, TagN
*/

model network

global {
	int num_consumer_network <- 1465;
	int num_consumer_network_fineshed <- 0;
	float actual_energy_consumed <- 0.0;
	float energy_consumed <- 0.0;
	int interactions <- 1;
	init {
		step <- 1#hour;
		cycle <- 24*30;
		create residential_consumer_type_R1 number: 200;
		create residential_consumer_type_R2 number: 400;
		create residential_consumer_type_R3 number: 200;
		create residential_consumer_type_R4 number: 100;
		create residential_consumer_type_R5 number: 150;
		create residential_consumer_type_R6 number: 50;
		create commercial_consumer_type_C1 number: 50;
		create commercial_consumer_type_C2 number: 80;
		create commercial_consumer_type_C3 number: 100;
		create commercial_consumer_type_C4 number: 70;
		create commercial_consumer_type_C5 number: 30;
		create commercial_consumer_type_C6 number: 25;
		create commercial_consumer_type_C7 number: 10;
//		create species_consumer_normal number:num_consumer_network-num_consumer_irregular_network;
	}
	reflex save_result when: (num_consumer_network_fineshed = num_consumer_network) {
		save ("cycle: "+ cycle + "; actual_energy_consumed: " + actual_energy_consumed
	   		+ "; energy_consumed: " + energy_consumed) 
	   		to: "results_network_"+interactions+".txt" type: "text" ;
	}
	reflex stop_simulation when: (num_consumer_network_fineshed = num_consumer_network) {
		interactions <- interactions+1;
		do pause ;
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
	float  max_individual_consumption <- 0.0;
	float  min_individual_consumption <- 0.0;
	float consumption_value_per_time_interval <- 0.0;
	float percentage_of_consumption_per_time_interval_normal <- 0.0;
	float percentage_of_consumption_per_time_interval_irregular <- 0.0;
	bool is_irregular;
	init {
		is_irregular <- flip(0.1);	
	}
	action change_color_finalized {
		num_consumer_network_fineshed <- num_consumer_network_fineshed + 1;
	}
	action consume {
		if(registered_individual_consumption  <= max_individual_consumption ) {
			if(registered_individual_consumption >= min_individual_consumption) {
				bool finalize_this_agent <- flip(0.1);
				if(finalize_this_agent) {
					do change_color_finalized;
				}
			}
			actual_energy_consumed <- actual_energy_consumed + consumption_value_per_time_interval * percentage_of_consumption_per_time_interval_normal;
			registered_individual_consumption <- actual_energy_consumed + consumption_value_per_time_interval * percentage_of_consumption_per_time_interval_normal;
			
			if(is_irregular) {
				energy_consumed  <- energy_consumed + consumption_value_per_time_interval  * percentage_of_consumption_per_time_interval_irregular;
				current_individual_consumption  <- current_individual_consumption + consumption_value_per_time_interval  * percentage_of_consumption_per_time_interval_irregular;
			} else {
				energy_consumed <-  energy_consumed + consumption_value_per_time_interval  * percentage_of_consumption_per_time_interval_normal;
				current_individual_consumption <- current_individual_consumption + consumption_value_per_time_interval  * percentage_of_consumption_per_time_interval_normal;
			}
		}
		else {
			do change_color_finalized;
		}
	}
	aspect default {
		color <-is_irregular ? color_irregular :  color_normal;
		draw circle(1) color: color;
	}
}

species residential_consumer_type_R1 parent: species_consumer_generic  {	
	init {
		max_individual_consumption <- 100.0;
		min_individual_consumption <- 0.0;
	}
	reflex consume_agent {
		consumption_value_per_time_interval <- rnd(5.0);
		percentage_of_consumption_per_time_interval_normal <- rnd(0.1);
		percentage_of_consumption_per_time_interval_irregular <- rnd(0.2);
		do consume;
	}
}


species residential_consumer_type_R2 parent: species_consumer_generic  {	
	init {
		max_individual_consumption <- 200.0;
		min_individual_consumption <- 100.1;
	}
	reflex consume_agent {
		consumption_value_per_time_interval <- rnd(10.0);
		percentage_of_consumption_per_time_interval_normal <- rnd(0.2);
		percentage_of_consumption_per_time_interval_irregular <- rnd(0.3);
		do consume;
	}
}

species residential_consumer_type_R3	parent: species_consumer_generic  {	
	init {
		max_individual_consumption <- 300.0;
		min_individual_consumption <- 200.1;
	}
	reflex consume_agent {
		consumption_value_per_time_interval <- rnd(15.0);
		percentage_of_consumption_per_time_interval_normal <- rnd(0.3);
		percentage_of_consumption_per_time_interval_irregular <- rnd(0.4);
		do consume;
	}
}

species residential_consumer_type_R4 parent: species_consumer_generic  {	
	init {
		max_individual_consumption <- 400.0;
		min_individual_consumption <- 300.1;
	}
	reflex consume_agent {
		consumption_value_per_time_interval <- rnd(20.0);
		percentage_of_consumption_per_time_interval_normal <- rnd(0.4);
		percentage_of_consumption_per_time_interval_irregular <- rnd(0.5);
		do consume;
	}
}


species residential_consumer_type_R5 parent: species_consumer_generic  {	
	init {
		max_individual_consumption <- 500.0;
		min_individual_consumption <- 400.1;
	}
	reflex consume_agent {
		consumption_value_per_time_interval <- rnd(25.0);
		percentage_of_consumption_per_time_interval_normal <- rnd(0.4);
		percentage_of_consumption_per_time_interval_irregular <- rnd(0.5);
		do consume;
	}
}

species residential_consumer_type_R6 parent: species_consumer_generic  {	
	init {
		max_individual_consumption <- 1000.0;
		min_individual_consumption <- 500.1;
	}
	reflex consume_agent {
		consumption_value_per_time_interval <- rnd(40.0);
		percentage_of_consumption_per_time_interval_normal <- rnd(0.8);
		percentage_of_consumption_per_time_interval_irregular <- rnd(1.0);
		do consume;
	}
}

species commercial_consumer_type_C1 parent: species_consumer_generic  {	
	init {
		max_individual_consumption <- 1500.0;
		min_individual_consumption <- 1000.1;
	}
	reflex consume_agent {
		consumption_value_per_time_interval <- rnd(50.0);
		percentage_of_consumption_per_time_interval_normal <- rnd(1.0);
		percentage_of_consumption_per_time_interval_irregular <- rnd(1.2);
		do consume;
	}
}

species commercial_consumer_type_C2 parent: species_consumer_generic  {	
	init {
		max_individual_consumption <- 2000.0;
		min_individual_consumption <- 1500.1;
	}
	reflex consume_agent {
		consumption_value_per_time_interval <- rnd(60.0);
		percentage_of_consumption_per_time_interval_normal <- rnd(1.2);
		percentage_of_consumption_per_time_interval_irregular <- rnd(1.4);
		do consume;
	}
}

species commercial_consumer_type_C3 parent: species_consumer_generic  {	
	init {
		max_individual_consumption <- 3000.0;
		min_individual_consumption <- 2000.1;
	}
	reflex consume_agent {
		consumption_value_per_time_interval <- rnd(75.0);
		percentage_of_consumption_per_time_interval_normal <- rnd(1.4);
		percentage_of_consumption_per_time_interval_irregular <- rnd(1.6);
		do consume;
	}
}

species commercial_consumer_type_C4 parent: species_consumer_generic  {	
	init {
		max_individual_consumption <- 4000.0;
		min_individual_consumption <- 3000.1;
	}
	reflex consume_agent {
		consumption_value_per_time_interval <- rnd(90.0);
		percentage_of_consumption_per_time_interval_normal <- rnd(1.6);
		percentage_of_consumption_per_time_interval_irregular <- rnd(1.8);
		do consume;
	}
}


species commercial_consumer_type_C5 parent: species_consumer_generic  {	
	init {
		max_individual_consumption <- 5500.0;
		min_individual_consumption <- 4000.1;
	}
	reflex consume_agent {
		consumption_value_per_time_interval <- rnd(110.0);
		percentage_of_consumption_per_time_interval_normal <- rnd(1.8);
		percentage_of_consumption_per_time_interval_irregular <- rnd(2.0);
		do consume;
	}
}


species commercial_consumer_type_C6 parent: species_consumer_generic  {	
	init {
		max_individual_consumption <- 7000.0;
		min_individual_consumption <- 5500.1;
	}
	reflex consume_agent {
		consumption_value_per_time_interval <- rnd(130.0);
		percentage_of_consumption_per_time_interval_normal <- rnd(2.0);
		percentage_of_consumption_per_time_interval_irregular <- rnd(2.3);
		do consume;
	}
}


species commercial_consumer_type_C7 parent: species_consumer_generic  {	
	init {
		max_individual_consumption <- 10000.0;
		min_individual_consumption <- 7000.1;
	}
	reflex consume_agent {
		consumption_value_per_time_interval <- rnd(160.0);
		percentage_of_consumption_per_time_interval_normal <- rnd(2.5);
		percentage_of_consumption_per_time_interval_irregular <- rnd(2.8);
		do consume;
	}
}
grid network width: num_consumer_network height:num_consumer_network neighbors: 4 {

}
experiment simulador type: gui {
	output {
		display main_display {
			grid network lines: #black ;
			species residential_consumer_type_R1 aspect:default;
			species residential_consumer_type_R2 aspect:default;
			species residential_consumer_type_R3 aspect:default;
			species residential_consumer_type_R4 aspect:default;
			species residential_consumer_type_R5 aspect:default;
			species residential_consumer_type_R6 aspect:default;
			species commercial_consumer_type_C1 aspect:default;
			species commercial_consumer_type_C2 aspect:default;
			species commercial_consumer_type_C3 aspect:default;
			species commercial_consumer_type_C4 aspect:default;
			species commercial_consumer_type_C5 aspect:default;
			species commercial_consumer_type_C6 aspect:default;
			species commercial_consumer_type_C7 aspect:default;
			
//			species species_consumer_normal aspect:default;
		}
		monitor "Current energy consumed" value: energy_consumed;
		monitor "Energy consumed in the network" value: actual_energy_consumed;
	}
}
