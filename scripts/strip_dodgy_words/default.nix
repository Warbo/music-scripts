{ bash, replace, wrap }:

wrap {
  name = "strip_dodgy_words";
  paths = [ bash replace ];
  file = ../raw/strip_dodgy_words.sh;
}
