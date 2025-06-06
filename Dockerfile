FROM debian:bookworm-slim


# ---------------------------下記の設定は変更可能---------------------------


# TeX Liveはミラーによって速度が変わりまくるのでARGでミラーを選択できるように
ARG TEXLIVE_MIRROR=https://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet


# ---------------------------下記の設定は変更しないでください---------------------------
# 環境設定変数
ENV LANG=C.UTF-8
ENV PATH="/usr/local/texlive/bin:$PATH"
# set non-root user
ARG USERNAME=C_language_Docker
# set user ID and group ID 
ARG USER_UID=6012368412510096
ARG USER_GID=$USER_UID

# インストール用の一時ディレクトリを作成
WORKDIR /tmp_to_install_texlive

# texlive.profileをカレントディレクトリ(.)にコピー
COPY 7_TeX_Codes/texlive.profile .

# install TeX Live
    
RUN apt-get update && \
    # wget install
    apt-get install -y wget ca-certificates perl &&\
    # ミラーサイトから install-tl-unx.tar.gz をダウンロード
    wget ${TEXLIVE_MIRROR}/install-tl-unx.tar.gz &&\
    # tar の --strip-components 1 オプションを使って、展開後のディレクトリを切り捨てて、第2階層をフラットに展開
    tar -xf install-tl-unx.tar.gz --strip-components 1 &&\
    # TeX Live を指定のインストールプロファイルとミラーサイトで非対話的にインストールする
    ./install-tl -profile texlive.profile --location ${TEXLIVE_MIRROR} &&\
    # 長いパス(/usr/local/texlive/*/bin/*)の下にあるツールを、短いパス(t/usr/local/texlive/bin)で使えるようにするリンクを作る
    ln -sf /usr/local/texlive/*/bin/* /usr/local/texlive/bin &&\
    rm -rf /var/lib/apt/lists/*

WORKDIR /workdir
COPY 7_TeX_Codes/.latexmkrc ./

# latexmkのインストール
RUN tlmgr install latexmk &&\
    # create user and group
    groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/bash &&\   
    # インストール用の一時ディレクトリを削除
    rm -rf /tmp_to_install_texlive &&\
    apt-get clean &&\
    apt-get autoremove -y

# set user
USER $USERNAME