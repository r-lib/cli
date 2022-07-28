

HTMLWidgets.widget({

  name: 'asciinema_player',

  type: 'output',

    factory: function(el, width, height) {

      function guidGenerator() {
        var S4 = function() {
          return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
        };
          return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4());
      }

      var $player;
      var $id = guidGenerator();

      return {

      renderValue: function(x) {
        $(el).empty();

        $player = $("<asciinema-player src='"+ x.src +"' />");
        $player.attr("cols", x.cols);
        $player.attr("rows", x.rows);
        if (x.autoplay) { $player.attr("autoplay", true); }
        if (x.loop) { $player.attr("loop", true); }
        $player.attr("start-at", x.start_at);
        $player.attr("speed", x.speed);
        $player.attr("poster", x.poster);
        $player.attr("font-size", x.font_size);
        $player.attr("theme", x.theme);
        $player.attr("id", $id);

        if (x.title !== "") $player.attr("title", x.title);
        if (x.author !== "") $player.attr("author", x.author);
        if (x.author_url !== "") $player.attr("author-url", x.author_url);
        if (x.author_img_url !== "") $player.attr("author-img-url", x.author_img_url);

        $(el).append($player);

        var term = $($player).find(".asciinema-terminal")[0];
        term.style.height = Number(x.rows) + 3 + "ch";
        term.style.width = x.cols + "ch";
      },

      resize: function(width, height) {}
    };
  }
});
