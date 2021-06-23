# cli_progress_demo

    Code
      out
    Output
      \ 50 done (100/s) | 3ms[K

---

    Code
      out
    Output
      ==========>--------------------   33% | ETA:  1s[K
      ====================>----------   67% | ETA:  1s[K
      [K

---

    Code
      out
    Output
      \ 1 done (100/s) | 3ms[K
      | 2 done (100/s) | 3ms[K
      / 3 done (100/s) | 3ms[K
      - 4 done (100/s) | 3ms[K
      \ 5 done (100/s) | 3ms[K
      [K

---

    Code
      out
    Output
      ==========>--------------------   33% | ETA: 10s[K
      ====================>----------   67% | ETA:  3s[K
      [K

---

    Code
      msgs
    Output
      [1] "\r==========>--------------------   33% | ETA: 10s\033[K\r"
      [2] "\r====================>----------   67% | ETA:  3s\033[K\r"
      [3] "\r\033[K"                                                  

# pb_bar

    Code
      cli_text("-{cli::pb_bar}-")
    Message <cliMessage>
      --

---

    Code
      cli_text("-{cli::pb_bar}-")
    Message <cliMessage>
      -===============>--------------- -

# pb_current_bytes

    Code
      cli__pb_current_bytes(list(current = 0))
    Output
      [1] "0.0 kB"
    Code
      cli__pb_current_bytes(list(current = 1))
    Output
      [1] "0.0 kB"
    Code
      cli__pb_current_bytes(list(current = 1000))
    Output
      [1] "1.0 kB"
    Code
      cli__pb_current_bytes(list(current = 1000 * 23))
    Output
      [1] " 23 kB"
    Code
      cli__pb_current_bytes(list(current = 1000 * 1000 * 23))
    Output
      [1] " 23 MB"

# pb_elapsed

    Code
      cli__pb_elapsed()
    Output
      [1] "1s"

---

    Code
      cli__pb_elapsed()
    Output
      [1] "21s"

---

    Code
      cli__pb_elapsed()
    Output
      [1] "58s"

---

    Code
      cli__pb_elapsed()
    Output
      [1] "1h 5m"

# pb_elapsed_clock

    Code
      cli__pb_elapsed_clock()
    Output
      [1] "00:00:01"

---

    Code
      cli__pb_elapsed_clock()
    Output
      [1] "00:00:21"

---

    Code
      cli__pb_elapsed_clock()
    Output
      [1] "00:00:58"

---

    Code
      cli__pb_elapsed_clock()
    Output
      [1] "01:05:00"

# pb_elapsed_raw

    Code
      cli__pb_elapsed_raw()
    Output
      [1] 1

---

    Code
      cli__pb_elapsed_raw()
    Output
      [1] 21

---

    Code
      cli__pb_elapsed_raw()
    Output
      [1] 58

---

    Code
      cli__pb_elapsed_raw()
    Output
      [1] 3900

# pb_eta

    Code
      cli__pb_eta(list())
    Output
      [1] "?"

---

    Code
      cli__pb_eta(list())
    Output
      [1] "12s"

# pb_eta_raw

    Code
      cli__pb_eta_raw()
    Output
      [1] NA

---

    Code
      cli__pb_eta_raw()
    Output
      Time difference of 40 secs

---

    Code
      cli__pb_eta_raw()
    Output
      Time difference of 10 secs

---

    Code
      cli__pb_eta_raw()
    Output
      Time difference of 0 secs

# pb_eta_str

    Code
      cli__pb_eta_str(list())
    Output
      [1] ""

---

    Code
      cli__pb_eta_str(list())
    Output
      [1] "ETA:  1s"

# pb_percent

    Code
      cli__pb_percent(list(current = 0, total = 99))
    Output
      [1] "  0%"
    Code
      cli__pb_percent(list(current = 5, total = 99))
    Output
      [1] "  5%"
    Code
      cli__pb_percent(list(current = 10, total = 99))
    Output
      [1] " 10%"
    Code
      cli__pb_percent(list(current = 25, total = 99))
    Output
      [1] " 25%"
    Code
      cli__pb_percent(list(current = 99, total = 99))
    Output
      [1] "100%"
    Code
      cli__pb_percent(list(current = 100, total = 99))
    Output
      [1] "101%"

# pb_rate

    Code
      cli__pb_rate(list())
    Output
      [1] "?/s"

---

    Code
      cli__pb_rate(list())
    Output
      [1] "?/s"

---

    Code
      cli__pb_rate(list())
    Output
      [1] "0.1/s"

---

    Code
      cli__pb_rate(list())
    Output
      [1] "12/s"

# pb_rate_bytes

    Code
      cli__pb_rate_bytes(list())
    Output
      [1] "NaN kB/s"

---

    Code
      cli__pb_rate_bytes(list())
    Output
      [1] "Inf YB/s"

---

    Code
      cli__pb_rate_bytes(list())
    Output
      [1] "0.0 kB/s"

---

    Code
      cli__pb_rate_bytes(list())
    Output
      [1] "1.0 kB/s"

---

    Code
      cli__pb_rate_bytes(list())
    Output
      [1] " 24 kB/s"

---

    Code
      cli__pb_rate_bytes(list())
    Output
      [1] " 24 MB/s"

# pb_spin

    Code
      cli_text("-{cli::pb_spin}-{cli::pb_spin}-")
    Message <cliMessage>
      -\-\-

---

    Code
      cli_text("-{cli::pb_spin}-{cli::pb_spin}-")
    Message <cliMessage>
      -|-|-

---

    Code
      cli_text("-{cli::pb_spin}-{cli::pb_spin}-")
    Message <cliMessage>
      -|-|-

# pb_timestamp

    Code
      cli__pb_timestamp(list())
    Output
      [1] "2021-06-18T00:09:14+00:00"

---

    Code
      cli__pb_timestamp(list())
    Output
      [1] "2021-06-18T00:09:34+00:00"

# pb_total_bytes

    Code
      cli__pb_total_bytes(list(total = 0))
    Output
      [1] "0.0 kB"
    Code
      cli__pb_total_bytes(list(total = 1))
    Output
      [1] "0.0 kB"
    Code
      cli__pb_total_bytes(list(total = 1000))
    Output
      [1] "1.0 kB"
    Code
      cli__pb_total_bytes(list(total = 1000 * 23))
    Output
      [1] " 23 kB"
    Code
      cli__pb_total_bytes(list(total = 1000 * 1000 * 23))
    Output
      [1] " 23 MB"

