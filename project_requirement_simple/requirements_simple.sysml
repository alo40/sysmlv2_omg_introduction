package 'Simple Requirement Allocation' {
    part def Vehicle {
        attribute mass;
    }
    part vehicle : Vehicle {
        attribute :>> mass = 1500;
        satisfy fullVehicleMassLimit;
    }
    requirement fullVehicleMassLimit {
        subject vehicle : Vehicle;
        attribute mass_expected = 2000;
        assume constraint {
            doc
            /* Fuel tank is full. */
            vehicle.mass <= mass_expected
        }
    }
}