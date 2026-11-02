      Program makeforce
      implicit real*8 (a-h,o-z)
      character line5*5,line74*74,line29*29
      dimension coordxyz(numero,3),coordASEC(999999,3),imov(numero),
     &    iused2(3000),iasecindx(numero),igxyz(numero),igASEC(numero)
      open(1,file='list_tk.dat',status='old')
      open(2,file='coordinates_tk.xyz',status='old')
      open(3,file='new_coordinates_tk.xyz',status='unknown')
      open(4,file='ASEC_tk.xyz',status='old')
      open(5,file='equals',status='unknown')

CCCCCCCCCCCCCCCC
C     This program gives you the final xyz coordinates including the ASEC 
C     point charges (new_coordinates_tk.xyz)
C
C     icont: number of atoms which are moving along the molecular dynamics
C     numcharges: number of charges on the melacu51.prm force field
C     numatoms: number of atoms on the xyz tinker file (includes the link atom)
C     numconf: number of configurations used in the ASEC (-1 because the Best 
C     configuration is already used)
C   
CCCCCCCCCCCCCCCC

      numatoms=numero+1
      numconf=100
      
      read(1,'(17x,I4)')icont
      do i=1,icont
         read(1,'(i4)')imov(i)
      enddo
      read(2,'(A)')
      write(3,'(i6)')numatoms+icont*(numconf-1)

      newindx2=2101
      ii=1
      do i=1,3000
         iused2(i)=0
      enddo
      do i=1,numatoms
         ipresent=0         
         do j=1,icont
            if (i.eq.imov(j)) then
               ipresent=j
            endif
         enddo
         
         if (ipresent.eq.0) then
            read(2,'(i5,1x,A)')nume,line74
            write(3,'(i6,2x,A)')nume,line74
         else
            read(2,'(i5,1x,A,f7.3,5x,f7.3,5x,f7.3,5x,i4,A)')nume,line5,
     &          coordxyz(ii,1),coordxyz(ii,2),coordxyz(ii,3),
     &          indx2,line29
            if (iused2(indx2).eq.0) then
               write(3,'(i6,2x,A,f10.6,2x,f10.6,2x,f10.6,2x,i4,A)')
     &         nume,line5,coordxyz(ii,1),coordxyz(ii,2),coordxyz(ii,3),
     &         newindx2,line29
               iused2(indx2)=newindx2
               iasecindx(ii)=newindx2
               newindx2=newindx2+1
               ii=ii+1
            else
               write(3,'(i6,2x,A,f10.6,2x,f10.6,2x,f10.6,2x,i4,A)')
     &         nume,line5,coordxyz(ii,1),coordxyz(ii,2),coordxyz(ii,3),
     &         iused2(indx2),line29
               iasecindx(ii)=iused2(indx2)
               ii=ii+1
            endif      
         endif
      enddo

      read(4,*)
      read(4,*)
      do i=1,icont*(numconf-1)
            read(4,'(5x,f7.3,5x,f7.3,5x,f7.3)')coordASEC(i,1),
     &                          coordASEC(i,2),coordASEC(i,3)
      enddo

ccc  show the atoms whith equals coordinates 
      write(5,*)'Before'
      numasec=numconf-1
      k=0
      kk=0
      do i=1,icont
        do j=numasec*i-(numasec-1),numasec*i
           if ((coordxyz(i,1).eq.coordASEC(j,1)).and.
     &         (coordxyz(i,2).eq.coordASEC(j,2)).and.
     &         (coordxyz(i,3).eq.coordASEC(j,3))) then
              write(5,*)imov(i),j+numatoms
              k=k+1
              kk=kk+1
              igxyz(k)=i
              igASEC(kk)=j
           endif
        enddo
        do j=numasec*i-(numasec-1),numasec*i-1
           do n=j+1,numasec*i
              if ((coordASEC(j,1).eq.coordASEC(n,1)).and.
     &            (coordASEC(j,2).eq.coordASEC(n,2)).and.
     &            (coordASEC(j,3).eq.coordASEC(n,3))) then
                  write(5,*)j+numatoms,n+numatoms
                  kk=kk+1
                  igASEC(kk)=j
                  kk=kk+1
                  igASEC(kk)=n
              endif
           enddo
        enddo
      enddo

      write(*,*)k,kk

