      SUBROUTINE ana_tclima (ng, tile, model)
!
!! svn $Id$
!!======================================================================
!! Copyright (c) 2002-2013 The ROMS/TOMS Group                         !
!!   Licensed under a MIT/X style license                              !
!!   See License_ROMS.txt                                              !
!=======================================================================
!                                                                      !
!  This routine sets analytical tracer climatology fields.             !
!                                                                      !
!=======================================================================
!
      USE mod_param
      USE mod_clima
      USE mod_ncparam
!
! Imported variable declarations.
!
      integer, intent(in) :: ng, tile, model

#include "tile.h"
!
      CALL ana_tclima_tile (ng, tile, model,                            &
     &                      LBi, UBi, LBj, UBj,                         &
     &                      IminS, ImaxS, JminS, JmaxS,                 &
     &                      CLIMA(ng) % tclm)
!
! Set analytical header file name used.
!
#ifdef DISTRIBUTE
      IF (Lanafile) THEN
#else
      IF (Lanafile.and.(tile.eq.0)) THEN
#endif
        ANANAME(33)=__FILE__
      END IF

      RETURN
      END SUBROUTINE ana_tclima
!
!***********************************************************************
      SUBROUTINE ana_tclima_tile (ng, tile, model,                      &
     &                            LBi, UBi, LBj, UBj,                   &
     &                            IminS, ImaxS, JminS, JmaxS,           &
     &                            tclm)
!***********************************************************************
!
      USE mod_param
      USE mod_grid
      USE mod_scalars
#if defined BIO_GOANPZ && defined IRON_LIMIT
      USE mod_biology
#endif
!
      USE exchange_3d_mod, ONLY : exchange_r3d_tile
#ifdef DISTRIBUTE
      USE mp_exchange_mod, ONLY : mp_exchange4d
#endif
!
!  Imported variable declarations.
!
      integer, intent(in) :: ng, tile, model
      integer, intent(in) :: LBi, UBi, LBj, UBj
      integer, intent(in) :: IminS, ImaxS, JminS, JmaxS
!
#ifdef ASSUMED_SHAPE
      real(r8), intent(out) :: tclm(LBi:,LBj:,:,:)
#else
      real(r8), intent(out) :: tclm(LBi:UBi,LBj:UBj,N(ng),NT(ng))
#endif
!
!  Local variable declarations.
!
      integer :: i, itrc, j, k
      real(r8) :: val1, val2, val3, val4

      real(r8) :: jgpn2max,jgpn2min,jgpatg,jgpp1,jgpp2
      real(r8) :: jgpz1,jgpz2,jgptofz1,jgptofz2,jgptmax
      real(r8) :: jgpa1,jgpb1,jgpa2,jgpb2,jgpc2,jgpa3,jgpb3

#include "set_bounds.h"
!
!-----------------------------------------------------------------------
!  Set tracer climatology.
!-----------------------------------------------------------------------
!
#if defined DOUBLE_GYRE
      val1=(44.69_r8/39.382_r8)**2
      val2=val1*(rho0*100.0_r8/g)*(5.0E-5_r8/((42.689_r8/44.69_r8)**2))
      DO k=1,N(ng)
        DO j=JstrR,JendR
          DO i=IstrR,IendR
            val3=T0(ng)+val2*EXP(GRID(ng)%z_r(i,j,k)/100.0_r8)*         &
     &           (10.0_r8-0.4_r8*TANH(GRID(ng)%z_r(i,j,k)/100.0_r8))
            val4=GRID(ng)%yr(i,j)/el(ng)
            tclm(i,j,k,itemp)=val3-3.0_r8*val4
# ifdef SALINITY
            tclm(i,j,k,isalt)=34.5_r8-0.001_r8*GRID(ng)%z_r(i,j,k)-val4
# endif
          END DO
        END DO
      END DO
#elif defined BIO_GOANPZ && defined IRON_LIMIT
! Iron - linear from surface value to value at 100m and increase onshore
      DO i=IstrR,IendR
        DO j=JstrR,JendR
          val3 = MAX(0.,MIN(1.,(GRID(ng)%h(i,j)-Feinh)/(Feoffh-Feinh)))
          val1 = Feinlo + val3*(Feofflo-Feinlo)
          val2 = Feinhi + val3*(Feoffhi-Feinhi)
          val3 = (val2-val1) / 100._r8
          DO k=1,N(ng)
            tclm(i,j,k,iFe) = MIN(val2, val1 - GRID(ng)%z_r(i,j,k)*val3)
          END DO
        END DO
      END DO



