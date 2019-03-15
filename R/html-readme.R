
knit_print.html <- function(x, zoom = 2, ...) {
  x <- paste(x, collapse = "\n")
  html <- html_page(fansi::sgr_to_html(x))
  html_file <- tempfile(fileext = ".html")
  on.exit(unlink(html_file), add = TRUE)
  image_file <- tempfile(fileext = ".png")
  font_file <- file.path(tempdir(), "Menlo-Regular.ttf")
  on.exit(unlink(image_file), add = TRUE)
  cat(html, file = html_file)
  if (!file.exists(font_file)) {
    download.file(
      "https://cdn.jsdelivr.net/gh/r-lib/cli@master/tools/Menlo-Regular.ttf",
      font_file)
  }
  webshot::webshot(html_file, image_file, selector = "#content",
                   zoom = zoom)
  img <- readBin(image_file, "raw", file.info(image_file)[, "size"])
  structure(
    list(image = img, extension = ".png", url = NULL),
    class = "html_screenshot"
  )
}

html_page <- function(content) {
  html <- paste0(
    '<html>
       <head>
         <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
         <style type="text/css">
          @font-face {
             font-family: "Menlo";
             src: url("Menlo-Regular.ttf") format("truetype");
          }
          pre {
            font-family: Menlo
          }
         </style>
       </head>
       <body>
         <pre id="content">\n',
    content, '
         </pre>
       </body>
       </html>'
  )

  structure(html, class = "html")
}
