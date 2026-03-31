class DrawThingsCli < Formula
  desc "Local inference and LoRA training CLI for Draw Things"
  homepage "https://github.com/drawthingsai/draw-things-community"
  url "https://github.com/drawthingsai/draw-things-community/releases/download/v1.20260330.0/draw-things-cli"
  version "1.20260330.0"
  sha256 "cb724b816e0715a9c5450e9bea2eab27b3fc12447b1c2e764398c25327be3911"
  license "GPL-3.0-or-later"

  on_linux do
    disable! date: "2026-03-31", because: "is macOS-only"
  end

  head "https://github.com/drawthingsai/draw-things-community.git", branch: "main"

  depends_on macos: :ventura

  def install
    executable = if build.head?
      build_from_source
    else
      chmod 0555, "draw-things-cli"
      buildpath/"draw-things-cli"
    end

    bin.install executable

    generate_completions_from_executable(bin/"draw-things-cli", "completion")
  end

  test do
    assert_match "draw-things-cli", shell_output("#{bin}/--help")
    assert_match "--model", shell_output("#{bin}/generate --help")
    assert_match "models list", shell_output("#{bin}/models --help")
  end

  private

  def build_from_source
    scratch_path = buildpath/".build"

    ENV["CLANG_MODULE_CACHE_PATH"] = buildpath/"clang-module-cache"
    system(
      "swift", "build", "--disable-sandbox", "--cache-path", buildpath/"swiftpm-cache",
      "--config-path", buildpath/"swiftpm-config", "--security-path",
      buildpath/"swiftpm-security", "--scratch-path", scratch_path, "-c", "release",
      "--product", "draw-things-cli")

    scratch_path/"release"/"draw-things-cli"
  end
end
