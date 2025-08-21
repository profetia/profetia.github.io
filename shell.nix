{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.ruby
    pkgs.bundler
    pkgs.volta
    pkgs.python2
  ];

  shellHook = ''
    if ! volta list node | grep -q '12'; then
      echo "Installing Node.js 12 via Volta..."
      volta install node@12
    fi

    alias npm="volta run npm"
    alias node="volta run node"

    export PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"

    for gem in jekyll sass bundler jekyll-minifier jekyll-sitemap; do
      if ! gem list -i "$gem" > /dev/null; then
        echo "Installing missing gem: $gem"
        gem install "$gem" --user-install
      fi
    done

    if [ ! -d node_modules ]; then
      echo "Running npm install..."
      npm install
    fi

    echo "✅ Dev shell ready with Ruby, Bundler, Jekyll, Node 12, and npm"
  '';
}
