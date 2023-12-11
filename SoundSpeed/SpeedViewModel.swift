//
//  SpeedViewModel.swift
//  SoundWeather
//
//  Created by Marcus Painter on 10/12/2023.
//

// http://gsd.ime.usp.br/acmus/software/yili/SpeedOfSound/SpeedOfSound.java
// http://resource.npl.co.uk/acoustics/techguides/speedair/
// Range of validity: the calculator is only valid over the temperature range 0 to 30 ° C (273.15 - 303.15 K) and for the pressure range 75 - 102 kPa

import Foundation

class SpeedViewModel: ObservableObject {
    @Published var speed: Double = 0.0
    
    /// Calculates the speed of sound
    /// - Parameters:
    ///   - temperature: In Celsius.
    ///   - pressure: In kPa.
    ///   - humidity: In percent.
    func getSpeed(temperature: Double, pressure: Double, humidity: Double) {
  
        let temp: Double = temperature  // 20.0     °C
        let p: Double = pressure * 1000 // 101.325  kPa
        let humidity: Double = humidity // 0111111  %
        
        var a: [Double] = [Double](repeating: 0, count: 16)
        a[0] = 331.5024
        a[1] = 0.603055
        a[2] = -0.000528
        a[3] = 51.471935
        a[4] = 0.1495874
        a[5] = -0.000782
        a[6] = -1.82e-7
        a[7] = 3.73e-8
        a[8] = -2.93e-10
        a[9] = -85.20931
        a[10] = -0.228525
        a[11] = 5.91e-5
        a[12] = -2.835149
        a[13] = -2.15e-13
        a[14] = 29.179762
        a[15] = 0.000486
        
        let T = temp + 273.15
        let h = humidity / 100.0
        
        var f = 1.00062 + 0.0000000314 * p
        f = f + 0.00000056 * temp * temp
        var Psv = 0.000012811805 * T * T
        Psv = Psv - 0.019509874 * T
        Psv = Psv + 34.04926034 - 6353.6311 / T
        Psv = exp(Psv)
        let Xw = h * f * Psv / p
        var c = 331.45 - a[0] - p * a[6] - a[13] * p * p
        c = sqrt(a[9] * a[9] + 4 * a[14] * c)
        let Xc = ((-1) * a[9] - c) / (2 * a[14])
        
        var speed = a[0] + a[1] * temp + a[2] * temp * temp
        speed = speed + (a[3] + a[4] * temp + a[5] * temp * temp) * Xw
        speed = speed + (a[6] + a[7] * temp + a[8] * temp * temp) * p
        speed = speed + (a[9] + a[10] * temp + a[11] * temp * temp) * Xc
        speed = speed + a[12] * Xw * Xw + a[13] * p * p + a[14] * Xc * Xc
        speed = speed + a[15] * Xw * p * Xc
        
        self.speed = privateRound(speed)
        
    }
    
    private func privateRound(_ x: Double) -> Double {
        return Double(round(10 * x) / 10)
    }
}

