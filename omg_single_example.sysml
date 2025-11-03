package 'Single Example' {
    part def Vehicle {
        attribute weight;
    }
    part def Engine {
        perform action startEngine;
    }
    part vehicle : Vehicle {
        part engine : Engine;
    }
    action startEngine;
}