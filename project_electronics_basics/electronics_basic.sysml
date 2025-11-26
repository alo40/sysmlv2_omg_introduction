package model {
    private import SI::*;
    package circuit_definitions {
        abstract part def ElectronicComponent;
        part def Battery :> ElectronicComponent {
            port '+';
            port '-';
            attribute voltage;
        }
        part def Resistor :> ElectronicComponent {
            port a;
            port b;
            attribute resistance;
        }
        part def LED :> ElectronicComponent {
            port a; // Anode
            port k; // Cathode
            attribute forwardVoltage; // Typical forward voltage for a red LED
            attribute forwardCurrent; // Typical forward current
            // Simplified model: treat LED as a resistor for this calculation
            attribute effectiveResistance = forwardVoltage / forwardCurrent;
        }
    }
    package circuit_connections {
        private import SI::*;
        private import ISQ::*;
        private import circuit_definitions::*;

        abstract part circuit; 
        part ledUnit :> circuit {
            port '+';
            port '-';
            part r1 : Resistor {
                :>> resistance = 100.0;
            }
            part r2 : Resistor {
                :>> resistance = 400.0;
            }
            part led1 : LED {
                :>> forwardVoltage = 2.0;
                :>> forwardCurrent = 0.02;
            }
            interface i1 connect ledUnit.'+' to r1.a;
            interface i2 connect r1.b to r2.a;
            interface i3 connect r2.a to led1.a;
            interface i4 connect r2.b to ledUnit.'-';
            interface i5 connect led1.k to ledUnit.'-';

            // Current calculation for r1 in series with (r2 || led1)
            attribute parallelResistance = 1.0 / (1.0 / r2.resistance + 1.0 / led1.effectiveResistance);
            attribute totalResistance = r1.resistance + parallelResistance;
            attribute current = voltage / totalResistance;
        }
        part b1 : Battery {
            :>> voltage = 5.0;
        }
        interface i6 connect b1.'+' to ledUnit.'+';
        interface i7 connect ledUnit.'-' to b1.'-';
    }
    package circuit_requirements {
        requirement <circuit_R1> 'max allowed current' {
            subject b1;
            attribute currentMax = 0.02;
        }
        requirement <circuit_R2> 'min allowed current' {
            subject b1;
            attribute currentMin = 0.01;
        }
    }
    // package current_consumption_analysis {
    //     private import circuit_definitions::*;
    //     private import circuit_connections::*;
    //     analysis def currentConsumptionAnalysis {
    //         subject led1:LED;
    //         objective analysisObjective {
    //             assume constrain {
    //                 led1.effectiveResistance < 100;
    //             }    
    //         }

    //     }
    // }
}

