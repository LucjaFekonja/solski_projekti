% VODLJIOSTNA KANONIČNA OBLIKA
% a = [0 1  ...       ]
%     [  0 1  ...     ]
%     [    ...        ]
%     [       0   1   ]
%     [-a0 ... -a(n-1)]
%
% B = [0 ... 0 1]T
%
% C = [b0 b2 ... b(n-1)] - bn * [a0 a1 ... a(n-1)]
%
% D = bn


% SPOZNAVNOSTNA OBLIKA
%
% A = [- a(n-1) 1 0 ... 0 ]
      [- a(n-2) 0 1 ... 0 ]
      [          ...      ]
      [-a0      0 0 ... 1 ]

% B = [b(n-1) ... b0]T - bn * [a(n-1) ...a0]

%-----------------------------------------------------------------------


% NALOGA: Dan je sistem z dvema chodoma in izhodoma:
%           y_1'' - 2 * y_1' + 3 (y_1 - y_2) = u_1 - 2 * u_2'
%           y_2' + 2 * (y_2 - y_1) = u_2 - u_1'
%         Izberite spremenljivke stanja in zapišite v prostoru stanj

% IDEJA: Vpelji tri (y_1'', y_1'. y_2') parametre -> 3x3 sistem

% REŠITEV:
%   y_1'' = 2 * y_1' - 2 * u_2' - 3 (y_1 - y_2) + u_1
%   y_2' + u_1' = - 2 * (y_2 - y_1) + u_2
%   
%   Dvakrat integriraj:
%   y_1 = integral(2 * y_1 - 2 * u_2 + integriral(- 3 (y_1 - y_2) + u_1)dt )dt
%   y_2 + u_1 = integral(- 2 * (y_2 - y_1) + u_2)dt
%
%   Označimo
%   x1 = integral(2 * y_1 - 2 * u_2 + integriral(- 3 (y_1 - y_2) + u_1)dt )dt
%   x2 = integriral(- 3 (y_1 - y_2) + u_1)dt
%   x3 = integral(- 2 * (y_2 - y_1) + u_2)dt
%
%   x1 = integral( 2*y1 - 2+u2 + x2 )dt
%   x2 = integral( u1 - 3*(y1 - y2) )dt
%   x3 = integral( u2 - 2*(y2 - y1) )dt
%
%   -> y1 = x1
%   -> y2 = x3 - u1
%
%   Odvajaj:
%   x1' = 2*y1 - 2*u2 + x2 = 2*x1 - 2*u2 + x2
%   x2' = u1 - 3*(y1 - y2) = u1 - 3*x1 - 3*u1 + 3*x3
%   x3' = u2 - 2*(y2 - y1) = u2 + 2*u1 - 2*x3 + 2*x1
%
%   x' = [2  1  0] * x + [ 0 -2]  * u
         [-3 0  3]       [-2  0]
         [2  0 -2]       [ 2  1]

%   y = [1 0 0] * x + [0  0] * u
        [0 0 1]       [-1 0]




