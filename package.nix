{ pkgs ? import <nixpkgs> {}, displayrUtils }:

pkgs.rPackages.buildRPackage {
  name = "cli";
  version = displayrUtils.extractRVersion (builtins.readFile ./DESCRIPTION); 
  src = ./.;
  description = ''A suite of tools to build attractive command line interfaces
  ('CLIs'), from semantic elements: headings, lists, alerts, paragraphs,
  etc. Supports custom themes via a 'CSS'-like language. It also
  contains a number of lower level 'CLI' elements: rules, boxes, trees,
  and 'Unicode' symbols with 'ASCII' alternatives. It support ANSI
  colors and text styles as well.  
'';
}