/*

func speedOfSound2(temperature: Double, pressure: Double, humidity: Double) -> Double {
    var a = [Double](repeating: 0.0, count: 16)
    a[0] = 331.5024
    a[1] = 0.603055
    a[2] = -0.000528
    a[3] = 51.471935
    a[4] = 0.1495874
    a[5] = -0.000782
    a[6] = -1.82e-7
    a[7] = 3.73e-8
    a[8] = -2.93e-10
    a[9] = -85.20931
    a[10] = -0.228525
    a[11] = 5.91e-5
    a[12] = -2.835149
    a[13] = -2.15e-13
    a[14] = 29.179762
    a[15] = 0.000486

    let p = presssure
    let T = temperature + 273.15
    let h = humidity / 100.0
    let f = 1.00062 + 0.0000000314 * p + 0.00000056 * temperature * temperature
    let Psv = exp(0.000012811805 * T * T - 0.019509874 * T + 34.04926034 - 6353.6311 / T)
    let Xw = h * f * Psv / p

    var c = 331.45 - a[0] - p * a[6] - a[13] * p * p
    c = sqrt(a[9] * a[9] + 4 * a[14] * c)
    let Xc = ((-1) * a[9] - c) / (2 * a[14])

    c = a[0] + a[1] * temperature + a[2] * temperature * temperature +
        (a[3] + a[4] * temperature + a[5] * temperature * temperature) * Xw +
        (a[6] + a[7] * temperature + a[8] * temperature * temperature) * p +
        (a[9] + a[10] * temperature + a[11] * temperature * temperature) * Xc +
        a[12] * Xw * Xw + a[13] * p * p + a[14] * Xc * Xc +
        a[15] * Xw * p * Xc

    return c
}

func speed(temp: Double, humidity: Double, p: Double) -> Double {
    var a = [Double](repeating: 0.0, count: 16)
    a[0] = 331.5024
    a[1] = 0.603055
    a[2] = -0.000528
    a[3] = 51.471935
    a[4] = 0.1495874
    a[5] = -0.000782
    a[6] = -1.82e-7
    a[7] = 3.73e-8
    a[8] = -2.93e-10
    a[9] = -85.20931
    a[10] = -0.228525
    a[11] = 5.91e-5
    a[12] = -2.835149
    a[13] = -2.15e-13
    a[14] = 29.179762
    a[15] = 0.000486
    let T = temp + 273.15
    let h = humidity /100.0
    let f = 1.00062 + 0.0000000314 * p + 0.00000056 * temp * temp
    let Psv = exp(0.000012811805 * T * T - 0.019509874 * T +
        34.04926034 - 6353.6311 / T)
    let Xw = h * f * Psv / p
    var c = 331.45 - a[0] - p * a[6] - a[13] * p * p
    var c = Math.sqrt(a[9] * a[9] + 4 * a[14] * c)
    let Xc = ((-1) * a[9] - c) / (2 * a[14])
    let speed = a[0] + a[1] * temp + a[2] * temp * temp +
        (a[3] + a[4] * temp + a[5] * temp * temp) * Xw +
        (a[6] + a[7] * temp + a[8] * temp * temp) * p +
        (a[9] + a[10] * temp + a[11] * temp * temp) * Xc +
        a[12] * Xw * Xw + a[13] * p * p + a[14] * Xc * Xc +
        a[15] * Xw * p * Xc
    return speed
}


func Calculate_OnClick(temp: Double, humidity: Double, p: Double) -> Double {
    // main body of program to calculate speed of sound in humid air

    var T = 0.0     // temperature degC
    var P = 0.0     // pressure
    var Rh = 0.0    // relative humidity
    var C = 0.0     // speed
    var Xc = 0.0
    var Xw = 0.0    // Mole fraction of carbon dioxide and water vapour respectively
    var H = 0.0     // molecular concentration of water vapour

    var C1 = 0.0    // Intermediate calculations
    var C2 = 0.0
    var C3 = 0.0

    var ENH = 0.0
    var PSV = 0.0
    var PSV1 = 0.0
    var PSV2 = 0.0

    var T_kel = 0.0 // ambient temperature (Kelvin)

    var Kelvin = 273.15 // For converting to Kelvin
    var e = 2.71828182845904523536

    // Get variables from form
    T = temp
    P = p * 1000.0
    Rh = humidity

    // Check that sensible numbers were entered
    if (Rh > 100) || Rh < 0 {
        print("Relative humidity must be between 0 and 100%")
    }

    let T_kel = Kelvin + T // Measured ambient temp

    // Molecular concentration of water vapour calculated from Rh
    // using Giacomos method by Davis (1991) as implemented in DTU report 11b-1997
    let ENH_1 = 3.14 * pow(10, -8) * P
    let ENH_2 = 1.00062 + sqr(T) * 5.6 * pow(10, -7)
    ENH = ENH_1 + ENH_2
    
    // These commented lines correspond to values used in Cramer (Appendix)
    // PSV1 = sqr(T_kel)*1.2811805*Math.pow(10,-5)-1.9509874*Math.pow(10,-2)*T_kel ;
    // PSV2 = 34.04926034-6.3536311*Math.pow(10,3)/T_kel;
    PSV1 = sqr(T_kel) * 1.2378847 * pow(10, -5) - 1.9121316 * pow(10, -2) * T_kel
    PSV2 = 33.93711047 - 6.3431645 * pow(10, 3) / T_kel
    PSV = pow(e, PSV1) * pow(e, PSV2)
    H = Rh * ENH * PSV / P
    Xw = H / 100.0
    // Xc = 314.0*pow(10,-6);
    Xc = 400.0 * pow(10, -6)

    // Speed calculated using the method of Cramer from
    // JASA vol 93 pg 2510
    let C1_1 = 0.603055 * T + 331.5024 - sqr(T) * 5.28 * pow(10, -4)
    let C1_2 = (0.1495874 * T + 51.471935 -sqr(T) * 7.82 * pow(10, -4)) * Xw
    C1 = C1_1 + C1+2
    
    C2 = (-1.82 * pow(10, -7) + 3.73 * pow(10, -8) * T - sqr(T) * 2.93 * pow(10, -10)) * P + (-85.20931 - 0.228525 * T + sqr(T) * 5.91 * pow(10, -5)) * Xc
    C3 = sqr(Xw) * 2.835149 + sqr(P) * 2.15 * pow(10, -13) - sqr(Xc) * 29.179762 - 4.86 * pow(10, -4) * Xw * P * Xc
    C = C1 + C2 - C3

    return C
}

func sqr(_ x: Double) {
    return x * x
}
 */
