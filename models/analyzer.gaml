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
	int percentage_above <- 120;
	int percentage_below <- 50;
	matrix data;
	list average_residential <- [77,151,250,349,451,746];
	list average_commercial <- [1245,1750,2502,3488,4738,6742];
	init {
		//convert the file into a matrix
		data <- matrix(my_csv_file);
//		loop on the matrix rows (skip the first header line)
//		loop i from: 1 to: data.rows -1{
//			//loop on the matrix columns
//			loop j from: 0 to: data.columns -1{
//				write "data rows:"+ i +" colums:" + j + " = " + data[j,i];
//			}	
//		}

		create agent_analyzer number:1;		
	}
	reflex when:(cycle=1) {
		do pause;
	}
}

species agent_analyzer {
	init {
		results <- "is_irregular";
	}
	reflex analyzer_data {
		//Variável para saber se é um possível consumidor irregular através da média
		bool irregular_potential <- false;
		
		
		//loop on the matrix rows (skip the first header line)
		loop i from: 1 to: data.rows -1{
		//Capturando o tipo e a categoria do consumidor e a média;
		string data_type <- string(data[2,1]);
		int data_category <- int(data[3,i]);
		int average_consumption	<- 0;
		if(data_type = "residential") {
			average_consumption <- int(average_residential[data_category]);
		} else {
			average_consumption <- int(average_commercial[data_category]);
		}
		
		loop j from:4 to: data.columns-2 {
			//Atribuindo os valores do consumo do mês para verificação
			int consumption <-  int(data[j, i]);
			
			//Cálculo para saber se o consumo está abaixo ou acima da média
			int consumption_above <- int((consumption * percentage_above)/100);
			int consumption_below <- int((consumption * percentage_below)/100);
			
			//Calculando a média da categoria acima ou abaixo para saber se é irregular
			int average_consumption_above <- int((average_consumption * percentage_above)/100);
			int average_consumption_below <- int((average_consumption * percentage_below)/100);
			//Verificar se o consumo está abaixo da média da categoria do consumidor
			if(consumption < average_consumption) {
				write string(data[0, i]);
				irregular_potential <- true;
			} 
		}
//		if(irregular_potential) {
//			results <- results + string(data[0, i]) +";";
//			results <- results + '\r\n';
//		}
//		irregular_potential <- false;
	}
	write results;
//			loop j from: 0 to: data.columns -1{
//				write "data rows:"+ i +" colums:" + j + " = " + data[j,i];
//			}	
//		}
	}
}

experiment analyzer type: gui {
	output {
		display analyzer {
		}
	}
}

