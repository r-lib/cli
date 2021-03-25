# spark_bar [plain]

    Code
      spark_bar(seq(0, 1, length = 8))
    Output
      [1] "__,,**##"
      attr(,"class")
      [1] "cli_spark_bar" "cli_spark"    
    Code
      spark_bar(c(0, NA, 0.5, NA, 1))
    Output
      [1] "_ , #"
      attr(,"class")
      [1] "cli_spark_bar" "cli_spark"    

# spark_bar [unicode]

    Code
      spark_bar(seq(0, 1, length = 8))
    Output
      [1] "▁▂▃▄▅▆▇█"
      attr(,"class")
      [1] "cli_spark_bar" "cli_spark"    
    Code
      spark_bar(c(0, NA, 0.5, NA, 1))
    Output
      [1] "▁ ▄ █"
      attr(,"class")
      [1] "cli_spark_bar" "cli_spark"    

# spark_line [plain]

    Code
      spark_line(seq(0, 1, length = 10))
    Output
      [1] "_,,-^"
      attr(,"class")
      [1] "cli_spark_line" "cli_spark"     

# spark_line [unicode]

    Code
      spark_line(seq(0, 1, length = 10))
    Output
      [1] "⣀⡠⠔⠊⠉"
      attr(,"class")
      [1] "cli_spark_line" "cli_spark"     

