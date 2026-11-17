FROM ubuntu:26.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get upgrade -y
RUN apt-get -qq install -y apt-utils > /dev/null
RUN apt-get -qq install -y moreutils
RUN chronic apt-get -qq install -y afnix algol68g aspectj asymptote && chronic apt-get clean
RUN chronic apt-get -qq install -y ats2-lang basex bash bc && chronic apt-get clean
RUN chronic apt-get -qq install -y bison bsh bwbasic chuck && chronic apt-get clean
RUN chronic apt-get -qq install -y clisp clojure cmake coffeescript && chronic apt-get clean
RUN chronic apt-get -qq install -y crystal curl dash dc && chronic apt-get clean
RUN chronic apt-get -qq install -y dhall dotnet-sdk-10.0 elixir elvish && chronic apt-get clean
RUN chronic apt-get -qq install -y emacs-nox erlang execline f2c && chronic apt-get clean
RUN chronic apt-get -qq install -y fennel fish flex fp-compiler && chronic apt-get clean
RUN chronic apt-get -qq install -y g++ gambas3-gb-pcre gambas3-scripter gap && chronic apt-get clean
RUN chronic apt-get -qq install -y gawk gcc gdb gdc && chronic apt-get clean
RUN chronic apt-get -qq install -y genius gforth gfortran ghc && chronic apt-get clean
RUN chronic apt-get -qq install -y ghdl ghostscript gm2 gnat && chronic apt-get clean
RUN chronic apt-get -qq install -y gnucobol4 gnuplot gobjc golang && chronic apt-get clean
RUN chronic apt-get -qq install -y gpt groff groovy guile-3.0 && chronic apt-get clean
RUN chronic apt-get -qq install -y gzip haxe hy icont && chronic apt-get clean
RUN chronic apt-get -qq install -y iconx intercal iverilog jasmin-sable && chronic apt-get clean
RUN chronic apt-get -qq install -y jq jsonnet kotlin ksh && chronic apt-get clean
RUN chronic apt-get -qq install -y libevent-dev libfl-dev libgd-dev libpng-dev && chronic apt-get clean
RUN chronic apt-get -qq install -y libpolyml-dev livescript llvm lua5.3 && chronic apt-get clean
RUN chronic apt-get -qq install -y m4 make minizinc mksh && chronic apt-get clean
RUN chronic apt-get -qq install -y mono-devel nasm neko newlisp && chronic apt-get clean
RUN chronic apt-get -qq install -y nickle nim node-typescript nodejs && chronic apt-get clean
RUN chronic apt-get -qq install -y nqp ocaml octave openjdk-25-jdk && chronic apt-get clean
RUN chronic apt-get -qq install -y pari-gp parser3-cgi perl php-cli && chronic apt-get clean
RUN chronic apt-get -qq install -y picolisp pike8.0 polyml python3 && chronic apt-get clean
RUN chronic apt-get -qq install -y r-base racket rakudo ratfor && chronic apt-get clean
RUN chronic apt-get -qq install -y rc regina-rexx ruby ruby-mustache && chronic apt-get clean
RUN chronic apt-get -qq install -y rustc scala scilab-cli sed && chronic apt-get clean
RUN chronic apt-get -qq install -y slsh spin sqlite3 squirrel3 && chronic apt-get clean
RUN chronic apt-get -qq install -y surgescript swi-prolog swiftlang tcl && chronic apt-get clean
RUN chronic apt-get -qq install -y tcsh valac vim wabt && chronic apt-get clean
RUN chronic apt-get -qq install -y xonsh xsltproc yabasic yash && chronic apt-get clean
RUN chronic apt-get -qq install -y yorick zoem zsh && chronic apt-get clean
RUN chronic apt-get -qq install -y python3-pip golang-go cargo && chronic apt-get clean
RUN pip install --break-system-packages --ignore-installed coconut==3.2.0
RUN GOBIN=/usr/local/bin go install github.com/d5/tengo/v2/cmd/tengo@v2.17.0 && GOBIN=/usr/local/bin go install github.com/mattn/anko@v0.1.15
RUN cargo install --root /usr/local rhai@1.27.0 --features bin-features --bin rhai-run && cargo install --root /usr/local koto_cli@0.16.1
ADD . /usr/local/share/quine-relay
WORKDIR /usr/local/share/quine-relay
RUN make -C vendor
CMD make check -j 10000
