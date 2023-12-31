module DX7
  module Algorithms
    ART = [    
      [ # 1
        '      6 >',
        '      |',
        '      5',
        '      |',
        '  2   4',
        '  |   |',
        '  1 - 3'
      ],
      [ # 2
        '      6',
        '      |',
        '      5',
        '      |',
        '< 2   4',
        '  |   |',
        '  1 - 3'
      ],
      [ # 3
        '      ',
        '      ',
        '  3   6 >',
        '  |   |',
        '  2   5',
        '  |   |',
        '  1 - 4'
      ],
      [ # 4
        '      ',
        '      ',
        '  3   6 >',
        '  |   | .',
        '  2   5 .',
        '  |   | .',
        '  1 - 4 >'
      ],
      [ # 5
        '      ',
        '      ',
        '     ',
        '     ',
        '  2   4   6 >',
        '  |   |   |',
        '  1 - 3 - 5'
      ],
      [ # 6
        '      ',
        '      ',
        '     ',
        '     ',
        '  2   4   6 >',
        '  |   |   | .',
        '  1 - 3 - 5 >'
      ],
      [ # 7
        '      ',
        '      ',
        '           6 >',
        '           |  ',
        '  2    4   5  ',
        '  |    |  / ',
        '  1 -- 3 '
      ],
      [ # 8
        '      ',
        '      ',
        '           6 ',
        '           |  ',
        '  2  < 4   5  ',
        '  |    |  / ',
        '  1 -- 3 '
      ],
      [ # 9
        '      ',
        '      ',
        '           6 ',
        '           |  ',
        '< 2    4   5  ',
        '  |    |  / ',
        '  1 -- 3 '
      ],
      [ # 10
        '      ',
        '      ',
        '          3 > ',
        '          |  ',
        '  5  6    2     ',
        '   \ |    |   ',
        '     4 -- 1 '
      ],
      [ # 11
        '      ',
        '      ',
        '          3 ',
        '          |  ',
        '  5  6 >  2     ',
        '   \ |    |   ',
        '     4 -- 1 '
      ],
      [ # 12
        '      ',
        '      ',
        '           ',
        '             ',
        '  4  5  6    2 >    ',
        '   \ | /     |   ',
        '     3 ----- 1 '
      ],
      [ # 13
        '      ',
        '      ',
        '           ',
        '             ',
        '  4  5  6 >  2    ',
        '   \ | /     |   ',
        '     3 ----_ 1 '
      ],
      [ # 14
        '      ',
        '      ',
        '      5  6 >',
        '      | /',
        '  2   4 ',
        '  |   | ',
        '  1 - 3 '
      ],
      [ # 15
        '      ',
        '      ',
        '      5  6 ',
        '      | /',
        '< 2   4 ',
        '  |   | ',
        '  1 - 3 '
      ],
      [ # 16
        '      ',
        '      ',
        '       4    6 >',
        '       |    |',
        '  2    3    5 ',
        '    \  |  / ',
        '       1  '
      ],
      [ # 17
        '      ',
        '      ',
        '       4    6 ',
        '       |    |',
        '< 2    3    5 ',
        '    \  |  / ',
        '       1  '
      ],
      [ # 18
        '            6',
        '            |',
        '            5 ',
        '            |',
        '  2  < 3    4 ',
        '    \  |  / ',
        '       1  '
      ],
      [ # 19
        '           ',
        '            ',
        '  3          ',
        '  |         ',
        '  2  < 6     ',
        '  |    |  \ ',
        '  1 -- 4 -- 5 '
      ],
      [ # 20
        '           ',
        '            ',
        '            ',
        '           ',
        '< 3    5    6 ',
        '  |  \   \  |',
        '  1 -- 2 -- 4 '
      ],
      [ # 21
        '           ',
        '            ',
        '            ',
        '           ',
        '< 3         6    ',
        '  |  \      |  \  ',
        '  1 -- 2 -- 4 -- 5 '
      ],
      [ # 22
        '           ',
        '            ',
        '            ',
        '           ',
        '  2         6 >   ',
        '  |      /  |  \  ',
        '  1 -- 3 -- 4 -- 5 '
      ],
      [ # 23
        '           ',
        '            ',
        '            ',
        '           ',
        '       3    6 >   ',
        '       |    |  \  ',
        '  1 -- 2 -- 4 -- 5 '
      ],
      [ # 24
        '           ',
        '            ',
        '            ',
        '           ',
        '                 6 >',
        '              /  |  \ ',
        '  1 -- 2 -- 3 -- 4 -- 5 '
      ],
      [ # 25
        '           ',
        '            ',
        '            ',
        '           ',
        '                 6 >',
        '                 |  \ ',
        '  1 -- 2 -- 3 -- 4 -- 5 '
      ],
      [ # 26
        '           ',
        '            ',
        '            ',
        '           ',
        '       3    5    6 >',
        '       |      \  |  ',
        '  1 -- 2 ------- 4  '
      ],
      [ # 27
        '           ',
        '            ',
        '            ',
        '           ',
        '     < 3    5    6 ',
        '       |      \  |  ',
        '  1 -- 2 ------- 4  '
      ],
      [ # 28
        '           ',
        '            ',
        '       5 >     ',
        '       |    ',
        '  2    4     ',
        '  |    |   ',
        '  1 -- 3 -- 6 '
      ],
      [ # 29
        '           ',
        '            ',
        '            ',
        '           ',
        '            4    6 >   ',
        '            |    |  ',
        '  1 -- 2 -- 3 -- 5 '
      ],
      [ # 30
        '           ',
        '            ',
        '            5 > ',
        '            |',
        '            4       ',
        '            |      ',
        '  1 -- 2 -- 3 -- 6 '
      ],
      [ # 31
        '           ',
        '            ',
        '            ',
        '           ',
        '                      6 >',
        '                      |  ',
        '  1 -- 2 -- 3 -- 4 -- 5 '
      ],
      [ # 32
        '           ',
        '            ',
        '            ',
        '           ',
        '                      ',
        '                        ',
        '  1 -- 2 -- 3 -- 4 -- 5 -- 6 >'
      ],
   ]
  end
end
