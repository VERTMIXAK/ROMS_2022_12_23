      SUBROUTINE ana_tobc (ng, tile, model)
!
!! svn $Id$
!!======================================================================
!! Copyright (c) 2002-2013 The ROMS/TOMS Group                         !
!!   Licensed under a MIT/X style license                              !
!!   See License_ROMS.txt                                              !
!=======================================================================
!                                                                      !
!  This routine sets tracer-type variables open boundary conditions    !
!  using analytical expressions.                                       !
!                                                                      !
!=======================================================================
!
      USE mod_param
      USE mod_boundary
      USE mod_grid
      USE mod_ncparam
      USE mod_ocean
      USE mod_stepping
!
! Imported variable declarations.
!
      integer, intent(in) :: ng, tile, model

#include "tile.h"
!
      CALL ana_tobc_tile (ng, tile, model,                              &
     &                    LBi, UBi, LBj, UBj,                           &
     &                    IminS, ImaxS, JminS, JmaxS,                   &
     &                    nstp(ng),                                     &
     &                    GRID(ng) % z_r,                               &
     &                    OCEAN(ng) % t)
!
! Set analytical header file name used.
!
#ifdef DISTRIBUTE
      IF (Lanafile) THEN
#else
      IF (Lanafile.and.(tile.eq.0)) THEN
#endif
        ANANAME(34)=__FILE__
      END IF

      RETURN
      END SUBROUTINE ana_tobc
!
!***********************************************************************
      SUBROUTINE ana_tobc_tile (ng, tile, model,                        &
     &                          LBi, UBi, LBj, UBj,                     &
     &                          IminS, ImaxS, JminS, JmaxS,             &
     &                          nstp,                                   &
     &                          z_r, t)
!***********************************************************************
!
      USE mod_param
      USE mod_scalars
      USE mod_boundary
      USE mod_ncparam
      USE mod_ocean
#ifdef SEDIMENT
      USE mod_sediment
#endif
!
!  Imported variable declarations.
!
      integer, intent(in) :: ng, tile, model
      integer, intent(in) :: LBi, UBi, LBj, UBj
      integer, intent(in) :: IminS, ImaxS, JminS, JmaxS
      integer, intent(in) :: nstp

#ifdef ASSUMED_SHAPE
      real(r8), intent(in) :: z_r(LBi:,LBj:,:)
      real(r8), intent(in) :: t(LBi:,LBj:,:,:,:)
#else
      real(r8), intent(in) :: z_r(LBi:UBi,LBj:UBj,N(ng))
      real(r8), intent(in) :: t(LBi:UBi,LBj:UBj,N(ng),3,NT(ng))
#endif
!
!  Local variable declarations.
!
      integer :: i, ised, itrc, j, k
      real(r8) :: cff

      real(r8) :: jgpn2max,jgpn2min,jgpatg,jgpp1,jgpp2
      real(r8) :: jgpz1,jgpz2,jgptofz1,jgptofz2,jgptmax
      real(r8) :: jgpa1,jgpb1,jgpa2,jgpb2,jgpc2,jgpa3,jgpb3
      real(r8) :: jgp1,jgp2,jgp3,jgp4,jgp5,jgp6,jgp7,jgp8,jgpdum

#include "set_bounds.h"
!
!-----------------------------------------------------------------------
!  Tracers open boundary conditions.
!-----------------------------------------------------------------------
!
#ifdef ESTUARY_TEST
      IF (ANY(LBC(ieast,isTvar(:),ng)%acquire).and.                     &
     &    DOMAIN(ng)%Eastern_Edge(tile)) THEN
        DO k=1,N(ng)
          DO j=JstrR,JendR
            BOUNDARY(ng)%t_east(j,k,itemp)=T0(ng)
            BOUNDARY(ng)%t_east(j,k,isalt)=0.0_r8
# ifdef SEDIMENT
            DO ised=1,NST
              BOUNDARY(ng)%t_east(j,k,idsed(ised))=0.0_r8
            END DO
# endif
          END DO
        END DO
      END IF

      IF (ANY(LBC(iwest,isTvar(:),ng)%acquire).and.                     &
     &    DOMAIN(ng)%Western_Edge(tile)) THEN
        DO k=1,N(ng)
          DO j=JstrR,JendR
            BOUNDARY(ng)%t_west(j,k,itemp)=T0(ng)
            BOUNDARY(ng)%t_west(j,k,isalt)=30.0_r8
# ifdef SEDIMENT
            DO ised=1,NST
              BOUNDARY(ng)%t_west(j,k,idsed(ised))=0.0_r8
            END DO
# endif
          END DO
        END DO
      END IF

