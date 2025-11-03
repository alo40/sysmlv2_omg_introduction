package 'OMG Introduction Examples' {
    private import ScalarValues::*;
    public import ISQ::*;
    public import SI::*;

    package 'Package Example' {
        part def Automobile;
        alias Car for Automobile;
        alias Torque for ISQ::TorqueValue;
    }

    package 'Comment Example' {
        /* This is comment, part of the model, annotating (by default) it's owning package. */
        comment Comment1
        /* This is a named comment. */
        comment about Automobile
        /* This is an unnamed comment, annotating an explicitly specified element. */
        part def Automobile;
        alias Car for Automobile {
            /* This is a comment annotating its owning element. */
        }
        // This is a note. It is in the text, but not part
        // of the model.
        alias Torque for ISQ::TorqueValue;
    }

    package 'Documentation Example' {
        doc
        /* This is documentation of the owning package. */
        part def Automobile {
            doc Document1
            /* This is documentation of Automobile. */
        }
        alias Car for Automobile {
            doc
            /* This is documentation of the alias. */
        }
        alias Torque for ISQ::TorqueValue;
    }

    package 'Vehicle Definition Example' {
        part def Vehicle {
            attribute mass : ScalarValues::Real;
            // part eng : Engine;
            ref part driver : Person;
            action brakePedalDepressed : Boolean;
            attribute maintenanceTime : Time::TimeInstantValue;
            attribute maintenanceInterval : Time::TimeInstantValue;
            attribute maxTemperature;
        }
        attribute def VehicleStatus {
            private import ScalarValues::*;
            attribute gearSetting : Integer;
            attribute acceleratorPosition : Real;
        }
        part def Engine;
        part def Person;
    }

    package 'Vehicle Abstract Definition Example' {
        abstract part def Vehicle;
        part def HumanDrivenVehicle specializes Vehicle {
            ref part driver : Person;
        }
        part def PoweredVehicle :> Vehicle {
            part eng : Engine;
        }
        part def HumanDrivenPoweredVehicle :> HumanDrivenVehicle, PoweredVehicle;
        part def Engine;
        part def Person;
    }

    package 'Subsetting Example' {
        part def Vehicle {
            part parts : VehiclePart [*];
            part eng : Engine subsets parts;
            part trans : Transmission subsets parts;
            part wheels : Wheel [4] :> parts;
        }
        abstract part def VehiclePart;
        part def Engine :> VehiclePart;
        part def Transmission :> VehiclePart;
        part def Wheel :> VehiclePart;
    }

    package 'Redefinition Example' {
        part def Vehicle {
            part eng : Engine;
        }
        part def SmallVehicle :> Vehicle {
            part smallEng : SmallEngine redefines eng;
        }
        part def BigVehicle :> Vehicle {
            part bigEng : BigEngine :>> eng;
        }
        part def Engine {
            part cyl : Cylinder [4..6];
        }
        part def SmallEngine :> Engine {
            part redefines cyl [4];
        }
        part def BigEngine :> Engine {
            part redefines cyl [6];
        }
        part def Cylinder;
    }

    package 'Enumeration Definitions Example' {
        enum def TrafficLightColor {
            enum green;
            enum yellow;
            enum red;
        }
        part def TrafficLight {
            attribute currentColor : TrafficLightColor;
        }
        part def TrafficLightGo specializes TrafficLight {
            attribute redefines currentColor = TrafficLightColor::green;
        }
        attribute def ClassificationLevel {
            attribute code : String;
            attribute color : TrafficLightColor;
        }
        enum def ClassificationKind specializes ClassificationLevel {
            unclassified {
                :>> code = "uncl";
                :>> color = TrafficLightColor::green;
            }
            confidential {
                :>> code = "conf";
                :>> color = TrafficLightColor::yellow;
            }
            secret {
                :>> code = "secr";
                :>> color = TrafficLightColor::red;
            }
        }
        enum def GradePoints :> Real {
            A = 4.0;
            B = 3.0;
            C = 2.0;
            D = 1.0;
            F = 0.0;
        }
    }

    package 'Parts Example' {
        // Definitions
        part def Vehicle;
        part def Engine;
        part def Cylinder;
        // Usages
        part vehicle : Vehicle {
            part eng : Engine {
                part cyl : Cylinder [4..6];
            }
        }
        part smallVehicle :> vehicle {
            part redefines eng {
                part redefines cyl [4];
            }
        }
        part bigVehicle :> vehicle {
            part redefines eng {
                part redefines cyl [6];
            }
        }
    }

    package 'Items Example' {
        attribute def Temp;
        item def Fuel;
        item def Person;
        part def Vehicle {
            attribute mass : Real;
            ref item driver : Person;
            part fuelTank {
                item fuel : Fuel;
            }
        }
    }

    package 'Connections Example' {
        part def TireBead;
        part def TireMountingRim;
        part def WheelHubAssembly;
        part def WheelAssembly;
        part def Tire;
        part def Wheel;
        part def LugBoltMountingHole;
        part def LugBoltSeat;
        part def LugBoltJoint;
        part def LugBoltThreadableHole;
        part def Hub;
        connection def PressureSeat {
            end [1] part bead : TireBead;
            end [1] part mountingRim : TireMountingRim;
        }
        part wheelHubAssembly : WheelHubAssembly {
            part wheel : WheelAssembly [1] {
                part t : Tire [1] {
                    part bead : TireBead [2];
                }
                part w : Wheel [1] {
                    part rim : TireMountingRim [2];
                    part mountingHoles : LugBoltMountingHole [5];
                }
                connection : PressureSeat
                    connect bead references t.bead to mountingRim references w.rim;
            }
            part lugBoltJoints : LugBoltJoint [0..5];
            part hub : Hub [1] {
                part h : LugBoltThreadableHole [5];
            }
            connect [0..1] lugBoltJoints to [1] wheel.w.mountingHoles;
            connect [0..1] lugBoltJoints to [1] hub.h;
        }
    }

    package 'Ports Example' {
        private import 'Items Example'::Temp;
        private import 'Items Example'::Fuel;
        port def FuelOutPort {
            attribute temperature : Temp;
            out item fuelSupply : Fuel;
            in item fuelReturn : Fuel;
        }
        port def FuelInPort {
            attribute temperature : Temp;
            in item fuelSupply : Fuel;
            out item fuelReturn : Fuel;
        }
        part def FuelTankAssembly {
            port fuelTankPort : FuelOutPort;
        }
        part def Engine {
            port engineFuelPort : FuelInPort;
        }
    }

    package 'Port Conjugation Example' {
        private import 'Items Example'::Temp;
        private import 'Items Example'::Fuel;
        port def FuelPort {
            attribute temperature : Temp;
            out item fuelSupply : Fuel;
            in item fuelReturn : Fuel;
        }
        part def FuelTankAssembly {
            port fuelTankPort : FuelPort;
        }
        part def Engine {
            port engineFuelPort : ~FuelPort;
        }
    }

    package 'Interfaces Example' {
        private import 'Ports Example'::FuelOutPort;
        private import 'Ports Example'::FuelInPort;
        private import 'Ports Example'::FuelTankAssembly;
        private import 'Vehicle Definition Example'::Vehicle;
        private import 'Port Conjugation Example'::Engine;
        interface def FuelInterface {
            end port supplierPort : FuelOutPort;
            end port consumerPort : FuelInPort;
        }
        part vehicle : Vehicle {
            part tankAssy : FuelTankAssembly;
            part eng : Engine;
            interface : FuelInterface
                connect supplierPort ::> tankAssy.fuelTankPort
                to consumerPort ::> eng.engineFuelPort;
        }
    }

    package 'Interface Decomposition Example' {
        port def SpigotBank;
        port def Spigot;
        port def Faucet;
        port def FaucetInlet;
        interface def WaterDelivery {
            end [1] port suppliedBy : SpigotBank {
                port hot : Spigot;
                port cold : Spigot;
            }
            end [1..*] port deliveredTo : Faucet {
                port hot : FaucetInlet;
                port cold : FaucetInlet;
            }
            connect suppliedBy.hot to deliveredTo.hot;
            connect suppliedBy.cold to deliveredTo.cold;
        }
    }

    package 'Binding Connections' {
        private import 'Port Conjugation Example'::FuelTankAssembly;
        private import 'Items Example'::Fuel;
        part def FuelPump;
        part def FuelTank;
        part tank : FuelTankAssembly {
            port redefines fuelTankPort {
                out item redefines fuelSupply;
                in item redefines fuelReturn;
            }
            bind fuelTankPort.fuelSupply = pump.pumpOut;
            bind fuelTankPort.fuelReturn = tank.fuelIn;
            part pump : FuelPump {
                out item pumpOut : Fuel;
                in item pumpIn : Fuel;
            }
            part tank : FuelTank {
                out item fuelOut : Fuel;
                in item fuelIn : Fuel;
            }
        }
    }

    package 'Binding Connections - Feature Values Example';
    package 'Flow Usage Example';
    package 'Flows in Interfaces Example';
    package 'Flow Definitions Example';

    package 'Action Definition Example' {
        item def Scene;
        item def Image;
        item def Picture;
        action def Focus {
            in scene : Scene;
            out image : Image;
        }
        action def Shoot {
            in image : Image;
            out picture : Picture;
        }
        action def TakePicture {
            in scene : Scene;
            out picture : Picture;
            bind focus.scene = scene;
            action focus : Focus {
                in scene;
                out image;
            }
            flow focus.image to shoot.image;
            action shoot : Shoot {
                in image;
                out picture;
            }
            bind shoot.picture = picture;
        }
    }

    package 'Action Succession 1 Example' {
        item def Scene;
        item def Image;
        item def Picture;
        action def Focus {
            in scene : Scene;
            out image : Image;
        }
        action def Shoot {
            in image : Image;
            out picture : Picture;
        }
        action def TakePicture {
            in scene : Scene;
            out picture : Picture;
            bind focus.scene = scene;
            action focus : Focus {
                in scene;
                out image;
            }
            flow focus.image to shoot.image;
            first focus then shoot;
            action shoot : Shoot {
                in image;
                out picture;
            }
            bind shoot.picture = picture;
        }
    }

    package 'Action Succession 2 Example' {
        item def Scene;
        item def Image;
        item def Picture;
        action def Focus {
            in scene : Scene;
            out image : Image;
        }
        action def Shoot {
            in image : Image;
            out picture : Picture;
        }
        action def TakePicture {
            in scene : Scene;
            out picture : Picture;
            bind focus.scene = scene;
            action focus : Focus {
                in scene;
                out image;
            }
            succession flow focus.image to shoot.image;
            action shoot : Shoot {
                in image;
                out picture;
            }
            bind shoot.picture = picture;
        }
    }

    package 'State Definitions Example' {
        private import 'Vehicle Definition Example'::Vehicle;
        part def VehicleController;
        action def ControllerStartSignal;
        action def VehicleStartSignal;
        action def VehicleOnSignal;
        action def VehicleOffSignal;
        package 'State Definitions 1' {
            state def VehicleStates {
                entry;
                then off;
                state off;
                transition off_to_starting first off accept VehicleStartSignal then starting;
                state starting;
                transition starting_to_on first starting accept VehicleOnSignal then on;
                state on;
                transition on then done;
                transition on_to_off first on accept VehicleOffSignal then off;
            }
        }
        package 'State Definitions 2' {
            state def VehicleStates {
                entry;
                then off;
                state off;
                transition off accept VehicleStartSignal then starting;
                state starting;
                transition starting accept VehicleOnSignal then on;
                state on;
                transition on then done;
                transition on accept VehicleOffSignal then off;
            }
        }
        package 'State Decomposition' {
            state def VehicleStates;
            state vehicleStates : VehicleStates {
                entry;
                then off;
                state off;
                transition off accept VehicleStartSignal then starting;
                state starting;
                transition starting accept VehicleOnSignal then on;
                state on;
                transition on then done;
                transition on accept VehicleOffSignal then off;
            }
        }
        package 'Concurrent States' {
            state def VehicleStates;
            state vehicleStates : VehicleStates parallel {
                state operationalStates {
                    entry;
                    then off;
                    state off;
                    transition off accept VehicleStartSignal then starting;
                    state starting;
                    transition starting accept VehicleOnSignal then on;
                    state on;
                    transition on then done;
                    transition on accept VehicleOffSignal then off;
                }
                state healthStates {
                    entry;
                    then off;
                    state off;
                    transition off then done;
                }
            }
        }
        package 'State Entry, Do and Exit Actions' {
            action performSelfTest { in vehicle : Vehicle; }
            state def VehicleStates { in operatingVehicle : Vehicle; }
            state vehicleStates : VehicleStates {
                in operatingVehicle : Vehicle;
                entry;
                then off;
                state off;
                transition off accept VehicleStartSignal then starting;
                state starting;
                transition starting accept VehicleOnSignal then on;
                state on {
                    entry performSelfTest { in vehicle = operatingVehicle; }
                    do action providePower;
                    exit action applyParkingBrake;
                }
                transition on accept VehicleOffSignal then off;
            }
        }
        package 'Transition Guards and Effect Actions' {
            action performSelfTest { in vehicle : Vehicle; }
            state def VehicleStates {
                in operatingVehicle : Vehicle;
                in controller : VehicleController;
            }
            state vehicleStates : VehicleStates {
                in operatingVehicle : Vehicle;
                in controller : VehicleController;
                entry;
                then off;
                state off;

                transition
                    off
                    accept VehicleStartSignal
                    if operatingVehicle.brakePedalDepressed
                        do send new ControllerStartSignal() to controller
                    then starting;
                state starting;
                transition starting accept VehicleOnSignal then on;
                state on;
                transition on accept VehicleOffSignal then off;
            }
        }
        package 'Change and Time Triggers' {
            action def OverTemp;
            attribute def TemperatureValue;
            action senseTemperature { out temp : TemperatureValue; }
            state healthStates {
                in vehicle : Vehicle;
                in controller : VehicleController;
                entry;
                then normal;
                do senseTemperature;
                state normal;
                transition normal accept at vehicle.maintenanceTime then maintenance;
                transition
                    normal
                    accept when senseTemperature.temp > vehicle.maxTemperature
                    do send new OverTemp() to controller
                    then degraded;
                state maintenance {
                    entry assign vehicle
                        .maintenanceTime := vehicle.maintenanceTime + vehicle.maintenanceInterval;
                }
                transition maintenance accept after 48 [h] then normal;
                state degraded;
                transition
                    degraded
                    accept when senseTemperature.temp <= vehicle.maxTemperature
                    then normal;
            }
        }
    }
}
