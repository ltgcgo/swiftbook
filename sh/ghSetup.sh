#!/bin/bash
curl -Lo mdbook.tgz https://github.com/rust-lang/mdBook/releases/download/v0.4.43/mdbook-v0.4.43-x86_64-unknown-linux-musl.tar.gz && tar zxvf mdbook.tgz && sudo mv mdbook /bin && rm mdbook.tgz
sudo apt install -y zopfli tree
exit