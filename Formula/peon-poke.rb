class PeonPoke < Formula
  desc "Trackpad haptic notifications on Mac for when your AI coding agent needs you"
  homepage "https://github.com/romeobravo/peon-poke"
  url "https://github.com/romeobravo/peon-poke/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "475e72e1d69bba0ad3842aecb79cf9f5c9c445862ccd574a732efb58489015f7"
  license "MIT"

  depends_on :macos

  def install
    system "make", "CC=#{ENV.cc}"
    libexec.install "poke.sh", "peon-poke-setup", "config.json"
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
