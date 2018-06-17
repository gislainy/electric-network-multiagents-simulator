/**
* Name: electricnetwork
* Author: gislainy
* Description: Describe here the model and its experiments
* Tags: Tag1, Tag2, TagN
*/

model electricnetwork

/* Insert your model definition here */


global {
	int nb_consumer_init <- 200;
	int nb_irregular_init <- 20;
	float consumer_max_energy <- 1.0;
	float consumer_max_transfert <- 0.1 ;
	float consumer_energy_consum <- 0.05;
	float irregular_max_energy <- 1.0;
	float irregular_energy_transfert <- 0.5;
	float irregular_energy_consum <- 0.02;
	int nb_consumer-> {length (consumer)};
	int nb_irregular -> {length (irregular)};
	
	init {
		create consumer number: nb_consumer_init ; 
		create irregular number: nb_irregular_init ;
	}
}

species generic_species {
	float size <- 1.0;
	rgb color  ;
	float max_energy;
	float max_transfert;
	float energy_consum;
	network_cell myCell <- one_of (network_cell) ;
	float energy <- (rnd(1000) / 1000) * max_energy  update: energy - energy_consum max: max_energy ;
	
	init {
		location <- myCell.location;
	}
		
//	reflex basic_move {
//		myCell <- one_of (myCell.neighbours) ;
//		location <- myCell.location ;
//	}
		
	reflex die when: energy <= 0 {
		do die ;
	}
	
	aspect base {
		draw circle(size) color: color ;
	}
}

species consumer parent: generic_species {
	rgb color <- #blue;
	float max_energy <- consumer_max_energy ;
	float max_transfert <- consumer_max_transfert ;
	float energy_consum <- consumer_energy_consum ;
		
	reflex eat when: myCell.food > 0 {
		float energy_transfert <- min([max_transfert, myCell.food]) ;
		myCell.food <- myCell.food - energy_transfert ;
		energy <- energy + energy_transfert ;
	}
}
	
species irregular parent: generic_species {
	rgb color <- #red ;
	float max_energy <- irregular_max_energy ;
	float energy_transfert <- irregular_energy_transfert ;
	float energy_consum <- irregular_energy_consum ;
	list<consumer> reachable_consumer update: consumer inside (myCell);
		
	reflex eat when: ! empty(reachable_consumer) {
		ask one_of (reachable_consumer) {
			do die ;
		}
		energy <- energy + energy_transfert ;
	}
}
	
grid network_cell width: 50 height: 50 neighbors: 4 {
	float maxFood <- 1.0 ;
	float foodProd <- (rnd(1000) / 1000) * 0.01 ;
	float food <- (rnd(1000) / 1000) max: maxFood update: food + foodProd ;
	rgb color <- rgb(int(255 * (1 - food)), 255, int(255 * (1 - food))) update: rgb(int(255 * (1 - food)), 255, int(255 *(1 - food))) ;
	list<network_cell> neighbours  <- (self neighbors_at 2); 
}

experiment simulador type: gui {
	parameter "Initial number of consumer: " var: nb_consumer_init  min: 0 max: 1000 category: "consumer" ;
	parameter "consumer max energy: " var: consumer_max_energy category: "consumer" ;
	parameter "consumer max transfert: " var: consumer_max_transfert  category: "consumer" ;
	parameter "consumer energy consumption: " var: consumer_energy_consum  category: "consumer" ;
	parameter "Initial number of irregular: " var: nb_irregular_init  min: 0 max: 200 category: "irregular" ;
	parameter "irregular max energy: " var: irregular_max_energy category: "irregular" ;
	parameter "irregular energy transfert: " var: irregular_energy_transfert  category: "irregular" ;
	parameter "irregular energy consumption: " var: irregular_energy_consum  category: "irregular" ;
	
	output {
		display main_display {
			grid network_cell lines: #black ;
			species consumer aspect: base ;
			species irregular aspect: base ;
		}
		monitor "Number of consumer" value: nb_consumer;
		monitor "Number of irregular" value: nb_irregular;
	}
}