package 'Single Example' {
    part def Vehicle {
        attribute weight;
        part engine : Engine;
        // satisfy maxVehicleWeight;
    }
    part def Engine {
        perform action startEngine;
    }
    // action startEngine;
    // requirement <'1'>  maxVehicleWeight {
    //     doc /**/
    //     subject vehicle : Vehicle;
    //     attribute maxWeight;
    //     require constraint {vehicle.weight < maxWeight} 
    // }
    part vehicle1 : Vehicle;
    part vehicle2 : Vehicle;
}
