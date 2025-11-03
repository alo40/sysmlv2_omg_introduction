package 'Single Example 2025-11-03 trial 2' {
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