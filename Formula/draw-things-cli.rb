class DrawThingsCli < Formula
  desc "Local inference and LoRA training CLI for Draw Things"
  homepage "https://github.com/drawthingsai/draw-things-community"
  url "https://github.com/drawthingsai/draw-things-community/archive/refs/tags/v1.20260320.0.tar.gz"
  head "https://github.com/drawthingsai/draw-things-community.git", branch: "main"
  sha256 "32323d9d759ee384ed962720a1e17bb16e29f3faf139d43cb02d90367a9f4533"
  license "GPL-3.0-or-later"

  depends_on macos: :ventura

  def install
    scratch_path = buildpath/".build"

    ENV["CLANG_MODULE_CACHE_PATH"] = buildpath/"clang-module-cache"
    system(
      "swift", "build", "--disable-sandbox", "--cache-path", buildpath/"swiftpm-cache",
      "--config-path", buildpath/"swiftpm-config", "--security-path",
      buildpath/"swiftpm-security", "--scratch-path", scratch_path, "-c", "release",
      "--product", "draw-things-cli")

    bin.install scratch_path/"release"/"draw-things-cli"

    (bash_completion/"draw-things-cli").write Utils.safe_popen_read(
      bin/"draw-things-cli", "completion", "bash")
    (zsh_completion/"_draw-things-cli").write Utils.safe_popen_read(
      bin/"draw-things-cli", "completion", "zsh")
    (fish_completion/"draw-things-cli.fish").write Utils.safe_popen_read(
      bin/"draw-things-cli", "completion", "fish")
  end

  test do
    assert_match "draw-things-cli", shell_output("#{bin}/--help")
    assert_match "--model", shell_output("#{bin}/generate --help")
    assert_match "models list", shell_output("#{bin}/models --help")
  end
end
