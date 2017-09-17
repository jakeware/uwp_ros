function bcoords = getBaryCoords(test_xyz,test_tet_xyz)
  % build base matrix with last col of ones
  D = ones(4,4);
  D(1:4,1:3) = test_tet_xyz;

  % get base determinant
  d_base = 1/6*det(D);

  % get determinants of matrix with test point in each row
  d = zeros(1,4);
  for j=1:4
    Dp = D;
    Dp(j,1:3) = test_xyz;
    d(j) = 1/6*det(Dp);
  end

  % normalize by first determinant to get barycentric coordinates
  bcoords = d/d_base;
end