#elif defined NJ_BIGHT
      IF (ANY(LBC(ieast,isTvar(:),ng)%acquire).and.                     &
     &    DOMAIN(ng)%Eastern_Edge(tile)) THEN
        DO k=1,N(ng)
          DO j=JstrR,JendR
            IF (z_r(Iend+1,j,k).ge.-15.0_r8) THEN
              BOUNDARY(ng)%t_east(j,k,itemp)=2.04926425772840E+01_r8-   &
     &                                       z_r(Iend+1,j,k)*           &
     &                                       (2.64085084879392E-01_r8+  &
     &                                        z_r(Iend+1,j,k)*          &
     &                                        (2.75112532853521E-01_r8+ &
     &                                         z_r(Iend+1,j,k)*         &
     &                                        (9.20748976164887E-02_r8+ &
     &                                         z_r(Iend+1,j,k)*         &
     &                                        (1.44907572574284E-02_r8+ &
     &                                         z_r(Iend+1,j,k)*         &
     &                                        (1.07821568591208E-03_r8+ &
     &                                         z_r(Iend+1,j,k)*         &
     &                                        (3.24031805390397E-05_r8+ &
     &                                         1.26282685769027E-07_r8*
     &                                         z_r(Iend+1,j,k)))))))
              BOUNDARY(ng)%t_east(j,k,isalt)=3.06648914919313E+01_r8-   &
     &                                       z_r(Iend+1,j,k)*           &
     &                                       (1.47672526294673E-01_r8+  &
     &                                        z_r(Iend+1,j,k)*          &
     &                                        (1.12645576031340E-01_r8+ &
     &                                         z_r(Iend+1,j,k)*         &
     &                                        (3.90092328187102E-02_r8+ &
     &                                         z_r(Iend+1,j,k)*         &
     &                                        (6.93901493744710E-03_r8+ &
     &                                         z_r(Iend+1,j,k)*         &
     &                                        (6.60443669679294E-04_r8+ &
     &                                         z_r(Iend+1,j,k)*         &
     &                                        (3.19179236195422E-05_r8+ &
     &                                         6.17735263440932E-07_r8*
     &                                         z_r(Iend+1,j,k)))))))
            ELSE
              cff=TANH(1.1_r8*z_r(Iend+1,j,k)+15.9_r8)
              t_east(j,k,itemp)=14.6_r8+6.70_r8*cff
              t_east(j,k,isalt)=31.3_r8-0.55_r8*cff
            END IF
          END DO
        END DO
      END IF

      IF (ANY(LBC(isouth,isTvar(:),ng)%acquire).and.                     &
     &    DOMAIN(ng)%Southern_Edge(tile)) THEN
        DO k=1,N(ng)
          DO i=IstrR,IendR
            IF (z_r(i,Jstr-1,k).ge.-15.0_r8) THEN
              BOUNDARY(ng)%t_south(i,k,itemp)=2.04926425772840E+01_r8-  &
     &                                        z_r(i,Jstr-1,k)*          &
     &                                        (2.64085084879392E-01_r8+ &
     &                                         z_r(i,Jstr-1,k)*         &
     &                                         (2.75112532853521E-01_r8+&
     &                                          z_r(i,Jstr-1,k)*        &
     &                                         (9.20748976164887E-02_r8+&
     &                                          z_r(i,Jstr-1,k)*        &
     &                                         (1.44907572574284E-02_r8+&
     &                                          z_r(i,Jstr-1,k)*        &
     &                                         (1.07821568591208E-03_r8+&
     &                                          z_r(i,Jstr-1,k)*        &
     &                                         (3.24031805390397E-05_r8+&
     &                                          1.26282685769027E-07_r8*
     &                                          z_r(i,Jstr-1,k)))))))
              BOUNDARY(ng)%t_south(i,k,isalt)=3.06648914919313E+01_r8-  &
     &                                        z_r(i,Jstr-1,k)*          &
     &                                        (1.47672526294673E-01_r8+ &
     &                                         z_r(i,Jstr-1,k)*         &
     &                                         (1.12645576031340E-01_r8+&
     &                                          z_r(i,Jstr-1,k)*        &
     &                                         (3.90092328187102E-02_r8+&
     &                                          z_r(i,Jstr-1,k)*        &
     &                                         (6.93901493744710E-03_r8+&
     &                                          z_r(i,Jstr-1,k)*        &
     &                                         (6.60443669679294E-04_r8+&
     &                                          z_r(i,Jstr-1,k)*        &
     &                                         (3.19179236195422E-05_r8+&
     &                                          6.17735263440932E-07_r8*
     &                                          z_r(i,Jstr-1,k)))))))
            ELSE
              cff=TANH(1.1_r8*depth+15.9_r8)
              BOUNDARY(ng)%t_south(i,k,itemp)=14.6_r8+6.70_r8*cff
              BOUNDARY(ng)%t_south(i,k,isalt)=31.3_r8-0.55_r8*cff
            END IF
          END DO
        END DO
      END IF

