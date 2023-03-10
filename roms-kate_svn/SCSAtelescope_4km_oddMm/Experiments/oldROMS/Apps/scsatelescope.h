/*
** svn $Id$
*******************************************************************************
** Copyright (c) 2002-2017 The ROMS/TOMS Group
**
**   Licensed under a MIT/X style license
**
**   See License_ROMS.txt
**
*******************************************************************************
**
**  Options for ARCTIC simulation
*/

#undef NO_HIS
#undef GLOBAL_PERIODIC
#define HDF5
#define DEFLATE
#undef PARALLEL_IO
#define PERFECT_RESTART
#define NO_LBC_ATT

/* general */

#define CURVGRID
#define MASKING
#define NONLIN_EOS
#define SOLVE3D

/* jgp undef for tides only */
#undef SALINITY

#ifdef SOLVE3D
# undef SPLINES_VDIFF
# undef SPLINES_VVISC
# define RI_SPLINES
#endif
#undef FLOATS
#undef STATIONS

/* jgp undef */
#undef WET_DRY

#define IMPLICIT_NUDGING





/* ice */

/* jgp comment this section out 

#ifdef SOLVE3D
# define  ICE_MODEL
# ifdef ICE_MODEL
#  undef  OUTFLOW_MASK
#  define ICE_LANDFAST
#  define ICE_THERMO
#  define ICE_MK
#  define ICE_MOMENTUM
#  define ICE_MOM_BULK
#  define ICE_EVP
#  define ICE_STRENGTH_QUAD
#  define ICE_ADVECT
#  define ICE_SMOLAR
#  define ICE_UPWIND
#  define ICE_BULK_FLUXES
#  define ICE_CONVSNOW
#  define ICE_I_O
#  define ICE_DIAGS
# endif
#endif

end jgp */




/* output stuff */

#define NO_WRITE_GRID
#undef OUT_DOUBLE
#ifndef PERFECT_RESTART
# define RST_SINGLE
#endif
#undef AVERAGES
#undef AVERAGES2
#ifdef SOLVE3D
# undef AVERAGES_DETIDE
# undef DIAGNOSTICS_TS
#endif
#undef DIAGNOSTICS_UV

/* advection, dissipation, pressure grad, etc. */

#ifdef SOLVE3D
# define DJ_GRADPS
#endif

#define UV_ADV
#define UV_COR
#undef UV_SADVECTION

#define UV_VIS2
#undef UV_SMAGORINSKY
#undef VISC_3DCOEF
#define MIX_S_UV
#define VISC_GRID

#ifdef SOLVE3D
# define TS_DIF2
# define MIX_GEO_TS
# define DIFF_GRID
#endif

/* vertical mixing */

#ifdef SOLVE3D
# define WTYPE_GRID

# define LMD_MIXING
# ifdef LMD_MIXING
#  define LMD_RIMIX
#  define LMD_CONVEC
#  define LMD_SKPP
#  define LMD_BKPP
#  define LMD_NONLOCAL
#  define LMD_SHAPIRO
#  define LMD_DDMIX
# endif

# undef GLS_MIXING
# undef MY25_MIXING

# if defined GLS_MIXING || defined MY25_MIXING
#  define KANTHA_CLAYSON
#  define N2S2_HORAVG
# endif
#endif





/* surface forcing */

/* jgp comment this out to eliminate surface forcing

#ifdef SOLVE3D
# define CORE_FORCING
# define BULK_FLUXES
# define CCSM_FLUXES
# if defined BULK_FLUXES || defined CCSM_FLUXES
#  define LONGWAVE_OUT
#  define SOLAR_SOURCE
#  define EMINUSP
#  undef ALBEDO_CLOUD
#  define ALBEDO_CURVE  
#  undef ICE_ALB_EC92   
#  define ALBEDO_CSIM   
#  undef ALBEDO_FILE    
#  undef LONGWAVE
# endif
#endif

jgp end */

/* analytic functions that are all zeros */

#define ANA_BSFLUX   
#define ANA_BTFLUX
/*   
#define ANA_DRAG_GRID   
*/
#define ANA_SMFLUX 
#define ANA_SRFLUX
#define ANA_STFLUX






/* surface and side corrections */

#ifdef SOLVE3D

/* jgp undef these
# undef SCORRECTION
# undef NO_SCORRECTION_ICE
*/

# undef QCORRECTION
#endif

#ifdef SOLVE3D
# define ANA_NUDGCOEF
#endif

/* point sources (rivers, line sources) */

/* Using both for different regions */
#ifdef SOLVE3D
# undef RUNOFF
# define ONE_TRACER_SOURCE
#endif

/* tides */

#define LTIDES
#ifdef LTIDES
# if defined AVERAGES && !defined USE_DEBUG
#  define FILTERED
# endif
# define SSH_TIDES
# define UV_TIDES
# define ADD_FSOBC
# define ADD_M2OBC
# undef RAMP_TIDES
# define TIDES_ASTRO
# undef POT_TIDES

# define UV_DRAG_GRID
# define ANA_DRAG
# define LIMIT_BSTRESS
# undef UV_LDRAG
# define UV_QDRAG
#else
# define UV_QDRAG
#endif

/* Boundary conditions...careful with grid orientation */

#define RADIATION_2D

/* roms quirks */

#ifdef SOLVE3D
# define ANA_BSFLUX
# define ANA_BTFLUX
#else
# define ANA_SMFLUX
#endif
