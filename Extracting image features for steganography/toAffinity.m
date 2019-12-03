function A = toAffinity(f)
% --------------------------------------------------------------------
  switch size(f,1)
    case 3 % discs
      T = f(1:2) ;
      s = f(3) ;
      th = 0 ;
      A = [s*[cos(th) -sin(th) ; sin(th) cos(th)], T ; 0 0 1] ;
    case 4 % oriented discs
      T = f(1:2) ;
      s = f(3) ;
      th = f(4) ;
      A = [s*[cos(th) -sin(th) ; sin(th) cos(th)], T ; 0 0 1] ;
    case 5 % ellipses
      T = f(1:2) ;
      A = [mapFromS(f(3:5)), T ; 0 0 1] ;
    case 6 % oriented ellipses
      T = f(1:2) ;
      A = [f(3:4), f(5:6), T ; 0 0 1] ;
    otherwise
      assert(false) ;
  end
end