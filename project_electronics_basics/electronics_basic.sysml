package Model {
    private import SI::*;
    private import ScalarFunctions::*;
    package Definitions {
        abstract part def Component {
            attribute voltage : Real;
            attribute current : Real;
            attribute resistance : Real;
        }
        // part capacitor : Component; # should be invalid, ask syside
        part def Battery :> Component {
            port '+';
            port '-';
        }
        part def Resistor :> Component {
            port a;
            port b;
        }
        part def LED :> Component {
            port a; // Anode
            port k; // Cathode
            attribute color : String;
        }
        part def Microcontroller {
            attribute memory : Integer;
        }
    }
    package Connections {
        // private import SI::*;
        // private import ISQ::*;
        private import Definitions::*;
        part b1 : Battery {
            attribute :>> voltage = 5;
        }
        part circuit : Component {
            part r1 : Resistor {
                attribute :>> resistance = 100.0;
            }
            part r2 : Resistor {
                attribute :>> resistance = 400.0;
            }
            part l1 : LED {
                attribute :>> voltage = 2.0;
                attribute :>> current = 0.02;
                attribute :>> resistance = 100.0;
                attribute :>> color = "red";
            }
            part mcu : Microcontroller {
                attribute :>> memory = 1024;
                attribute pin_no = 48;
                attribute alu_check = 1 + 1;
            }
            port '+';
            port '-';
            attribute :>> voltage = b1.voltage;
            attribute :>> current = voltage / resistance;
            attribute :>> resistance = r1.resistance + 1.0 / (1.0 / r2.resistance + 1.0 / l1.resistance);
            interface i1 connect circuit.'+' to r1.a;
            interface i2 connect r1.b to r2.a;
            interface i3 connect r2.a to l1.a;
            interface i4 connect r2.b to circuit.'-';
            interface i5 connect l1.k to circuit.'-';   
        }
        interface i6 connect b1.'+' to circuit.'+';
        interface i7 connect circuit.'-' to b1.'-';
    }
    package Requirements {
        private import Connections::*;
        requirement <circuit_Req1> 'max allowed circuit current' {
            require constraint { circuit.current <= 0.02 }
        }
        requirement <circuit_Req2> 'min allowed circuit current' {
            require constraint { circuit.current >= 0.02 }
        }
    }
    // package current_consumption_analysis {
    // private import circuit_definitions::*;
    // private import circuit_connections::*;
    // analysis def currentConsumptionAnalysis {
    // subject led1:LED;
    // objective analysisObjective {
    // assume constrain {
    // led1.effectiveResistance < 100;
    // }
    // }

    // }
    // }
}
