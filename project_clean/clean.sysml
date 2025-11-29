package 'Clean Model' {
    abstract part def Vehicle {
        part wheels : Wheels [4];
        part motor : Motor;
        attribute Year;
        attribute Country;
        attribute MotorType;
    }
    part def Volvo :> Vehicle {
        part seatbelt;
        part airbag;
    }
    part def Wheels;
    part def Motor;
    part laPoderosa : Volvo {
        :>> Year = "1988";
        :>> Country = "Mexico";
        :>> MotorType = "4cyl";
    }
}