#elif defined SED_TEST1
      IF (ANY(LBC(ieast,isTvar(:),ng)%acquire).and.                     &
     &    DOMAIN(ng)%Eastern_Edge(tile)) THEN
        DO k=1,N(ng)
          DO j=JstrR,JendR
            BOUNDARY(ng)%t_east(j,k,itemp)=20.0_r8
            BOUNDARY(ng)%t_east(j,k,isalt)=0.0_r8
          END DO
        END DO
      END IF

!! JGP here is Harper's analytic profile for BoB
# elif defined BoB 

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

      IF (ANY(LBC(ieast,isTvar(:),ng)%acquire).and.                     &
     &    DOMAIN(ng)%Eastern_Edge(tile)) THEN
        DO k=1,N(ng)
          DO j=JstrR,JendR

            IF ( abs(z_r(Iend+1,j,k)) < jgpz1) THEN
              BOUNDARY(ng)%t_east(j,k,itemp) = jgpa1 +                  &
     &               jgpb1*z_r(Iend+1,j,k)
            ELSE IF ( abs(z_r(Iend+1,j,k)) > jgpz2) THEN
              BOUNDARY(ng)%t_east(j,k,itemp) = jgpa3 +                  &
     &               jgpb3*z_r(Iend+1,j,k)
            ELSE
              BOUNDARY(ng)%t_east(j,k,itemp) = jgpa2 -                  &
     &               jgpb2*(-1.0_r8*z_r(Iend+1,j,k))**jgpc2
            END IF

          END DO
        END DO
      END IF

      IF (ANY(LBC(isouth,isTvar(:),ng)%acquire).and.                    &
     &    DOMAIN(ng)%Southern_Edge(tile)) THEN
        DO k=1,N(ng)
          DO i=IstrR,IendR

            IF ( abs(z_r(i,Jstr-1,k)) < jgpz1) THEN
              BOUNDARY(ng)%t_south(i,k,itemp) = jgpa1 +                 &
     &               jgpb1*z_r(i,Jstr-1,k)
            ELSE IF ( abs(z_r(i,Jstr-1,k)) > jgpz2) THEN
              BOUNDARY(ng)%t_south(i,k,itemp) = jgpa3 +                 &
     &               jgpb3*z_r(i,Jstr-1,k)
            ELSE
              BOUNDARY(ng)%t_south(i,k,itemp) = jgpa2 -                 &
     &               jgpb2*(-1.0_r8*z_r(i,Jstr-1,k))**jgpc2
            END IF

          END DO
        END DO
      END IF

      IF (ANY(LBC(iwest,isTvar(:),ng)%acquire).and.                     &
     &    DOMAIN(ng)%Western_Edge(tile)) THEN
        DO k=1,N(ng)
          DO j=JstrR,JendR

            IF ( abs(z_r(i,Istr-1,k)) < jgpz1) THEN
              BOUNDARY(ng)%t_west(j,k,itemp) = jgpa1 +                  &
     &               jgpb1*z_r(i,Istr-1,k)
            ELSE IF ( abs(z_r(i,Istr-1,k)) > jgpz2) THEN
              BOUNDARY(ng)%t_west(j,k,itemp) = jgpa3 +                  &
     &               jgpb3*z_r(i,Istr-1,k)
            ELSE
              BOUNDARY(ng)%t_west(j,k,itemp) = jgpa2 -                  &
     &               jgpb2*(-1.0_r8*z_r(i,Istr-1,k))**jgpc2
            END IF

          END DO
        END DO
      END IF

# end BoB section

