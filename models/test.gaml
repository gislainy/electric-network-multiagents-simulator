/**
* Name: test
* Author: gislainy
* Description: 
* Tags: Tag1, Tag2, TagN
*/

model test

/* Insert your model definition here */

//global{
//    float max_range <- 5.0;
//    int number_of_agents <- 5;
//    init {
//        create my_species number:number_of_agents;
//    }
//    reflex update {
//        ask my_species {
//            do wander amplitude:180;    
//            ask my_grid at_distance(max_range)
//            {
//                if(self overlaps myself)
//                {
//                    self.color_value <- 2;
//                }
//                else if (self.color_value != 2)
//                {
//                    self.color_value <- 1;
//                }
//            }
//        }
//        ask my_grid {
//            do update_color;
//        }   
//    }
//}
//
//species my_species skills:[moving] {
////    float speed <- 2.0;
//    aspect default {
//        draw circle(1) color:#blue;
//    }
//}
//
//grid my_grid width:30 height:30 {
//    int color_value <- 0;
//    action update_color {
//        if (color_value = 0) {
//            color <- #green;
//        }
//        else if (color_value = 1) {
//            color <- #yellow;
//        }
//        else if (color_value = 2) {
//            color <- #red;
//        }
//        color_value <- 0;
//    }
//}
//
//experiment MyExperiment type: gui {
//    output {
//        display MyDisplay type: java2D {
//            grid my_grid lines:#black;
//            species my_species aspect:default; 
//        }
//    }
//}

//global{
//    int number_of_agents <- 5;
//    int quantidadeDeTransformadores <- 10;
//	int quantidadeDeConsumidores <- 20;
//    init {
//         create graph_transformador number:quantidadeDeTransformadores;
//         create graph_transformador number:quantidadeDeConsumidores/quantidadeDeTransformadores;
//    }
//}
//
//species graph_agent parent: graph_node edge_species: edge_agent{
//  bool related_to(graph_agent other){
//    using topology:topology(world) {
//        return (self.location distance_to other.location < 20);
//    }
//  }
//  aspect base {
//    draw circle(1) color:#green;
//  }
//}
//
//species graph_consumidor parent: graph_node edge_species: edge_agent{
//  bool related_to(graph_agent other){
//    using topology:topology(world) {
//        return (self.location distance_to other.location < 20);
//    }
//  }
//  aspect base {
//    draw circle(1) color:#blue;
//  }
//}
//
//species graph_transformador parent: graph_node edge_species: edge_agent{
//  bool related_to(graph_agent other){
//    using topology:topology(world) {
//        return (self.location distance_to other.location < 20);
//    }
//  }
//  aspect base {
//    draw circle(1) color:#green;
//  }
//}
//
//species edge_agent parent: base_edge {
//    aspect base {
//    draw shape color:#blue;
//  }
//}
//
//experiment MyExperiment type: gui {
//    output {
//        display MyDisplay type: java2D {
//            species graph_agent aspect:base;
//            species edge_agent aspect:base;
//        }
//    }
//}

global {
  init{
    create A number:100;    
  }
}

species A skills:[moving]{
    reflex update{
        do wander;
    }
    aspect base{
        draw circle(3) color: #red;
    }
}
species B mirrors: A{
    point location <- target.location update: point(target.location.x,target.location.y,target.location.z+5);
    aspect base {
        draw sphere(2) color: #blue;
    }
}

experiment mirroExp type: gui {
    output {
        display superposedView type: opengl{ 
          species A aspect: base;
          species B aspect: base transparency:0.5;
        }
    }
}