!! JGP here is Harper's Bay of Bengal stratification
# elif defined BoB || defined SCS
      jgpn2max = 4.4419E-04_r8
      jgpn2min = 3.1623E-07_r8
      jgpatg   = 2.0E-04_r8 * 9.8_r8
      jgpp1    = -1.8593_r8
      jgpp2    =  0.3259_r8
      jgptmax  = 47.0_r8

! JGP jgpz1 and jgpz2 are positive quantities here
      jgpz1 = 10._r8**( (LOG10(jgpn2max)-jgpp2)/jgpp1)
      jgpz2 = 10._r8**( (LOG10(jgpn2min)-jgpp2)/jgpp1)

      jgptofz1 = jgptmax - jgpn2max*jgpz1/jgpatg
      jgptofz2 = jgptofz1 - 10._r8**jgpp2/jgpatg/(1.0_r8+jgpp1) *	&
     &     ( jgpz2**(1.0_r8+jgpp1) - jgpz1**(1.0_r8+jgpp1) )

      jgpa1 = jgptmax
      jgpb1 = jgpn2max/jgpatg

      jgpc2 = 1.0_r8+jgpp1
      jgpb2 = 10.0_r8**jgpp2/jgpc2/jgpatg
      jgpa2 = jgptofz1 + jgpb2*jgpz1**jgpc2

      jgpb3 = jgpn2min/jgpatg
      jgpa3 = jgptofz2 + jgpb3*jgpz2

      DO k=1,N(ng)
        DO j=JstrR,JendR
          DO i=IstrR,IendR

            IF ( abs(GRID(ng)%z_r(i,j,k)) < jgpz1) THEN
              tclm(i,j,k,itemp) = jgpa1 + jgpb1*GRID(ng)%z_r(i,j,k)
            ELSE IF ( abs(GRID(ng)%z_r(i,j,k)) > jgpz2) THEN
              tclm(i,j,k,itemp) = jgpa3 + jgpb3*GRID(ng)%z_r(i,j,k)
            ELSE
              tclm(i,j,k,itemp) =                                       &
     &             jgpa2-jgpb2*(-1.0_r8*GRID(ng)%z_r(i,j,k))**jgpc2
            END IF
!            IF ( abs(z_r(i,j,k)) < jgpz1) THEN
!              t(i,j,k,1,itemp) = jgpa1 + jgpb1*z_r(i,j,k)
!            ELSE IF ( abs(z_r(i,j,k)) > jgpz2) THEN
!              t(i,j,k,1,itemp) = jgpa3 + jgpb3*z_r(i,j,k)
!            ELSE
!              t(i,j,k,1,itemp)=jgpa2-jgpb2*(-1.0_r8*z_r(i,j,k))**jgpc2
!            END IF

#  ifdef SALINITY
            t(i,j,k,1,isalt)=S0(ng)
#  endif
          END DO
        END DO
      END DO
!! JGP end Bay of Bengal stratification




#else
      DO k=1,N(ng)
        DO j=JstrR,JendR
          DO i=IstrR,IendR
            tclm(i,j,k,itemp)=???
            tclm(i,j,k,isalt)=???
          END DO
        END DO
      END DO
#endif
!
!  Exchange boundary data.
!
      IF (EWperiodic(ng).or.NSperiodic(ng)) THEN
        DO itrc=1,NAT
          CALL exchange_r3d_tile (ng, tile,                             &
     &                            LBi, UBi, LBj, UBj, 1, N(ng),         &
     &                            tclm(:,:,:,itrc))
        END DO
      END IF

#ifdef DISTRIBUTE
      CALL mp_exchange4d (ng, tile, model, 1,                           &
     &                    LBi, UBi, LBj, UBj, 1, N(ng), 1, NAT,         &
     &                    NghostPoints,                                 &
     &                    EWperiodic(ng), NSperiodic(ng),               &
     &                    tclm)
#endif

      RETURN
      END SUBROUTINE ana_tclima_tile
