# deep lists ul

    Code
      for (i in 1:4) test_ul(i)
    Message <cliMessage>
      * Level 1
      * Level 1
        ( ) Level 2
      * Level 1
        ( ) Level 2
          - Level 3
      * Level 1
        ( ) Level 2
          - Level 3
            - Level 4

# deep lists ol

    Code
      for (i in 1:4) test_ol(i)
    Message <cliMessage>
      1. Level 1
      1. Level 1
        1. Level 2
      1. Level 1
        1. Level 2
          1. Level 3
      1. Level 1
        1. Level 2
          1. Level 3
            1. Level 4

# deep lists ol ul

    Code
      for (i in 1:4) test_ol_ul(i)
    Message <cliMessage>
      1. Level 1
        * Level 2
      1. Level 1
        * Level 2
          1. Level 3
            ( ) Level 4
      1. Level 1
        * Level 2
          1. Level 3
            ( ) Level 4
              1. Level 5
                - Level 6
      1. Level 1
        * Level 2
          1. Level 3
            ( ) Level 4
              1. Level 5
                - Level 6
                  1. Level 7
                    - Level 8

# deep lists ul ol

    Code
      for (i in 1:4) test_ul_ol(i)
    Message <cliMessage>
      * Level 1
        1. Level 2
      * Level 1
        1. Level 2
          ( ) Level 3
            1. Level 4
      * Level 1
        1. Level 2
          ( ) Level 3
            1. Level 4
              - Level 5
                1. Level 6
      * Level 1
        1. Level 2
          ( ) Level 3
            1. Level 4
              - Level 5
                1. Level 6
                  - Level 7
                    1. Level 8

