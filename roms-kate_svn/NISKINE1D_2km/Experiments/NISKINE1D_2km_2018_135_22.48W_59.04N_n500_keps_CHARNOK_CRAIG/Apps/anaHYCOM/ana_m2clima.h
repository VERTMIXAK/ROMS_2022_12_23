      SUBROUTINE ana_m2clima (ng, tile, model)
!
!! svn $Id$
!!======================================================================
!! Copyright (c) 2002-2013 The ROMS/TOMS Group                         !
!!   Licensed under a MIT/X style license                              !
!!   See License_ROMS.txt                                              !
!=======================================================================
!                                                                      !
!  This routine sets analytical 2D momentum climatology fields.        !
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
      CALL ana_m2clima_tile (ng, tile, model,                           &
     &                       LBi, UBi, LBj, UBj,                        &
     &                       IminS, ImaxS, JminS, JmaxS,                &
     &                       CLIMA(ng) % ubarclm,                       &
     &                       CLIMA(ng) % vbarclm)
!
! Set analytical header file name used.
!
#ifdef DISTRIBUTE
      IF (Lanafile) THEN
#else
      IF (Lanafile.and.(tile.eq.0)) THEN
#endif
        ANANAME(11)=__FILE__
      END IF

      RETURN
      END SUBROUTINE ana_m2clima
!
!***********************************************************************
      SUBROUTINE ana_m2clima_tile (ng, tile, model,                     &
     &                             LBi, UBi, LBj, UBj,                  &
     &                             IminS, ImaxS, JminS, JmaxS,          &
     &                             ubarclm, vbarclm)
!***********************************************************************
!
      USE mod_param
      USE mod_scalars
!
      USE exchange_2d_mod
#ifdef DISTRIBUTE
      USE mp_exchange_mod, ONLY : mp_exchange2d
#endif
!
!  Imported variable declarations.
!
      integer, intent(in) :: ng, tile, model
      integer, intent(in) :: LBi, UBi, LBj, UBj
      integer, intent(in) :: IminS, ImaxS, JminS, JmaxS
!
#ifdef ASSUMED_SHAPE
      real(r8), intent(out) :: ubarclm(LBi:,LBj:)
      real(r8), intent(out) :: vbarclm(LBi:,LBj:)
#else
      real(r8), intent(out) :: ubarclm(LBi:UBi,LBj:UBj)
      real(r8), intent(out) :: vbarclm(LBi:UBi,LBj:UBj)
#endif
!
!  Local variable declarations.
!
      integer :: i, j

#include "set_bounds.h"
!
!-----------------------------------------------------------------------
!  Set 2D momentum climatology.
!-----------------------------------------------------------------------
!
      DO j=JstrR,JendR
        DO i=Istr,IendR
! JGP          ubarclm(i,j)=???
          ubarclm(i,j)= 0.
        END DO
      END DO
      DO j=Jstr,JendR
        DO i=IstrR,IendR
! JGP          vbarclm(i,j)=???
          vbarclm(i,j)=0.
        END DO
      END DO
!
!  Exchange boundary data.
!
      IF (EWperiodic(ng).or.NSperiodic(ng)) THEN
        CALL exchange_u2d_tile (ng, tile,                               &
     &                          LBi, UBi, LBj, UBj,                     &
     &                          ubarclm)
        CALL exchange_v2d_tile (ng, tile,                               &
     &                          LBi, UBi, LBj, UBj,                     &
     &                          vbarclm)
      END IF

#ifdef DISTRIBUTE
      CALL mp_exchange2d (ng, tile, model, 2,                           &
     &                    LBi, UBi, LBj, UBj,                           &
     &                    NghostPoints,                                 &
     &                    EWperiodic(ng), NSperiodic(ng),               &
     &                    ubarclm, vbarclm)
#endif

      RETURN
      END SUBROUTINE ana_m2clima_tile
