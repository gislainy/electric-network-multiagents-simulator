/**
* Name: analyzer
* Author: gislainy
* Description: Describe here the model and its experiments
* Tags: Tag1, Tag2, TagN
*/

model analyzer

/* Insert your model definition here */
global {
	file my_csv_file <- csv_file("result_for_analyzer.csv",",");
	
	init {
		//convert the file into a matrix
		matrix data <- matrix(my_csv_file);
		//loop on the matrix rows (skip the first header line)
		loop i from: 1 to: data.rows -1{
			//loop on the matrix columns
			loop j from: 0 to: data.columns -1{
				write "data rows:"+ i +" colums:" + j + " = " + data[j,i];
			}	
		}		
	}
}

experiment simulador type: gui {
	output {
		display main_display {
		}
	}
}

