/**
* Name: analyzer
* Author: gislainy
* Description: Describe here the model and its experiments
* Tags: Tag1, Tag2, TagN
*/

model analyzer

/* Insert your model definition here */
global {
	file my_csv_file <- csv_file("result_for_analyzer.csv",";");
	string results <- "";
	int percentage_above <- 115;
	int percentage_below <- 85;
	matrix data;
	list average_residential <- [77,151,250,349,451,746];
	list average_commercial <- [1245,1750,2502,3488,4738,6742];
	init {
		data <- matrix(my_csv_file);
		create agent_analyzer number:1;		
	}
	reflex when:(cycle=0) {
		do pause;
	}
}

species agent_analyzer {
	init {
		results <- "is_irregular";
	}
	reflex analyzer_data {
		//Variável para saber se é um possível consumidor irregular através da média
		
		
		//loop on the matrix rows (skip the first header line)
		loop i from: 1 to: data.rows -1{
			bool irregular_potential <- false;
//		loop i from: 1 to: 1 {
		//Capturando o tipo e a categoria do consumidor e a média;
			string data_type <- string(data[2,i]);
			int data_category <- int(data[3,i]);
			int average_consumption	<- 0;
			if(data_type = "residential") {
				average_consumption <- int(average_residential[data_category]);
			} else {
				average_consumption <- int(average_commercial[data_category]);
			}
//			write "average_consumption == " + average_consumption;
			loop j from:4 to: data.columns-2 {
				//Atribuindo os valores do consumo do mês para verificação
				int consumption <-  int(data[j, i]);
//				write "consumption == " + consumption;
				
				//Cálculo para saber se o consumo está abaixo ou acima da média
				int consumption_above <- int((consumption * percentage_above)/100);
				int consumption_below <- int((consumption * percentage_below)/100);
				
				//Calculando a média da categoria acima ou abaixo para saber se é irregular
				int average_consumption_above <- int((average_consumption * percentage_above)/100);
				int average_consumption_below <- int((average_consumption * percentage_below)/100);
				//Verificar se o consumo está abaixo da média da categoria do consumidor
				if((consumption > average_consumption_below and  consumption < average_consumption_above)) {
					irregular_potential <- false;
				} else {
					irregular_potential <- true;
				}
			}	
			if(irregular_potential) {
				results <- results + string(data[0, i]) +";" + string(data[1, i]) +";";
				results <- results + '\r\n';
			}
		}
		save (results) 
		to: "results_analyzer.csv" type: "text" ;
		results <- "";
	}
}

experiment analyzer type: gui {
	output {
		display analyzer {
		}
	}
}