ccccccccccccccccccccccccccccccccccccccc
cccc  some pseudo-atoms have exactly the same coordinates
cccc  and it may bring numerical problems with the SLAPAF.
cccc  For that reason, 0.002 is added to the equals coordinates
ccccccccccccccccccccccccccccccccccccccc
      if (k.eq.1) then
         l=1
      endif
      if (k.gt.1) then
         do i=1,k-1
            do j=i+1,k
               if (igxyz(i).eq.igxyz(j)) then
                   igxyz(j)=0
               endif
            enddo
         enddo
         l=0
         do i=1,k
            if (igxyz(i).ne.0) then
               l=l+1
               igxyz(l)=igxyz(i)
            endif
         enddo 
      endif
      if (kk.eq.1) then
         ll=1
      endif
      if (kk.gt.1) then
         do i=1,kk-1
            do j=i+1,kk
               if (igASEC(i).eq.igASEC(j)) then
                  igASEC(j)=0
               endif
            enddo
         enddo
         ll=0
         do i=1,kk
            if (igASEC(i).ne.0) then
               ll=ll+1
               igASEC(ll)=igASEC(i)
            endif
         enddo
      endif

c  if some atoms of the Best_Conf have exactly the same
c  coordinates than some of the ASEC ones, 0.002 is added to a randon
c  coordinate

      if (k.gt.0) then
       it=1
       ind=0
        do while (it.ne.0)
         it=0
         do i=1,l
          do j=1,ll
c           if (i.ne.j) then
            if ((coordxyz(igxyz(i),1).eq.coordASEC(igASEC(j),1)).and.
     &          (coordxyz(igxyz(i),2).eq.coordASEC(igASEC(j),2)).and.
     &          (coordxyz(igxyz(i),3).eq.coordASEC(igASEC(j),3))) then
                ind=ind+1
                it=it+1
               coordASEC(igASEC(j),ind)=coordASEC(igASEC(j),ind)+0.002
               if (ind.eq.3) then
                  ind=0
               endif 
            endif
c           endif
          enddo
         enddo
        enddo
      endif

c  if some atoms of the ASEC have exactly the same coordinates, 0.002 
c  is added to a random coordinate

      if (kk.gt.0) then
       it=1
       if (k.eq.0) then
          ind=0
       endif
        do while (it.ne.0)
         it=0
         do i=1,ll
          do j=1,ll
           if (i.ne.j) then
            if ((coordASEC(igASEC(i),1).eq.coordASEC(igASEC(j),1)).and.
     &          (coordASEC(igASEC(i),2).eq.coordASEC(igASEC(j),2)).and.
     &          (coordASEC(igASEC(i),3).eq.coordASEC(igASEC(j),3))) then
                ind=ind+1
                it=it+1
               coordASEC(igASEC(i),ind)=coordASEC(igASEC(i),ind)+0.002
               if (ind.eq.3) then
                  ind=0
               endif
            endif
           endif
          enddo
         enddo
        enddo
      endif  

ccccccccccccccccccccccccccc
ccccccccccccccccccccccccccc
ccccccccccccccccccccccccccc


ccc  show the atoms whith equals coordinates 
      write(5,*)'After'
      do i=1,icont
        do j=numasec*i-(numasec-1),numasec*i
           if ((coordxyz(i,1).eq.coordASEC(j,1)).and.
     &         (coordxyz(i,2).eq.coordASEC(j,2)).and.
     &         (coordxyz(i,3).eq.coordASEC(j,3))) then
              write(5,*)imov(i),j+numatoms
           endif
        enddo
        do j=numasec*i-(numasec-1),numasec*i-1
           do n=j+1,numasec*i
              if ((coordASEC(j,1).eq.coordASEC(n,1)).and.
     &            (coordASEC(j,2).eq.coordASEC(n,2)).and.
     &            (coordASEC(j,3).eq.coordASEC(n,3))) then
                  write(5,*)j+numatoms,n+numatoms
              endif
           enddo
        enddo
      enddo


      k=1
      ii=1
      do i=1,icont*(numconf-1)-1
      write(3,'(i6,1x,A2,3x,f7.3,5x,f7.3,5x,f7.3,5x,i4)')numatoms+k,'Xx'
     &,coordASEC(i,1),coordASEC(i,2),coordASEC(i,3),iasecindx(ii)
      k=k+1
      if (mod(i,numconf-1).eq.0) then
          ii=ii+1
      endif
      enddo
      write(3,'(i6,1x,A2,3x,f7.3,5x,f7.3,5x,f7.3,5x,i4)')numatoms+k,'Xx'
     &,coordASEC(icont*(numconf-1),1),coordASEC(icont*(numconf-1),2)
     &,coordASEC(icont*(numconf-1),3),iasecindx(ii)
      end

