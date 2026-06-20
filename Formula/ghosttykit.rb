class Ghosttykit < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.2.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.2.1/ghosttykit_0.2.1_darwin_arm64.zip"
      sha256 "f928cf66ba32a1f8dfde2b75598f1d5b404496596fa23e810e1b8c61bc470ee2"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.2.1/ghosttykit_0.2.1_darwin_amd64.zip"
      sha256 "ffc98819df2579ae7849c18125c80e08a2d638fe0a948a112ab37f35591c2e7f"
    end
  end

  conflicts_with "ghosttykit-nightly", because: "both install gty and ghosttykitd"

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


      Start Ghostty, then start the GhosttyKit daemon:

        brew services start #{full_name}

      On first start, macOS should ask for permission to let GhosttyKitD control Ghostty.
      Grant access, then verify the install with:

        gty doctor
    EOS
  end

  test do
    assert_match "gty 0.2.1 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.2.1", shell_output("#{bin}/ghosttykitd --version")
  end
end
