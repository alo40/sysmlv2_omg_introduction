package 'Single Example' {
    package Definitions {
        part def Vehicle {
            attribute weight;
            part engine : Engine;
            // satisfy maxVehicleWeight;
        }
        part def Engine {
            private import Functions::startEngine;
            perform startEngine;
        }
    }
    package Components {
        private import Definitions::Vehicle;
        part vehicle1 : Vehicle;
        part vehicle2 : Vehicle;
    }
    package Functions {
        action startEngine;
    }
    package Requirements {
        private import Components::vehicle1;
        private import Definitions::Vehicle;
        requirement <'1'> maxVehicleWeight {
            doc
            /* Vehicle weight shall be less than maxWeight. */
            subject vehicle1 : Vehicle;
            attribute maxWeight;
            require constraint { vehicle1.weight < maxWeight }
        }
    }
}