!! JGP here is the analytic profile for SCS
# elif defined SCS

      jgp1 = 1.52160519944844E-26_r8
      jgp2 = 5.71703684106841E-22_r8
      jgp3 = 8.82493574575604E-18_r8
      jgp4 = 7.23242918941854E-14_r8
      jgp5 = 3.39680915508607E-10_r8
      jgp6 = 9.18735389101207E-07_r8
      jgp7 = 0.00138107909237403E-00_r8
      jgp8 = 1.39148049964568E-00_r8

      IF (ANY(LBC(ieast,isTvar(:),ng)%acquire).and.                     &
     &    DOMAIN(ng)%Eastern_Edge(tile)) THEN
        DO k=1,N(ng)
          DO j=JstrR,JendR

            jgpdum=jgp8   + jgp7*z_r(i,j,k)    + jgp6*z_r(i,j,k)**2
            jgpdum=jgpdum + jgp5*z_r(i,j,k)**3 + jgp4*z_r(i,j,k)**4
            jgpdum=jgpdum + jgp3*z_r(i,j,k)**5 + jgp2*z_r(i,j,k)**6
            jgpdum=jgpdum + jgp1*z_r(i,j,k)**7
            BOUNDARY(ng)%t_east(j,k,itemp) = 10.**jgpdum		

          END DO
        END DO
      END IF

      IF (ANY(LBC(isouth,isTvar(:),ng)%acquire).and.                    &
     &    DOMAIN(ng)%Southern_Edge(tile)) THEN
        DO k=1,N(ng)
          DO i=IstrR,IendR

            jgpdum=jgp8   + jgp7*z_r(i,j,k)    + jgp6*z_r(i,j,k)**2
            jgpdum=jgpdum + jgp5*z_r(i,j,k)**3 + jgp4*z_r(i,j,k)**4
            jgpdum=jgpdum + jgp3*z_r(i,j,k)**5 + jgp2*z_r(i,j,k)**6
            jgpdum=jgpdum + jgp1*z_r(i,j,k)**7
            BOUNDARY(ng)%t_south(j,k,itemp) = 10.**jgpdum

          END DO
        END DO
      END IF

      IF (ANY(LBC(inorth,isTvar(:),ng)%acquire).and.                    &
     &    DOMAIN(ng)%Northern_Edge(tile)) THEN
        DO k=1,N(ng)
          DO i=IstrR,IendR

            jgpdum=jgp8   + jgp7*z_r(i,j,k)    + jgp6*z_r(i,j,k)**2
            jgpdum=jgpdum + jgp5*z_r(i,j,k)**3 + jgp4*z_r(i,j,k)**4
            jgpdum=jgpdum + jgp3*z_r(i,j,k)**5 + jgp2*z_r(i,j,k)**6
            jgpdum=jgpdum + jgp1*z_r(i,j,k)**7
            BOUNDARY(ng)%t_north(j,k,itemp) = 10.**jgpdum

          END DO
        END DO
      END IF


      IF (ANY(LBC(iwest,isTvar(:),ng)%acquire).and.                     &
     &    DOMAIN(ng)%Western_Edge(tile)) THEN
        DO k=1,N(ng)
          DO j=JstrR,JendR

            jgpdum=jgp8   + jgp7*z_r(i,j,k)    + jgp6*z_r(i,j,k)**2
            jgpdum=jgpdum + jgp5*z_r(i,j,k)**3 + jgp4*z_r(i,j,k)**4
            jgpdum=jgpdum + jgp3*z_r(i,j,k)**5 + jgp2*z_r(i,j,k)**6
            jgpdum=jgpdum + jgp1*z_r(i,j,k)**7
            BOUNDARY(ng)%t_west(j,k,itemp) = 10.**jgpdum

          END DO
        END DO
      END IF

! end SCS section






#else
      IF (ANY(LBC(ieast,isTvar(:),ng)%acquire).and.                     &
     &    DOMAIN(ng)%Eastern_Edge(tile)) THEN
        DO itrc=1,NT(ng)
          DO k=1,N(ng)
            DO j=JstrR,JendR
              BOUNDARY(ng)%t_east(j,k,itrc)=0.0_r8
            END DO
          END DO
        END DO
      END IF

      IF (ANY(LBC(iwest,isTvar(:),ng)%acquire).and.                     &
     &    DOMAIN(ng)%Western_Edge(tile)) THEN
        DO itrc=1,NT(ng)
          DO k=1,N(ng)
            DO j=JstrR,JendR
              BOUNDARY(ng)%t_west(j,k,itrc)=0.0_r8
            END DO
          END DO
        END DO
      END IF

      IF (ANY(LBC(isouth,isTvar(:),ng)%acquire).and.                    &
     &    DOMAIN(ng)%Southern_Edge(tile)) THEN
        DO itrc=1,NT(ng)
          DO k=1,N(ng)
            DO i=IstrR,IendR
              BOUNDARY(ng)%t_south(i,k,itrc)=0.0_r8
            END DO
          END DO
        END DO
      END IF

      IF (ANY(LBC(inorth,isTvar(:),ng)%acquire).and.                    &
     &    DOMAIN(ng)%Northern_Edge(tile)) THEN
        DO itrc=1,NT(ng)
          DO k=1,N(ng)
            DO i=IstrR,IendR
              BOUNDARY(ng)%t_north(i,k,itrc)=0.0_r8
            END DO
          END DO
        END DO
      END IF
#endif

      RETURN
      END SUBROUTINE ana_tobc_tile
