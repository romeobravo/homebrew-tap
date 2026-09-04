class PeonPoke < Formula
  desc "Trackpad haptic notifications on Mac for when your AI coding agent needs you"
  homepage "https://github.com/romeobravo/peon-poke"
  url "https://github.com/romeobravo/peon-poke/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "8069d133bbb08a78a6d3fd82da9c567323d4772a7fe69ab58aea6a65a6a3168e"
  license "MIT"

  depends_on :macos

  def install
    system "make", "CC=#{ENV.cc}"
    libexec.install "peon-poke", "config.json"
    libexec.install "adapters", "plugins", "bin"
    chmod 0755, libexec/"peon-poke"
    bin.install_symlink libexec/"bin/poke" => "poke"
    bin.install_symlink libexec/"peon-poke" => "peon-poke"
    bin.install_symlink libexec/"peon-poke" => "peon-poke-uninstall"
  end

  def caveats
    <<~EOS
      Run `peon-poke setup` to register hooks for detected agents
      (Claude Code, Codex, pi, oh-my-pi). Runtime installs to ~/.peon-poke
      so hook registrations survive upgrades.
    EOS
  end

  test do
    assert_match "names:", shell_output("#{bin}/poke definitely-not-a-pattern 2>&1")
  end
end
