package 'Clean Model' {
    abstract part def Vehicle {
        attribute Year;
    }
    part def Volvo :> Vehicle {
        attribute Country;
    }
    part laPoderosa : Volvo {
        :>> Year = "1988";
        :>> Country = "Mexico";
        attribute Motor = "ICE";
    }
}