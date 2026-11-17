require_relative "code-gen"

apts = RunSteps.flat_map {|s| s.apt }
other_packages = %w(libpng-dev libgd-dev libfl-dev groff flex bison curl)

apts = [*apts.flatten.compact.uniq, *other_packages].uniq.sort

dockerfile = []
dockerfile << "FROM ubuntu:#{ `bash -c 'source /etc/os-release && echo $VERSION_ID'`.chomp }"
dockerfile << "ENV DEBIAN_FRONTEND noninteractive"
dockerfile << "RUN apt-get update && apt-get upgrade -y"
dockerfile << "RUN apt-get -qq install -y apt-utils > /dev/null"
dockerfile << "RUN apt-get -qq install -y moreutils"
apts.each_slice(4) do |apt|
  dockerfile << "RUN chronic apt-get -qq install -y #{ apt.join(" ") } && chronic apt-get clean"
end
# languages added past 138 that have no Ubuntu package
dockerfile << "RUN chronic apt-get -qq install -y python3-pip golang-go cargo && chronic apt-get clean"
dockerfile << "RUN pip install --break-system-packages --ignore-installed coconut==3.2.0"
dockerfile << "RUN GOBIN=/usr/local/bin go install github.com/d5/tengo/v2/cmd/tengo@v2.17.0 && GOBIN=/usr/local/bin go install github.com/mattn/anko@v0.1.15"
dockerfile << "RUN cargo install --root /usr/local rhai@1.27.0 --features bin-features --bin rhai-run && cargo install --root /usr/local koto_cli@0.16.1"
dockerfile << "ADD . /usr/local/share/quine-relay"
dockerfile << "WORKDIR /usr/local/share/quine-relay"
dockerfile << "RUN make -C vendor"
dockerfile << "CMD make check -j 10000"

File.write("../Dockerfile", dockerfile.join("\n") + "\n")
