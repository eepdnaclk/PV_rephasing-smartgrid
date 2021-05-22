% Author: Chaminda Bandara
% Modified MSFLA Algorithm
% Date: 19th-January-2020

function b = IsInRange(x, VarMin, VarMax)

    b = all(x>=VarMin) && all(x<=VarMax);

end