FROM debian:bookworm-slim


# TeX Liveはミラーによって速度が変わりまくるのでARGでミラーを選択できるように
ARG TEXLIVE_MIRROR=https://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet


# 環境設定変数
ENV LANG=C.UTF-8
ENV PATH="/usr/local/texlive/bin:$PATH"

# インストール用の一時ディレクトリを作成
WORKDIR /tmp_to_install_texlive

# install準備
COPY LaTeX/texlive.profile .

# install TeX Live
    
RUN apt-get update && \
    # wget install
    apt-get install -y wget ca-certificates perl && \
    # ミラーサイトから install-tl-unx.tar.gz をダウンロード、-O は wget がダウンロードしたデータを標準のファイル名ではなく、指定したパス／ファイル名で保存するオプション
    wget ${TEXLIVE_MIRROR}/install-tl-unx.tar.gz && \
    # tar の --strip-components 1 オプションを使って、展開後のディレクトリを切り捨てて、第2階層をフラットに展開
    tar -xf install-tl-unx.tar.gz --strip-components 1 && \
    # TeX Live を指定のインストールプロファイルとミラーサイトで非対話的にインストールする
    ./install-tl -profile texlive.profile --location ${TEXLIVE_MIRROR} && \
    # 長いパス(/usr/local/texlive/*/bin/*)の下にあるツールを、短いパス(t/usr/local/texlive/bin)で使えるようにするリンクを作る
    ln -sf /usr/local/texlive/*/bin/* /usr/local/texlive/bin && \
    # ディレクトリのパーミッションを全ユーザーが読み込み書き込み実行ができるように変更
    chmod -R 777 /usr/local/texlive && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workdir
COPY LaTeX/.latexmkrc ./

# latexmkのインストール
RUN tlmgr install latexmk && \
    # インストール用の一時ディレクトリを削除
    rm -rf /tmp_to_install_texlive && \
    apt-get clean && \
    apt-get autoremove -y