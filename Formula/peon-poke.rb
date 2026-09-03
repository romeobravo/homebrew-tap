class PeonPoke < Formula
  desc "Trackpad haptic notifications on Mac for when your AI coding agent needs you"
  homepage "https://github.com/romeobravo/peon-poke"
  url "https://github.com/romeobravo/peon-poke/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "fdb8a5bb80dd8b4a7ac8db30a8555518ecb9cfa971392498ddee0187aa609830"
  license "MIT"

  depends_on :macos

  def install
    system "make", "CC=#{ENV.cc}"
    libexec.install "poke.sh", "peon-poke-setup", "uninstall.sh", "config.json"
    libexec.install "adapters", "plugins", "bin"
    chmod 0755, libexec/"peon-poke-setup"
    bin.install_symlink libexec/"bin/poke" => "poke"
    (bin/"peon-poke-setup").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/peon-poke-setup" "$@"
    EOS
    chmod 0755, bin/"peon-poke-setup"
  end

  def caveats
    <<~EOS
      Run `peon-poke-setup` to register hooks for detected agents
      (Claude Code, Codex, pi, oh-my-pi). Runtime installs to ~/.peon-poke
      so hook registrations survive upgrades.
    EOS
  end

  test do
    assert_match "names:", shell_output("#{bin}/poke definitely-not-a-pattern 2>&1")
  end
end
