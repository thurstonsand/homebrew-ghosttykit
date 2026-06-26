class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.2.1-dev-28219445869-3de47cb"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.2.1-dev-28219445869-3de47cb/ghosttykit_0.2.1-dev-28219445869-3de47cb_darwin_arm64.zip"
      sha256 "87db7c820c78a85f941edfe209bb7cdea7ddf20f03120ec22c9287480d6cfac9"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.2.1-dev-28219445869-3de47cb/ghosttykit_0.2.1-dev-28219445869-3de47cb_darwin_amd64.zip"
      sha256 "fbad608f744c986fa50d66a08057ad2a1f54b87b84113389be568fbaa360ea8a"
    end
  end

  conflicts_with "ghosttykit", because: "both install gty and ghosttykitd"

  def install
    bin.install "bin/gty"
    prefix.install "GhosttyKitD.app"
    bin.install_symlink prefix/"GhosttyKitD.app/Contents/MacOS/ghosttykitd" => "ghosttykitd"
  end

  service do
    run [opt_prefix/"GhosttyKitD.app/Contents/MacOS/ghosttykitd"]
    keep_alive true
    working_dir var
    log_path var/"log/ghosttykitd.log"
    error_log_path var/"log/ghosttykitd.log"
  end

  def caveats
    <<~EOS
      This formula tracks nightly builds from GhosttyKit main and may break.

      Start Ghostty, then start the GhosttyKit daemon:

        brew services start #{full_name}

      On first start, macOS should ask for permission to let GhosttyKitD control Ghostty.
      Grant access, then verify the install with:

        gty doctor
    EOS
  end

  test do
    assert_match "gty 0.2.1-dev-28219445869-3de47cb protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.2.1-dev-28219445869-3de47cb", shell_output("#{bin}/ghosttykitd --version")
  end
end
