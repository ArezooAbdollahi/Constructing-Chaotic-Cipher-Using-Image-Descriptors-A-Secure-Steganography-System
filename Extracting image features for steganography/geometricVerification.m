function [inliers, H] = geometricVerification(f1, f2, matches, varargin)
% GEOMETRICVERIFICATION  Verify feature matches based on geometry
%   OK = GEOMETRICVERIFICATION(F1, F2, MATCHES) check for geometric
%   consistency the matches MATCHES between feature frames F1 and F2
%   (see PLOTMATCHES() for the format). INLIERS is a list of indexes
%   of matches that are inliers to the geometric model.

% Author: Andrea Vedaldi

  opts.tolerance1 =20 ;
  opts.tolerance2 = 15 ;
  opts.tolerance3 = 8;
  opts.minInliers = 6;
  opts.numRefinementIterations = 3 ;
  opts = vl_argparse(opts, varargin) ;

  numMatches = size(matches,2) ;
  inliers = cell(1, numMatches) ;
  H = cell(1, numMatches) ;

  x1 = double(f1(1:2, matches(1,:))) ;
  x2 = double(f2(1:2, matches(2,:))) ;

  x1hom = x1 ;
  x2hom = x2 ;
  x1hom(end+1,:) = 1 ;
  x2hom(end+1,:) = 1 ;

  % bad set of candidate inliers will produce a bad model, but
  % this will be discared
  warning('off','MATLAB:rankDeficientMatrix') ;

  for m = 1:numMatches
    for t = 1:opts.numRefinementIterations
      if t == 1
        A1 = toAffinity(f1(:,matches(1,m))) ;
        A2 = toAffinity(f2(:,matches(2,m))) ;
        H21 = A2 * inv(A1) ;
        x1p = H21(1:2,:) * x1hom ;
        tol = opts.tolerance1 ;
      elseif t <= 4
        % affinity
        H21 = x2(:,inliers{m}) / x1hom(:,inliers{m}) ;
        x1p = H21(1:2,:) * x1hom ;
        H21(3,:) = [0 0 1] ;
        tol = opts.tolerance2 ;
      else
        % homography
        x1in = x1hom(:,inliers{m}) ;
        x2in = x2hom(:,inliers{m}) ;

        % Sanity check
        %H = [.1 0 .4 ; 2 .3 .5 ; .1 .002 1] ;
        %x1in = [randn(2,100) ; ones(1,100)] ;
        %x2in = H*x1in ;
        %x2in = bsxfun(@times, x2in, 1./x2in(3,:)) ;

        S1 = centering(x1in) ;
        S2 = centering(x2in) ;
        x1c = S1 * x1in ;
        x2c = S2 * x2in ;

        M = [x1c, zeros(size(x1c)) ;
             zeros(size(x1c)), x1c ;
             bsxfun(@times, x1c,  -x2c(1,:)), bsxfun(@times, x1c,  -x2c(2,:))] ;
        [H21,D] = svd(M,'econ') ;
        H21 = reshape(H21(:,end),3,3)' ;
        H21 = inv(S2) * H21 * S1 ;
        H21 = H21 ./ H21(end) ;

        x1phom = H21 * x1hom ;
        x1p = [x1phom(1,:) ./ x1phom(3,:) ; x1phom(2,:) ./ x1phom(3,:)] ;
        tol = opts.tolerance3 ;
      end

      dist2 = sum((x2 - x1p).^2,1) ;
      inliers{m} = find(dist2 < tol^2) ;
      H{m} = H21 ;
      if numel(inliers{m}) < opts.minInliers, break ; end
      if numel(inliers{m}) > 0.7 * size(matches,2), break ; end % enough!
    end
  end
  
  %%%%naahiye bandi
    x=f1(1,:);
    y=f1(2,:);
    %c11=histc(x,1:100:max(x));
    c1=sum((histc(x,1:100:max(x))>0));
    c2=sum((histc(y,1:100:max(y))>0));
    
   if (c1<5 && c2<5)
       inliers=[];
       H=[];
    else
        scores = cellfun(@numel, inliers) ;
        [~, best] = max(scores) ;
        inliers = inliers{best} ;
        H = inv(H{best}) ;
    
   % end

end


% --------------------------------------------------------------------


% --------------------------------------------------------------------
