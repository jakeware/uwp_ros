/***********************************************************************
 UDF for specifying steady-state parabolic pressure profile boundary
 profile for a turbine vane
 ************************************************************************/
 
 #include "udf.h"
 
 DEFINE_PROFILE(x_velocity,t,i)
 {
    real z_h = 10.0;  // mean structure height [m] 
    real z_0 = 1.0;  // surface roughness for category 7 environment [m]
    real z_d = 0.7*z_h;  // displacement distance for category 7 environment [m]
    real z_ref = 70*0.3048;  // reference height [ft -> m]
    real u_ref = 10.0;  // speed at reference height [m/s]
    real k = 0.4;  // von Karman's constant
    real lam_f = 0.3;  // ratio of frontal area to total area
    real z_w = 2.0*z_h;  // roughness/blending/wake-diffusion height
    real a = 9.6*lam_f;  // empirical constant

    real z;  // altitude
    real u_star = u_ref * k / log(z_ref - z_d) / z_0;  // friction velocity
    real u_h = u_star / k * log(z_h - z_d) / z_0;  // urban canopy layer profile
    real l_c = z_h / a * u_star / u_h;  // turbulent mixing length
    real A = l_c - (z_h / (z_w - z_h)) * (k * (z_w - z_d) - l_c);  // constant
    real B = (1.0 / (z_w - z_h)) * (k * (z_w - z_d) - l_c);  // constant

    real x[ND_ND];    /* this will hold the position vector */
    face_t f;
    begin_f_loop(f,t)
      {
        F_CENTROID(x,f,t);
        z = x[2];
        if (z < z_h) {
          F_PROFILE(f,t,i) = u_h*exp(-a * (1 - (z/z_h)));
        } else if (z >= z_h && z < z_w) {
          F_PROFILE(f,t,i) = u_star / B * log((A + B * z) / (A + B * z_h)) + u_h;
        } else {
          F_PROFILE(f,t,i) = u_star / k * log((z - z_d) / z_0);
        }
      }
    end_f_loop(f,t)
 } 